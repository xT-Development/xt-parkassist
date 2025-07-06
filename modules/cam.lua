local config = lib.load('configs.client')
local UTILS = lib.load('modules.utils')
local UI = lib.load('modules.ui')

local reverseCam
local gameplayCam
local isActive = false
local lastBeep = 0

local defaultBones = {
    'platelight',
    'boot'
}

local MIN_BEEP_MS = 100
local MAX_BEEP_MS = 1000
local MAX_DETECT_DIST = 5.0

local cam_utils = {}

-- get distance from camera
function cam_utils.getDistanceFromCam(maxDist)
    local hit, _, endCoords = lib.raycast.fromCamera(511, 4, maxDist)

    if hit then
        local camPos = GetCamCoord(reverseCam)
        return #(camPos - endCoords)
    end

    return maxDist
end

-- get custom cam info
function cam_utils.getCustomCamInfo()
    local vehicle = cache.vehicle
    local isAllowedVehicle = UTILS.isAllowedVehicle(vehicle)
    if not isAllowedVehicle then return end

    local vehicleModel = GetEntityModel(vehicle)

    for model, info in pairs(config.customCamsByModel) do
        if vehicleModel == joaat(model) then
            UTILS.debug(('Custom cam info found for %s'):format(GetDisplayNameFromVehicleModel(vehicleModel)))
            return info?.coords or vec3(0.0, 0.1, 0.3), info?.rotation or vec3(0.0, 0.0, 180.0), info?.bone or bone, info?.camProximity or config.defaultCamProximity
        end
    end

    UTILS.debug(('No custom cam info found for %s'):format(GetDisplayNameFromVehicleModel(vehicleModel)))

    -- get default bone
    local bone
    for x = 1, #defaultBones do
        if GetEntityBoneIndexByName(vehicle, defaultBones[x]) ~= -1 then
            bone = defaultBones[x]
            break
        end
    end

    return vec3(0.0, 0.1, 0.3), vec3(0.0, 0.0, 180.0), bone, config.defaultCamProximity
end

-- toggle reverse cam
function cam_utils.reverseCam(toggle)
    local vehicle = cache.vehicle
    local isAllowedVehicle = UTILS.isAllowedVehicle(vehicle)
    if not isAllowedVehicle then return end

    isActive = toggle
    UI.toggleUI(isActive)

    if toggle then -- create the cam
        local customCoords, customRotation, customBone, customProximity = cam_utils.getCustomCamInfo()
        local boneIndex = GetEntityBoneIndexByName(vehicle, customBone)
        if boneIndex == -1 then
            return
        end

        reverseCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)

        customCoords = customCoords or vec3(0.0, 0.1, 0.3)
        customRotation = customRotation or vec3(0.0, 0.0, 180.0)
        customProximity = customProximity or config.defaultCamProximity

        AttachCamToVehicleBone(
            reverseCam, vehicle, boneIndex, true,
            customRotation.x, customRotation.y, customRotation.z,
            customCoords.x, customCoords.y,  customCoords.z,
            false
        )
        RenderScriptCams(true, true, 1000, true, true)
        Wait(1000)

        SetTimecycleModifier('heliGunCam')
        SetTimecycleModifierStrength(1.0)

        CreateThread(function()
            while isActive do
                local inReverse = GetVehicleCurrentGear(vehicle) == 0
                local dist = cam_utils.getDistanceFromCam(customProximity)
                UI.updateDistance(dist, customProximity)

                if inReverse then
                    if dist < customProximity then
                        local t = dist / MAX_DETECT_DIST
                        local interval = math.floor(MIN_BEEP_MS + t * (MAX_BEEP_MS - MIN_BEEP_MS))
                        interval = math.max(MIN_BEEP_MS, math.min(MAX_BEEP_MS, interval))

                        if (GetGameTimer() - lastBeep) >= interval then
                            PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", true)
                            lastBeep = GetGameTimer()
                        end
                    end
                end
                Wait(0)
            end
        end)
    else -- destroy the cam
        ClearTimecycleModifier()
        SetTimecycleModifierStrength(0.0)
        RenderScriptCams(false, true, 1000, true, true)
        Wait(2000)
        DestroyCam(reverseCam, false)
    end
end
exports('reverseCam', cam_utils.reverseCam)

return cam_utils