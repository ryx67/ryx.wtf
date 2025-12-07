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

for _, v in ipairs(Files) do
    local Path = 'ryx.wtf/' .. v
    local Dir = 'ryx.wtf/' .. (v:match("(.*/)") or "")

    if not isfolder(Dir) then
        makefolder(Dir)
    end

    local Remote = game:HttpGet(Repo .. v)
    local Local = isfile(Path) and readfile(Path) or nil

    if Local ~= Remote then
        writefile(Path, Remote)
    end
end

local GamePath = 'ryx.wtf/games/' .. Id .. '.lua'
if isfile(GamePath) then
    loadfile(GamePath)()
else
    warn('[warn] -> game script missing: ' .. GamePath)
end