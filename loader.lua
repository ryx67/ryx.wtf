local games = {
    [76558904092080] = 'https://raw.githubusercontent.com/ryx67/ryx.wtf/refs/heads/main/games/76558904092080.lua',
}

for i, v in pairs(games) do
    if game.GameId == i then
        loadstring(game:HttpGet(v))()
    end
end