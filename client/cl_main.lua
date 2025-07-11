local UTILS = lib.load('modules.utils')
local CAM_UTILS = lib.load('modules.cam')
local toggleKey = lib.load('configs.client').toggleKey

local parkAssist = false

local function toggleParkAssist()
    local inValidVehicle = UTILS.isAllowedVehicle(cache.vehicle)
    if not inValidVehicle then return end

    parkAssist = not parkAssist

    CAM_UTILS.reverseCam(parkAssist)
end

lib.addKeybind({
    name = 'parkassist',
    description = 'Toggle Park Assist',
    defaultKey = toggleKey,
    onReleased = function(self)
        if not cache.vehicle then return end

        toggleParkAssist()
    end
})

lib.onCache('seat', function(newSeat)
    if newSeat ~= -1 then
        if parkAssist then
            parkAssist = false
            CAM_UTILS.reverseCam(parkAssist)
        end
        return
    end
end)