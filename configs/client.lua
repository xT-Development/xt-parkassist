return {
    debug = false,

    defaultCamProximity = 5.0, -- default max camera distance for alerts

    blacklistedClasses = { 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 19, 20, 21, 22 }, -- classes not allowed to use the park assist

    blacklistedModels = { -- vehicle models not allowed to use park assis
        'modelHere',
        'modelHere',
        'modelHere'
    },

    customCamsByModel = {   -- custom cam settings for specific vehicle models. all option values, set what you need
        ['modelHere'] = {
            offset = vector3(1.0, 2.0, 3.0),
            rotation = vector3(1.0, 2.0, 3.0),
            bone = 'bonnet',
            camProximity = 5.0
        }
    }
}