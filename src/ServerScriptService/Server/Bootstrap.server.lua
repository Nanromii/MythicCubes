--!strict

local services = script.Parent.Services
local CombatService = require(services.CombatService)
local HomeService = require(services.HomeService)
local StarterSelectionService = require(services.StarterSelectionService)

HomeService.start()
StarterSelectionService.start()
CombatService.start()

print("[VoxelCreatures] Phase 3 server started")
