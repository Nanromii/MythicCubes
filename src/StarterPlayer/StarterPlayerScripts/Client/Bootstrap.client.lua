--!strict

local StarterSelectionController = require(script.Parent.Controllers.StarterSelectionController)
local WorldController = require(script.Parent.Controllers.WorldController)

local worldControllerStarted = false

local function startWorldController()
    if worldControllerStarted then
        return
    end

    worldControllerStarted = true
    WorldController.start()
end

StarterSelectionController.start(function(_starterId: string)
    task.defer(startWorldController)
end)

print("[VoxelCreatures] Phase 4 client started")
