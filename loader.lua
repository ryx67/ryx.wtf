local repo = 'https://raw.githubusercontent.com/ryx67/ryx.wtf/refs/heads/main/'
local id = game.PlaceId

local files = {
    'loader.lua',
    'games/theforge.lua',
    'gui/config.lua',
    'gui/gui.lua',
}

for i, v in pairs(files) do
    if not isfolder('ryx.wtf') then
        makefolder('ryx.wtf')
    end

    if not isfile('ryx.wtf/' .. v) then
        local dir = 'ryx.wtf/' .. v:match("(.*/)")
        if not isfolder(dir) then
            makefolder(dir)
        end

        writefile('ryx.wtf/' .. v, game:HttpGet(repo .. v))
    end

    loadfile('ryx.wtf/games/' .. id .. '.lua')()
end