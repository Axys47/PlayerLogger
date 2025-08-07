local HttpService = game:GetService("HttpService")
if HttpService.HttpEnabled == true then
	local Players = game:GetService("Players")
	local playerJoinTimes = {}

	local function getFormattedTime()
		return os.date("%m/%d/%Y %I:%M%p")
	end

	local function rounddown(inputnumber: number)
		-- Find the position of the decimal point
		local dotPosition = string.find(tostring(inputnumber), "%.")
		-- If there's a dot, cut the string up to the character before it
		if dotPosition then
			inputnumber = string.sub(inputnumber, 1, dotPosition - 1)
		end
		return tonumber(inputnumber)
	end

	local webhookUrl =
		"https://discord.com/api/webhooks/1394585265015754783/rWENsMMS1na5oJHH5gUYvoWLQk4U-LjzQlB7FJZ7aNNH8-YF2pcjU3-G8lzTEtbCsI-F"

	Players.PlayerAdded:Connect(function(player)
		playerJoinTimes[player] = tick()
		table.insert(playerJoinTimes, player.UserId .. os.time())
		playerJoinTimes[player.UserId] = os.time()
		local img = HttpService:JSONDecode(
			HttpService:GetAsync(
				"http://thumbnails.roproxy.com/v1/users/avatar-headshot?userIds="
					.. player.UserId
					.. "&size=100x100&format=Png&isCircular=true"
			)
		)["data"][1]["imageUrl"]

		local _embed = {
			title = getFormattedTime(),
			description = string.format(
				"OwO~ %s has **JOINED THE GAME!**\n~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=\nUsername: ------------- @%s\nDisplay Name: --------- %s\nUser ID: ---------------- %d\nLocale ID: ------------ %s\nAccount Days: -------- %d\nAuto Jump Enabled: -- %s\nVerified: --------------- %s\nPing: ----- %s\nMembershipType: ------------- %s\n(*≧ω≦*) \nLinks: -------------------------\n %s %s",
				player.Name,
				player.Name,
				player.DisplayName,
				player.UserId,
				player.LocaleId,
				player.AccountAge,
				tostring(player.AutoJumpEnabled),
				tostring(player.HasVerifiedBadge),
				tostring(player.GetNetworkPing(player) * 1000),
				tostring(player.MembershipType),
				tostring("http://roblox.com/User.aspx?ID=" .. player.UserId),
				tostring("http://www.roblox.com/games/" .. game.GameId)
			),
			color = 2096896,
			author = { name = "Player Joined! uwu~" },
			thumbnail = {
				url = tostring(img),
			},
		}

		HttpService:PostAsync(
			webhookUrl,
			HttpService:JSONEncode({
				username = "edp detectorer",
				-- content = tostring(player.Name .. "/" .. player.UserId .. " HAS JOINED THE TRAP"),
				content = "<@&1394584142330597487>",
				tts = false,
				embeds = { _embed },
			}),
			Enum.HttpContentType.ApplicationJson,
			false
		)
	end)

	Players.PlayerRemoving:Connect(function(player)
		local seconds = math.round(tick() - playerJoinTimes[player])
		local minutes = rounddown(seconds * 0.0166)
		local _embed = {
			title = getFormattedTime(),
			description = string.format(
				"Aww, %s left the game after being here for %sM and %sS at %s! UwU",
				tostring(player.Name .. "/" .. player.UserId),
				tostring(minutes),
				tostring(seconds - minutes * 60),
				getFormattedTime()
			),
			color = 16711680,
			author = { name = "Player Left... bye bye~" },
			thumbnail = {
				url = "https://cdn.discordapp.com/attachments/1271326657529118811/1394930261715714058/Screenshot_2025-06-23_174441.png?ex=6878998a&is=6877480a&hm=b273d8c3e8a1b881b4938325583cc40f0c215e116488fe937001a843d6b94389&",
			},
		}

		HttpService:PostAsync(
			webhookUrl,
			HttpService:JSONEncode({
				username = "edp detectorer",
				content = "<@&1394584142330597487>",
				tts = false,
				embeds = { _embed },
			})
		)
	end)
else
	script:Destroy()
	return
end
