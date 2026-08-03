--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CreatureDataRegistry = require(ReplicatedStorage.Shared.Config.CreatureDataRegistry)
local RemoteNames = require(ReplicatedStorage.Shared.Constants.RemoteNames)
local CombatTypes = require(ReplicatedStorage.Shared.Types.CombatTypes)

type CombatResponse = CombatTypes.CombatResponse
type CombatSnapshot = CombatTypes.CombatSnapshot
type CombatantSnapshot = CombatTypes.CombatantSnapshot
type UnknownTable = { [unknown]: unknown }

local REMOTE_WAIT_TIMEOUT_SECONDS = 10
local PANEL_COLOR = Color3.fromRGB(31, 38, 48)
local TEXT_COLOR = Color3.fromRGB(244, 246, 248)
local MUTED_COLOR = Color3.fromRGB(186, 196, 207)
local ACTION_COLOR = Color3.fromRGB(80, 167, 116)
local DISABLED_COLOR = Color3.fromRGB(88, 96, 106)

local CombatController = {}

local RESPONSE_MESSAGES: { [string]: string } = table.freeze({
    NO_COMBAT = "Sẵn sàng bắt đầu trận đấu.",
    COMBAT_FOUND = "Đã tải trạng thái trận đấu.",
    INVALID_REQUEST = "Yêu cầu không hợp lệ.",
    RATE_LIMITED = "Bạn thao tác quá nhanh. Vui lòng chờ một chút.",
    COMBAT_ALREADY_ACTIVE = "Một trận đấu đang diễn ra.",
    STARTER_REQUIRED = "Hãy chọn thú đồng hành trước khi chiến đấu.",
    COMBAT_CREATION_FAILED = "Không thể tạo trận đấu.",
    COMBAT_STARTED = "Trận đấu đã bắt đầu.",
    COMBAT_NOT_FOUND = "Không tìm thấy trận đấu.",
    NOT_COMBAT_OWNER = "Bạn không sở hữu trận đấu này.",
    DUPLICATE_REQUEST = "Yêu cầu này đã được xử lý.",
    COMBAT_NOT_ACTIVE = "Trận đấu hiện không hoạt động.",
    COMBATANT_NOT_FOUND = "Không tìm thấy sinh vật chiến đấu.",
    NOT_COMBATANT_OWNER = "Bạn không điều khiển sinh vật này.",
    COMBATANT_DEFEATED = "Sinh vật này đã bị đánh bại.",
    SKILL_NOT_FOUND = "Không tìm thấy kỹ năng.",
    SKILL_NOT_EQUIPPED = "Kỹ năng chưa được trang bị.",
    SKILL_ON_COOLDOWN = "Kỹ năng đang hồi chiêu.",
    TARGET_NOT_FOUND = "Không tìm thấy mục tiêu.",
    TARGET_DEFEATED = "Mục tiêu đã bị đánh bại.",
    UNSUPPORTED_SKILL_EFFECT = "Hiệu ứng kỹ năng này chưa được hỗ trợ.",
    INVALID_TARGET = "Mục tiêu không hợp lệ.",
    INVALID_ELEMENT = "Dữ liệu hệ nguyên tố không hợp lệ.",
    DAMAGE_APPLIED = "Kỹ năng đã gây sát thương.",
})

local STATUS_TEXT: { [string]: string } = table.freeze({
    Preparing = "Đang chuẩn bị",
    Active = "Đang chiến đấu",
    Finished = "Đã kết thúc",
})

local function waitForRemoteFunction(parent: Instance, remoteName: string): RemoteFunction
    local remote = parent:WaitForChild(remoteName, REMOTE_WAIT_TIMEOUT_SECONDS)
    assert(remote ~= nil, `{remoteName} was not created by the server`)
    assert(remote:IsA("RemoteFunction"), `{remoteName} must be a RemoteFunction`)
    return remote
end

local function waitForRemoteEvent(parent: Instance, remoteName: string): RemoteEvent
    local remote = parent:WaitForChild(remoteName, REMOTE_WAIT_TIMEOUT_SECONDS)
    assert(remote ~= nil, `{remoteName} was not created by the server`)
    assert(remote:IsA("RemoteEvent"), `{remoteName} must be a RemoteEvent`)
    return remote
