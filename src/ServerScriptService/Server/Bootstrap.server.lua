--!strict

local services = script.Parent.Services
local CaptureService = require(services.CaptureService)
local CollectionService = require(services.CollectionService)
local CompanionService = require(services.CompanionService)
local EncounterService = require(services.EncounterService)
local OnboardingService = require(services.OnboardingService)
local RegionalWildService = require(services.RegionalWildService)
local StarterSelectionService = require(services.StarterSelectionService)
local VillageService = require(services.VillageService)

VillageService.start()
CollectionService.start()
CompanionService.start()
OnboardingService.start()
StarterSelectionService.start()
RegionalWildService.start()
EncounterService.start()
CaptureService.start()

print("[VoxelCreatures] Phase 5 server started")
