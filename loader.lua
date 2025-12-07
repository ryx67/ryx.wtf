local Repo = 'https://raw.githubusercontent.com/ryx67/ryx.wtf/refs/heads/main/'
local Id = game.PlaceId

local Files = {
    'loader.lua',
    'games/76558904092080.lua',
    'gui/config.lua',
    'gui/gui.lua',
}

if not isfolder('ryx.wtf') then
    makefolder('ryx.wtf')
end

for _, File in ipairs(Files) do
    local Path = 'ryx.wtf/' .. File
    local Dir = 'ryx.wtf/' .. (File:match("(.*/)") or "")

    if not isfolder(Dir) then
        makefolder(Dir)
    end

    if not isfile(Path) then
        writefile(Path, game:HttpGet(Repo .. File))
    end
end

local GamePath = 'ryx.wtf/games/' .. Id .. '.lua'
if isfile(GamePath) then
    loadfile(GamePath)()
else
    warn('game script missing: ' .. GamePath)
end