end

local function addCorner(instance: GuiObject, radius: number)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = instance
end

local function readCombatant(value: unknown): CombatantSnapshot?
    if typeof(value) ~= "table" then
        return nil
    end

    local combatant = value :: UnknownTable

    if
        typeof(combatant.id) ~= "string"
        or (combatant.side ~= "Player" and combatant.side ~= "Enemy")
        or typeof(combatant.creatureId) ~= "string"
        or typeof(combatant.currentHealth) ~= "number"
        or typeof(combatant.maximumHealth) ~= "number"
        or typeof(combatant.alive) ~= "boolean"
        or typeof(combatant.equippedSkillIds) ~= "table"
        or typeof(combatant.skillCooldowns) ~= "table"
    then
        return nil
    end

    return combatant :: CombatantSnapshot
end

local function readSnapshot(value: unknown): CombatSnapshot?
    if typeof(value) ~= "table" then
        return nil
    end

    local snapshot = value :: UnknownTable

    if
        typeof(snapshot.id) ~= "string"
        or (snapshot.status ~= "Preparing" and snapshot.status ~= "Active" and snapshot.status ~= "Finished")
        or typeof(snapshot.combatants) ~= "table"
    then
        return nil
    end

    if
        snapshot.winnerSide ~= nil
        and snapshot.winnerSide ~= "Player"
        and snapshot.winnerSide ~= "Enemy"
    then
        return nil
    end

    for _, combatantValue in snapshot.combatants :: UnknownTable do
        if readCombatant(combatantValue) == nil then
            return nil
        end
    end

    return snapshot :: CombatSnapshot
end

local function readResponse(value: unknown): CombatResponse?
    if typeof(value) ~= "table" then
        return nil
    end

    local response = value :: UnknownTable

    if
        typeof(response.ok) ~= "boolean"
        or typeof(response.code) ~= "string"
        or typeof(response.message) ~= "string"
    then
        return nil
    end

    local snapshot = if response.snapshot == nil then nil else readSnapshot(response.snapshot)

    if response.snapshot ~= nil and snapshot == nil then
        return nil
    end

    return {
        ok = response.ok :: boolean,
        code = response.code :: string,
        message = response.message :: string,
        snapshot = snapshot,
    }
end

local function invoke(remote: RemoteFunction, request: unknown?): (CombatResponse?, string?)
    local succeeded, rawResponse = pcall(function(): unknown
        if request == nil then
            return remote:InvokeServer()
        end

        return remote:InvokeServer(request)
    end)

    if not succeeded then
        return nil, "Không thể kết nối tới máy chủ chiến đấu."
    end

    local response = readResponse(rawResponse)

    if response == nil then
        return nil, "Máy chủ chiến đấu trả về dữ liệu không hợp lệ."
    end

    return response, nil
end

local function createLabel(parent: Instance, name: string, position: UDim2, size: UDim2): TextLabel
    local label = Instance.new("TextLabel")
    label.Name = name
    label.BackgroundTransparency = 1
    label.Position = position
    label.Size = size
    label.Font = Enum.Font.Gotham
    label.TextColor3 = TEXT_COLOR
    label.TextSize = 15
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    return label
end

local function createButton(
    parent: Instance,
    name: string,
    text: string,
    position: UDim2
): TextButton
    local button = Instance.new("TextButton")
    button.Name = name
    button.Position = position
    button.Size = UDim2.new(1, -32, 0, 44)
    button.AutoButtonColor = false
    button.BackgroundColor3 = ACTION_COLOR
    button.BorderSizePixel = 0
    button.Font = Enum.Font.GothamBold
    button.Text = text
    button.TextColor3 = TEXT_COLOR
    button.TextSize = 15
    button.Parent = parent
    addCorner(button, 8)
    return button
end

