local GetService = game.GetService

local Players = GetService(game, "Players")
local RunService = GetService(game, "RunService")

local LocalPlayer = Players.LocalPlayer

local Character, Head, HumanoidRootPart, Humanoid, Camera
local Backpack = LocalPlayer.Backpack
local Mouse = LocalPlayer:GetMouse()
Camera = workspace.CurrentCamera

local function ReLocalize()
    Character = LocalPlayer.Character

    Head = Character:WaitForChild("Head")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    Humanoid = Character:WaitForChild("Humanoid")
    Torso = Character:FindFirstChild("Torso") or Character:FindFirstChild("UpperTorso")
    PrimaryPart = Character.PrimaryPart
end

ReLocalize()

local function LookAt(Part1, PositionArg)
    local Position = CFrame.new(Part1.Position, PositionArg)
    Part1.CFrame = Position
end

local function QuadraticBezier(t, p0, p1, p2)
    return (1 - t) ^ 2 * p0 + 2 * (1 - t) * t * p1 + t ^ 2 * p2 -- weird ass fucking forumla 
end

local function CreatePartAtPosition(Position)
    local Part = Instance.new("Part")
    do
        Part.Position = Position
        Part.Parent = workspace
        Part.Name = "PathFindingBulb"
        Part.Anchored = true
        Part.CanCollide = false
        Part.Shape = Enum.PartType.Ball
        Part.Material = Enum.Material.Neon
        local Hue = tick() % 10 / 10
        Part.Color = Color3.fromHSV(Hue, 1, 1)

        Part.Size = Vector3.new(0.5, 0.5, 0.5)
        Part.Transparency = 0
    end

    return Part
end

local function LookAt(Part1, PositionArg)
    local Position = CFrame.new(Part1.Position, PositionArg)
    Part1.CFrame = Position
end

local function DolphinDive(Start, End, CFrame, Quality, Delay, Break)

    if Break then
        break
    end
    local Curve = Instance.new("Part", workspace) -- Should've used CreatePartAtposition and added a cframe vararg argument (select(1, ...) or x) but i didnt care enough
    Curve.Transparency = 1
    Curve.Anchored = true
    Curve.CanCollide = false
    Curve.CFrame = End:Lerp(Start.CFrame, 0.5) * CFrame
    Curve.Name = LocalPlayer.Name

    

    local StablePos = Start.Position

    local number = 0
    for t = 0, 1, Quality do
        local TargetPosition = QuadraticBezier(t, StablePos, Curve.Position, End.p)
        local a = CreatePartAtPosition(TargetPosition)
        HumanoidRootPart.CFrame = a.CFrame
        LookAt(HumanoidRootPart, End.p)

        task.spawn(
            function()
                task.wait(3)
                a:Destroy()
            end
        ) -- could've handled visualizer cleanup better but who cares

        if number ~= Delay then -- Weird Delay Thing I made its very stupid and i should've just used the modulus operator but its much simpler so
            number = number + 1
        elseif number == Delay then
            number = 0
            task.wait(0.0000001)
        end
    end
end

local function GetDistance(Vector3_1, Vector3_2)
    return (Vector3_1 - Vector3_2).Magnitude
end

LocalPlayer.CharacterAdded:Connect(ReLocalIze)

-- Example

return DolphinDive;
