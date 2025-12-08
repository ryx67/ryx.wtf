local playersService = cloneref(game:GetService('Players'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local runService = cloneref(game:GetService('RunService'))  
local tweenService = cloneref(game:GetService('TweenService'))
local debrisService = cloneref(game:GetService('Debris'))

getgenv().SecureMode = true
local Library = loadstring(game:HttpGet('https://raw.nebulasoftworks.xyz/starlight'))()  
local Icons = loadstring(game:HttpGet('https://raw.nebulasoftworks.xyz/nebula-icon-library-loader'))()

local lplr = playersService.LocalPlayer

local vars = {
    tweenspeed = 55,
    automine = true,
}

local npcs = {}
for i, v in ipairs(workspace.Proximity:GetChildren()) do
    if v:FindFirstChildOfClass('Humanoid') then
        table.insert(npcs, v)
    end
end

local npcnames = {}
for i, v in ipairs(npcs) do
    table.insert(npcnames, v.Name)
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
				if Target.Name == Name and Target:FindFirstChild('Hitbox') and Target:GetAttribute('Health') > 0 then
					return Target.Hitbox
				end
			end
		end
	end
end

local Window = Library:CreateWindow({
    Name = 'ryx.wtf - The Forge',
    Subtitle = 'v1.0',
    Icon = 124905402582719,
    InterfaceAdvertisingPrompts = false,

    LoadingSettings = {
        Title = 'My Script Hub',
        Subtitle = 'Welcome to My Script Hub',
    },

    FileSettings = {
        ConfigFolder = 'MyScript'
    },
})

Window:CreateHomeTab({
    SupportedExecutors = {'Ronix', 'Delta', 'Codex', 'Xeno', 'Solara'}, 
    UnsupportedExecutors = {},
    DiscordInvite = '1234',
    Backdrop = nil,
    IconStyle = 1, 
    Changelog = {
        {
            Title = 'Example Update',
            Date = '25th october twentyfive',
            Description = 'blablblablajana \n blabakjakd',
        }
    }
})

local sections = {
    farm = Window:CreateTabSection('Farming'),
    world = Window:CreateTabSection('Worlds'),
    settings = Window:CreateTabSection('Settings')
}

local tabs = {
    mine = sections.farm:CreateTab({
        Name = 'Mine',
        Icon = Icons:GetIcon('pickaxe', 'Lucide'),
        Columns = 2,
    }, 'INDEX'),

    teleport = sections.world:CreateTab({
        Name = 'Worlds',
        Icon = Icons:GetIcon('map', 'Lucide'),
        Columns = 2,
    }, 'INDEX'),

    theme = sections.settings:CreateTab({
        Name = 'Theme',
        Icon = Icons:GetIcon('palette', 'Lucide'),
        Columns = 2,
    }, 'INDEX'),

    config = sections.settings:CreateTab({
        Name = 'Config',
        Icon = Icons:GetIcon('package-check', 'Lucide'),
        Columns = 2,
    }, 'INDEX'),
}

local groups = {
    mining = tabs.mine:CreateGroupbox({
        Name = 'Mining',
        Column = 1,
    }, 'INDEX'),

    mobs = tabs.mine:CreateGroupbox({
        Name = 'Mobs',
        Column = 1,
    }, 'INDEX'),

    npc = tabs.teleport:CreateGroupbox({
        Name = 'Npc',
        Column = 1,
    }, 'INDEX'),

    forge = tabs.teleport:CreateGroupbox({
        Name = 'Forge',
        Column = 2,
    }, 'INDEX')
}

local automine = groups.mining:CreateToggle({
    Name = 'Auto attack ores',
    CurrentValue = false,
    Style = 2,
    Callback = function(Value)
        vars.automine = Value
    end,
}, 'INDEX')

for i, v in ipairs(npcnames) do
    groups.npc:CreateButton({
        Name = v,
        Icon = Icons:GetIcon('circle-arrow-right', 'Lucide'),
        Style = 1,
        Callback = function()
            local Entities = nil
            for _, k in ipairs(npcs) do
                if k.Name == v then
                    Entities = k
                    break
                end
            end
            if Entities then
                tweenTo(Entities.HumanoidRootPart.Position)
            end
        end,
    }, "INDEX")
end

groups.forge:CreateButton({
        Name = 'Forge',
        Icon = Icons:GetIcon('circle-arrow-right', 'Lucide'),
        Style = 1,
        Callback = function()
            local Forge = workspace.Forges:FindFirstChildOfClass('Model')
            if Forge then
                tweenTo(Forge.CFrames.CrucibleMelt.Position)
            end
        end,
}, "INDEX")

tabs.theme:BuildThemeGroupbox(1)
Library:LoadAutoloadTheme()

while task.wait() do
    local Candidates = getRocks('Pebble')
    if Candidates and vars.automine then
        tweenTo(getRocks('Pebble').Position)
        replicatedStorage.Shared.Packages.Knit.Services.ToolService.RF.ToolActivated:InvokeServer('Pickaxe')
        Noclip()
    else
        task.wait(0.16741)
    end
end