local function createInterface(playerGui: PlayerGui)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CombatGui"
    screenGui.AutoLocalize = false
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui

    local panel = Instance.new("Frame")
    panel.Name = "Panel"
    panel.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.Position = UDim2.fromScale(0.5, 0.5)
    panel.Size = UDim2.fromOffset(420, 350)
    panel.BackgroundColor3 = PANEL_COLOR
    panel.BorderSizePixel = 0
    panel.Parent = screenGui
    addCorner(panel, 14)

    local title = createLabel(panel, "Title", UDim2.fromOffset(16, 14), UDim2.new(1, -32, 0, 30))
    title.Font = Enum.Font.GothamBold
    title.Text = "CHIẾN ĐẤU"
    title.TextSize = 21

    local stateLabel =
        createLabel(panel, "State", UDim2.fromOffset(16, 48), UDim2.new(1, -32, 0, 24))
    stateLabel.Text = "Trạng thái: đang tải..."
    local playerHealth =
        createLabel(panel, "PlayerHealth", UDim2.fromOffset(16, 80), UDim2.new(1, -32, 0, 24))
    playerHealth.Text = "Thú của bạn: --"
    local enemyHealth =
        createLabel(panel, "EnemyHealth", UDim2.fromOffset(16, 108), UDim2.new(1, -32, 0, 24))
    enemyHealth.Text = "Đối thủ: --"
    local feedback =
        createLabel(panel, "Feedback", UDim2.fromOffset(16, 142), UDim2.new(1, -32, 0, 48))
    feedback.Text = "Đang tải trạng thái trận đấu..."
    feedback.TextColor3 = MUTED_COLOR

    local startButton =
        createButton(panel, "Start", "Bắt đầu trận đấu", UDim2.fromOffset(16, 224))
    local skillButton =
        createButton(panel, "Skill", "Chưa có kỹ năng", UDim2.fromOffset(16, 278))

    return stateLabel, playerHealth, enemyHealth, feedback, startButton, skillButton
end

local function findSide(snapshot: CombatSnapshot, side: string): CombatantSnapshot?
    for _, combatant in snapshot.combatants do
        if combatant.side == side then
            return combatant
        end
    end

    return nil
end

