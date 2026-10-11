local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local API_URL = "https://lisensi-production-b7c2.up.railway.app/api/check"

local KICK_MESSAGE = [[
CLAIM LISENSI DI 
TIKTOK : mellsroblox.id
WA :082174905591
KRACKED?HAMA 
]]

local function checkLicense()
	local placeId = game.PlaceId
	local requestData = { placeId = placeId }

	local success, result = pcall(function()
		return HttpService:RequestAsync({
			Url = API_URL,
			Method = "POST",
			Headers = { ["Content-Type"] = "application/json" },
			Body = HttpService:JSONEncode(requestData)
		})
	end)

	-- Kalau HTTP gagal (Studio Lite / HttpService dimatiin / internet mati) = kick
	if not success then return false end
	if not result.Success then return false end

	local ok, decoded = pcall(function()
		return HttpService:JSONDecode(result.Body)
	end)

	if ok and decoded and decoded.isLicensed then
		return true
	end

	return false
end

-- Eksekusi diam-diam tanpa log apapun
if not checkLicense() then
	Players.PlayerAdded:Connect(function(player)
		task.defer(function()
			player:Kick(KICK_MESSAGE)
		end)
	end)

	for _, player in ipairs(Players:GetPlayers()) do
		task.defer(function()
			player:Kick(KICK_MESSAGE)
		end)
	end

	task.defer(function()
		script.Parent:Destroy()
	end)
end
