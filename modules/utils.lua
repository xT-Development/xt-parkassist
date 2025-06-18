local config = lib.load('configs.client')

local utils = {}

-- debug
function utils.debug(...)
    if config.debug then
        lib.print.info(...)
    end
end

-- check if vehicle is allowed by class or model
function utils.isAllowedVehicle(vehicle)
    local class = GetVehicleClass(vehicle)
    local model = GetEntityModel(vehicle)

    -- check the vehicle class
    for _, blacklistedClass in pairs(config.blacklistedClasses) do
        if class == blacklistedClass then
            utils.debug(('Vehicle Denied by Class: %s'):format(GetDisplayNameFromVehicleModel(model)))
            return false
        end
    end

    -- check the vehicle model
    for _, blacklistedModel in pairs(config.blacklistedModels) do
        if model == joaat(blacklistedModel) then
            utils.debug(('Vehicle Denied by Model: %s'):format(GetDisplayNameFromVehicleModel(model)))
            return false
        end
    end

    utils.debug(('Vehicle Allowed: %s'):format(GetDisplayNameFromVehicleModel(model)))

    return true
end

return utils