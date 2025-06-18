local lastDistance = 0
local isVisible = false

local ui = {}

function ui.toggleUI(toggle)
    isVisible = toggle

    SendNuiMessage(json.encode({
        action = 'toggleDistanceUI',
        visible = toggle
    }))
end

function ui.updateDistance(dist, maxDist)
    if not isVisible or lastDistance == dist then
        return
    end

    lastDistance = dist

    SendNuiMessage(json.encode({
        action = 'updateDistance',
        dist = dist,
        maxDist = maxDist,
    }))
end

return ui