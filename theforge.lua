local playersService = cloneref(game:GetService('Players'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local runService = cloneref(game:GetService('RunService'))  
local tweenService = cloneref(game:GetService('TweenService'))
local debrisService = cloneref(game:GetService('Debris'))

local lplr = playersService.LocalPlayer

local vars = {
    tweenspeed = 55,
}

local function tweenTo(Position)
    local Root = lplr.Character.HumanoidRootPart
    local UpperPos = Vector3.new(Position.X, Position.Y, Position.Z)

    local Distance = (Root.Position - UpperPos).Magnitude
    local Tween = tweenService:Create(
        Root,
        TweenInfo.new(Distance / vars.tweenspeed, Enum.EasingStyle.Linear),
        { CFrame = CFrame.new(UpperPos) }
    )
    Tween:Play()
    Tween.Completed:Wait()
end

local function Noclip()
    for i, v in pairs(plr.Character:GetDescendants()) do
        if v:IsA("BasePart") and v.CanCollide == true then
            v.CanCollide = false
        end
    end
end

local function getRocks(Name)
    for k, i in pairs(workspace.Rocks:GetChildren()) do
        for z, v in pairs(i:GetChildren()) do
            if v:IsA('Part') and v:FindFirstChildOfClass('Model') then
                local Target = v:FindFirstChildOfClass('Model')
                if Target.Name == Name and Target:GetAttribute('Health') ~= 0 then
                    return Target
                end
            end
        end
    end
    return nil
end

while task.wait() do
Noclip()
tweenTo(getRocks('Pebble').PrimaryPart.Position)
replicatedStorage.Shared.Packages.Knit.Services.ToolService.RF.ToolActivated:InvokeServer('Pickaxe')
end

$ 
$ git config --global user.email rtho49401@gmail.com