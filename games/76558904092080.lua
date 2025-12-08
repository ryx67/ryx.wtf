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
    rocks = 'Pebble',
    noclip = true,
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

local shops = {}
for i, v in ipairs(workspace.Shops:GetChildren()) do
    table.insert(shops, v)
end

local function tweenTo(Position)
    local Root = lplr.Character.HumanoidRootPart
    local Pos = Vector3.new(Position.X, Position.Y, Position.Z)

    local Distance = (Root.Position - Pos).Magnitude
    local Tween = tweenService:Create(
        Root,
        TweenInfo.new(Distance / vars.tweenspeed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
        {
            CFrame = CFrame.new(Pos)
        }
    )
    Tween:Play()
end

local function Noclip()
    for i, v in pairs(lplr.Character:GetDescendants()) do
        if v:IsA('Part') and v.CanCollide == true then
            v.CanCollide = vars.noclip
        end
    end
end

local function getRocks(Name)
	for _, i in pairs(workspace.Rocks:GetChildren()) do
		for _, v in pairs(i:GetChildren()) do
			if v:IsA('Part') and v:FindFirstChildOfClass('Model') then
				local Target = v:FindFirstChild(Name)
				if Target and Target:FindFirstChild('Hitbox') and Target:GetAttribute('Health') > 0 then
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
        ConfigFolder = 'ryx.gg'
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
            Title = 'v1.0',
            Date = '12/8/25',
            Description = 'Initial Release',
        }
    }
})

local sections = {
    farm = Window:CreateTabSection('Farming'),
    world = Window:CreateTabSection('Worlds'),
    misc = Window:CreateTabSection('Miscellaneous'),
    settings = Window:CreateTabSection('Settings')
}

local tabs = {
    mine = sections.farm:CreateTab({
        Name = 'Farming',
        Icon = Icons:GetIcon('pickaxe', 'Lucide'),
        Columns = 2,
    }, 'INDEX'),

    teleport = sections.world:CreateTab({
        Name = 'Worlds',
        Icon = Icons:GetIcon('map', 'Lucide'),
        Columns = 2,
    }, 'INDEX'),

    miscellaneous = sections.misc:CreateTab({
        Name = 'Miscellaneous',
        Icon = Icons:GetIcon('cross', 'Lucide'),
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
        Column = 2,
    }, 'INDEX'),

    npc = tabs.teleport:CreateGroupbox({
        Name = 'Npc',
        Column = 1,
    }, 'INDEX'),

    forge = tabs.teleport:CreateGroupbox({
        Name = 'Forge',
        Column = 2,
    }, 'INDEX'),

    shop = tabs.teleport:CreateGroupbox({
        Name = 'Shop',
        Column = 2,
    }, 'INDEX'),

    globals = tabs.miscellaneous:CreateGroupbox({
        Name = 'Globals',
        Column = 1,
    }, 'INDEX')
}

groups.mining:CreateDivider()
local automine = groups.mining:CreateToggle({
    Name = 'Auto attack ores',
    CurrentValue = false,
    Style = 2,
    Callback = function(Value)
        vars.automine = Value
    end,
}, 'INDEX')

local rocks = automine:AddDropdown({
    Options = {'Pebble', 'Rock', 'Boulder', 'Lucky Block', 'Basalt Rock', 'Basalt Core', 'Basalt Vein', 'Volcanic Rock', 'Earth Crystal', 'Cyan Crystal', 'Crimson Crystal', 'Violet Crystal', 'Light Crystal'},
    CurrentOptions = {'Pebble'},
    Placeholder = 'Select Rock',
    Callback = function(Options)
        vars.rocks = Options[1]
    end,
}, 'INDEX')

groups.npc:CreateDivider()
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
    }, 'INDEX')
end

groups.forge:CreateDivider()
groups.forge:CreateButton({
        Name = 'Forging Station',
        Icon = Icons:GetIcon('circle-arrow-right', 'Lucide'),
        Style = 1,
        Callback = function()
            local Forge = workspace.Forges:FindFirstChildOfClass('Model')
            if Forge then
                tweenTo(Forge.CFrames.CrucibleMelt.Position)
            end
        end,
}, 'INDEX')

groups.shop:CreateDivider()
for i, v in ipairs(shops) do
    if v.Name ~= 'Forging Station' and v.Name ~= 'Model' then
           groups.shop:CreateButton({
              Name = v.Name,
              Icon = Icons:GetIcon('circle-arrow-right', 'Lucide'),
              Style = 1,
              Callback = function()
                tweenTo(v:GetPivot().Position)
            end,
        }, 'INDEX')
    end
 end

 groups.globals:CreateDivider()
 local tweenspeed = groups.globals:CreateSlider({
    Name = 'Tween speed',
    Icon = Icons:GetIcon('speed', 'Material'),
    Range = {0, 120},
    Increment = 1,
    CurrentValue = vars.tweenspeed,
    Callback = function(Value)
        vars.tweenspeed = Value
    end,
}, 'INDEX')

groups.globals:CreateLabel({
    Name = '-> 90/91 is RECOMMENDED',
    Icon = Icons:GetIcon('info', 'Material'),
}, 'INDEX')

local noclip = groups.globals:CreateToggle({
    Name = 'Noclip when tweening',
    CurrentValue = true,
    Style = 2,
    Callback = function(Value)
        vars.noclip = Value
    end,
}, 'INDEX')

tabs.theme:BuildThemeGroupbox(1)
Library:LoadAutoloadTheme()

while task.wait() do
    if vars.automine and lplr.Character then
        local Candidates = getRocks(vars.rocks)
        if Candidates then
            tweenTo(Candidates.Position)
            task.wait(0.2)
            replicatedStorage.Shared.Packages.Knit.Services.ToolService.RF.ToolActivated:InvokeServer('Pickaxe');
            Noclip()
        end
    else
        task.wait(0.16741)
    end
end