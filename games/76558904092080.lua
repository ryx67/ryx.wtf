local playersService = cloneref(game:GetService('Players'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local runService = cloneref(game:GetService('RunService'))  
local tweenService = cloneref(game:GetService('TweenService'))
local debrisService = cloneref(game:GetService('Debris'))

local Library = loadfile('ryx.wtf/gui/gui.lua')()
local Config = loadfile('ryx.wtf/gui/config.lua')()

local lplr = playersService.LocalPlayer

local vars = {
    tweenspeed = 55,
    automine = true,
}

local npcs = {}
for i, v in pairs(workspace.Proximity:GetChildren()) do
    if v:FindFirstChildOfClass('Humanoid') then
        table.insert(npcs, v)
    end
end

local function tweenTo(Position)
    local Root = lplr.Character.HumanoidRootPart
    local Pos = Vector3.new(Position.X, Position.Y, Position.Z)

    local Distance = (Root.Position - Pos).Magnitude
    local Tween = tweenService:Create(
        Root,
        TweenInfo.new(Distance / vars.tweenspeed, Enum.EasingStyle.Linear),
        {
            CFrame = CFrame.new(Pos)
        }
    )
    Tween:Play()
    Tween.Completed:Wait()
end

local function Noclip()
    for i, v in pairs(lplr.Character:GetDescendants()) do
        if v:IsA('Part') and v.CanCollide == true then
            v.CanCollide = false
        end
    end
end

local function getRocks(Name)
	for _, i in pairs(workspace.Rocks:GetChildren()) do
		for _, v in pairs(i:GetChildren()) do
			if v:IsA('Part') and v:FindFirstChildOfClass('Model') then
				local Target = v:FindFirstChildOfClass('Model')
				if Target.Name == Name and Target:GetAttribute('Health') > 0 then
					return Target.Hitbox
				end
			end
		end
	end
end

local Window = Library:Load({
      Title = 'ryx.wtf - 🎄Christmas',
      ToggleButton = "",
	  BindGui = Enum.KeyCode.RightControl,
})

local Main = Window:AddTab("Main")
Window:SelectTab()

local MainSection = Main:AddSection({
    Title = "Section Name",
    Description = "Description",
    Defualt = false ,
    Locked = false
})

MainSection:AddToggle("ConfigToStoreName", {
    Title = "Auti Mine",
    Default = false,
    Description = "lol",
    Callback = function(v)
        vars.automine = v
    end,
})

local Configs = Window:AddTab("Config")
Config:SetLibrary(Library)
Config:SetIgnoreIndexes({})
Config:SetFolder("ryx.wtf/configs/the forge")
Config:InitSaveSystem(Configs)

while task.wait() do
    local Slave = getRocks('Pebble')
    if Slave and vars.automine then
        tweenTo(getRocks('Pebble').Position)
        replicatedStorage.Shared.Packages.Knit.Services.ToolService.RF.ToolActivated:InvokeServer('Pickaxe')
        Noclip()
    else
        task.wait(0.16741)
    end
end