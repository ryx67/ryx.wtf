local Repo = 'https://raw.githubusercontent.com/ryx67/ryx.wtf/refs/heads/main/'

local suc, res = pcall(function()
    return loadstring(game:HttpGet(Repo .. 'games/' .. game.PlaceId .. '.lua'))()
end)

if not suc or res == '404: Not Found' then
    print('[ryx] -> game not supported')
end