local function foundSpookTree()
	for _, region in next, workspace:GetChildren() do
		if region.Name ~= "TreeRegion" then continue end

		for _, tree in next, region:GetChildren() do
			if tree:FindFirstChild("TreeClass") then
				if tree.TreeClass.Value == "Spooky" or tree.TreeClass.Value == "SpookyNeon" then
					return tree
				end
			end
		end
	end

	return false
end

local function sendWebhook(url, data)
	local requestFunction = syn.request or request or http_request or HttpPost

	requestFunction({
		URl = url;
		Body = game:GetService("HttpService"):JSONEncode(data);
		Method = "POST";
		Headers = {["content-type"] = "application/json"}
	})
end

local function serverHop()
	local servers = "https://games.roblox.com/v1/games/13822889/servers/Public?sortOrder=Asc&limit=100"

	local server, nextServer

	repeat
		local rawData = game:GetService("HttpService"):JSONDecode(game:HttpGet(servers.."&cursor="..nextServer or ""))
		local randomServer = math.random(1, #rawData.data)
		nextServer = rawData.nextPageCursor
	until server

	game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, server.id, game:GetService("Players").LocalPlayer)
end

local tree = foundSpookTree()

if not tree then
	queue_on_teleport([[
		loadstring(game:HttpGet("https://github.com/NorthernCode-0/lua/scripts/main/TreeFinder.lua"))
	]])
	return serverHop()
end

local url = "https://discord.com/api/webhooks/1160701634725281862/zfCU-C2MXOHns4K41PZQhYQ_aNOvOYiaBDFazOAu1z0quxTskKDXwUjMjzjcFsISItk9"

sendWebhook(url, {
    embeds = {
        {
            title = ("%s tree found"):format(tree.TreeClass.Value);
            description = "Model Size - x",
            color = nil,
            fields = {
                {
                    name = "Join Server",
                    value = ([[game:GetService("TeleportService"):TeleportToPlaceInstance(%d, "%s", game:GetService("Players").LocalPlayer)]]):format(game.PlaceId, game.JobId)
                },
                {
                    name = "Teleport [When in server]",
                    value = ([[game:GetService("Players").LocalPlayer.Character:PivotTo(CFrame.new(%d, %d, %d))]]):format(tree:GetPivot().X, tree:GetPivot().Y, tree:GetPivot().Z)
                }
            }
        }
    }
})
