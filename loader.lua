local games = {
    [76558904092080] = 'https://raw.githubusercontent.com/ryx67/ryx.wtf/refs/heads/main/games/76558904092080.lua',
}

for i, v in pairs(games) do
    if game.PlaceId == i then
        loadstring(game:HttpGet(v))()
    else
        print('not supported')
    end
end