function CombatController.start()
    local playerGuiInstance = Players.LocalPlayer:WaitForChild("PlayerGui")
    assert(playerGuiInstance:IsA("PlayerGui"), "PlayerGui must be a PlayerGui")

    local remotes = ReplicatedStorage:WaitForChild("Remotes", REMOTE_WAIT_TIMEOUT_SECONDS)
    assert(remotes ~= nil, "ReplicatedStorage.Remotes is missing")
    local getCombatRemote = waitForRemoteFunction(remotes, RemoteNames.GET_COMBAT)
    local startCombatRemote = waitForRemoteFunction(remotes, RemoteNames.START_COMBAT)
    local useSkillRemote = waitForRemoteFunction(remotes, RemoteNames.USE_COMBAT_SKILL)
    local combatUpdatedRemote = waitForRemoteEvent(remotes, RemoteNames.COMBAT_UPDATED)
    local stateLabel, playerHealth, enemyHealth, feedback, startButton, skillButton =
        createInterface(playerGuiInstance)

    local currentSnapshot: CombatSnapshot? = nil
    local requestSequence = 0
    local requestInFlight = false

    local function setButtonEnabled(button: TextButton, enabled: boolean)
        button.Active = enabled and not requestInFlight
        button.BackgroundColor3 = if enabled and not requestInFlight
            then ACTION_COLOR
            else DISABLED_COLOR
    end

    local function render(snapshot: CombatSnapshot?)
        currentSnapshot = snapshot

        if snapshot == nil then
            stateLabel.Text = "Trạng thái: chưa có trận đấu"
            playerHealth.Text = "Thú của bạn: --"
            enemyHealth.Text = "Đối thủ: --"
            skillButton.Text = "Chưa có kỹ năng"
            setButtonEnabled(startButton, true)
            setButtonEnabled(skillButton, false)
            return
        end

        local playerCombatant = findSide(snapshot, "Player")
        local enemyCombatant = findSide(snapshot, "Enemy")
        stateLabel.Text = `Trạng thái: {STATUS_TEXT[snapshot.status] or "Không xác định"}`

        if playerCombatant ~= nil then
            local definition = CreatureDataRegistry.getCreature(playerCombatant.creatureId)
            local name = if definition == nil
                then playerCombatant.creatureId
                else definition.displayName
            playerHealth.Text =
                `Thú của bạn — {name}: {playerCombatant.currentHealth}/{playerCombatant.maximumHealth} HP`
        end

        if enemyCombatant ~= nil then
            local definition = CreatureDataRegistry.getCreature(enemyCombatant.creatureId)
            local name = if definition == nil
                then enemyCombatant.creatureId
                else definition.displayName
            enemyHealth.Text =
                `Đối thủ — {name}: {enemyCombatant.currentHealth}/{enemyCombatant.maximumHealth} HP`
        end

        setButtonEnabled(startButton, snapshot.status == "Finished")

        if snapshot.status == "Finished" then
            feedback.Text = if snapshot.winnerSide == "Player"
                then "Chiến thắng!"
                else "Thất bại."
        end

        if playerCombatant == nil or playerCombatant.equippedSkillIds[1] == nil then
            skillButton.Text = "Chưa có kỹ năng"
            setButtonEnabled(skillButton, false)
            return
        end

        local skillId = playerCombatant.equippedSkillIds[1]
        local skill = CreatureDataRegistry.getSkill(skillId)
        local remainingSeconds = 0

        for _, cooldown in playerCombatant.skillCooldowns do
            if cooldown.skillId == skillId then
                remainingSeconds = cooldown.remainingSeconds
                break
            end
        end

        local skillName = if skill == nil then skillId else skill.displayName
        skillButton.Text = if remainingSeconds > 0
            then `{skillName} ({math.ceil(remainingSeconds)} giây)`
            else skillName
        setButtonEnabled(
            skillButton,
            snapshot.status == "Active" and playerCombatant.alive and remainingSeconds <= 0
        )
    end

    startButton.Activated:Connect(function()
        if requestInFlight then
            return
        end

        requestInFlight = true
        feedback.Text = "Máy chủ đang tạo trận đấu..."
        render(currentSnapshot)
        local startResponse, requestError = invoke(startCombatRemote, {})
        requestInFlight = false

        if startResponse == nil then
            feedback.Text = requestError or "Không thể bắt đầu trận đấu."
            render(currentSnapshot)
            return
        end

        feedback.Text = RESPONSE_MESSAGES[startResponse.code]
            or "Đã xử lý yêu cầu trận đấu."
        render(startResponse.snapshot)
    end)

    skillButton.Activated:Connect(function()
        if requestInFlight or currentSnapshot == nil or currentSnapshot.status ~= "Active" then
            return
        end

        local playerCombatant = findSide(currentSnapshot, "Player")
        local enemyCombatant = findSide(currentSnapshot, "Enemy")

        if playerCombatant == nil or enemyCombatant == nil then
            return
        end

        local skillId = playerCombatant.equippedSkillIds[1]

        if skillId == nil then
            return
        end

        requestSequence += 1
        requestInFlight = true
        feedback.Text = "Máy chủ đang xác nhận kỹ năng..."
        render(currentSnapshot)
        local skillResponse, requestError = invoke(useSkillRemote, {
            combatId = currentSnapshot.id,
            requestId = `client-{requestSequence}`,
            combatantId = playerCombatant.id,
            skillId = skillId,
            targetId = enemyCombatant.id,
        })
        requestInFlight = false

        if skillResponse == nil then
            feedback.Text = requestError or "Không thể sử dụng kỹ năng."
            render(currentSnapshot)
            return
        end

        feedback.Text = RESPONSE_MESSAGES[skillResponse.code]
            or "Đã xử lý yêu cầu kỹ năng."
        render(skillResponse.snapshot or currentSnapshot)
    end)

    combatUpdatedRemote.OnClientEvent:Connect(function(rawSnapshot: unknown)
        local snapshot = readSnapshot(rawSnapshot)

        if snapshot ~= nil then
            render(snapshot)
        end
    end)

    render(nil)
    local currentCombatResponse, requestError = invoke(getCombatRemote, nil)

    if currentCombatResponse == nil then
        feedback.Text = requestError or "Không thể tải trạng thái trận đấu."
    else
        feedback.Text = RESPONSE_MESSAGES[currentCombatResponse.code]
            or "Đã tải trạng thái trận đấu."
        render(currentCombatResponse.snapshot)
    end
end

return table.freeze(CombatController)
