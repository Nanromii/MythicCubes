--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RemoteFactory = {}

function RemoteFactory.getFolder(): Folder
    local existing = ReplicatedStorage:FindFirstChild("Remotes")
    if existing ~= nil then
        assert(existing:IsA("Folder"), "ReplicatedStorage.Remotes must be a Folder")
        return existing
    end
    local folder = Instance.new("Folder")
    folder.Name = "Remotes"
    folder.Parent = ReplicatedStorage
    return folder
end

function RemoteFactory.getFunction(name: string): RemoteFunction
    local folder = RemoteFactory.getFolder()
    local existing = folder:FindFirstChild(name)
    if existing ~= nil then
        assert(existing:IsA("RemoteFunction"), `{name} must be a RemoteFunction`)
        return existing
    end
    local remote = Instance.new("RemoteFunction")
    remote.Name = name
    remote.Parent = folder
    return remote
end

function RemoteFactory.getEvent(name: string): RemoteEvent
    local folder = RemoteFactory.getFolder()
    local existing = folder:FindFirstChild(name)
    if existing ~= nil then
        assert(existing:IsA("RemoteEvent"), `{name} must be a RemoteEvent`)
        return existing
    end
    local remote = Instance.new("RemoteEvent")
    remote.Name = name
    remote.Parent = folder
    return remote
end

return table.freeze(RemoteFactory)
