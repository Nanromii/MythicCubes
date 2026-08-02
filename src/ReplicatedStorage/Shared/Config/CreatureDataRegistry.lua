--!strict

local CreatureDefinitions = require(script.Parent.Parent.Definitions.CreatureDefinitions)
local ElementDefinitions = require(script.Parent.Parent.Definitions.ElementDefinitions)
local RoleDefinitions = require(script.Parent.Parent.Definitions.RoleDefinitions)
local SkillDefinitions = require(script.Parent.Parent.Definitions.SkillDefinitions)
local CreatureTypes = require(script.Parent.Parent.Types.CreatureTypes)
local ElementTypes = require(script.Parent.Parent.Types.ElementTypes)
local RoleTypes = require(script.Parent.Parent.Types.RoleTypes)
local SkillTypes = require(script.Parent.Parent.Types.SkillTypes)
local CreatureDataValidator = require(script.Parent.Parent.Utils.CreatureDataValidator)

type CreatureDefinition = CreatureTypes.CreatureDefinition
type ElementDefinition = ElementTypes.ElementDefinition
type RoleDefinition = RoleTypes.RoleDefinition
type SkillDefinition = SkillTypes.SkillDefinition

local catalog = table.freeze({
    elements = ElementDefinitions,
    roles = RoleDefinitions,
    skills = SkillDefinitions,
    creatures = CreatureDefinitions,
})

local catalogIsValid, catalogError = CreatureDataValidator.validateCatalog(catalog)
assert(catalogIsValid, `Invalid creature data catalog: {catalogError or "unknown error"}`)

local elementsById: { [string]: ElementDefinition } = {}
local rolesById: { [string]: RoleDefinition } = {}
local skillsById: { [string]: SkillDefinition } = {}
local creaturesById: { [string]: CreatureDefinition } = {}

for _, definition in ElementDefinitions do
    elementsById[definition.id] = definition
end

for _, definition in RoleDefinitions do
    rolesById[definition.id] = definition
end

for _, definition in SkillDefinitions do
    skillsById[definition.id] = definition
end

for _, definition in CreatureDefinitions do
    creaturesById[definition.id] = definition
end

local CreatureDataRegistry = {}

CreatureDataRegistry.elements = ElementDefinitions
CreatureDataRegistry.roles = RoleDefinitions
CreatureDataRegistry.skills = SkillDefinitions
CreatureDataRegistry.creatures = CreatureDefinitions

function CreatureDataRegistry.getElement(elementId: string): ElementDefinition?
    return elementsById[elementId]
end

function CreatureDataRegistry.getRole(roleId: string): RoleDefinition?
    return rolesById[roleId]
end

function CreatureDataRegistry.getSkill(skillId: string): SkillDefinition?
    return skillsById[skillId]
end

function CreatureDataRegistry.getCreature(creatureId: string): CreatureDefinition?
    return creaturesById[creatureId]
end

return table.freeze(CreatureDataRegistry)
