local Repo = 'https://raw.githubusercontent.com/ryx67/ryx.wtf/refs/heads/main/'
local Id = game.PlaceId

local Files = {
    'loader.lua',
    'games/76558904092080.lua',
    'gui/config.lua',
    'gui/gui.lua',
}

local RemoteHash = game:HttpGet(Repo .. "version.txt")
local HashPath = 'ryx.wtf/version.txt'
local LocalHash = isfile(HashPath) and readfile(HashPath) or ""
local Outdated = LocalHash ~= RemoteHash

if not isfolder('ryx.wtf') then
    makefolder('ryx.wtf')
end

for _, v in ipairs(Files) do
    local Path = 'ryx.wtf/' .. v
    local Dir = 'ryx.wtf/' .. (v:match("(.*/)") or "")

    if not isfolder(Dir) then
        makefolder(Dir)
    end

    if Outdated or not isfile(Path) then
        writefile(Path, game:HttpGet(Repo .. v))
    end
end

writefile(HashPath, RemoteHash)

local GamePath = 'ryx.wtf/games/' .. Id .. '.lua'
if isfile(GamePath) then
    loadfile(GamePath)()
else
    warn('[warn] -> game script missing: ' .. GamePath)
end