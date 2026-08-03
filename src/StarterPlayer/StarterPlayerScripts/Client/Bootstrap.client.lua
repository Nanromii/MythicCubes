--!strict

local CombatController = require(script.Parent.Controllers.CombatController)
local StarterSelectionController = require(script.Parent.Controllers.StarterSelectionController)

StarterSelectionController.start()
CombatController.start()

print("[VoxelCreatures] Phase 3 client started")
