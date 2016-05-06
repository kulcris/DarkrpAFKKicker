AFKKickintab = {}
AFKKickinMinOpenSlots = 2		--Number of Slots to attempt to leave open
AFKKickinGracePeriod = 300 -- Grace period you can be afk before there is a chance you get kicked
AFKKickinKickMessage = "You have been kicked for being afk the longest in order to make room for other players. Feel free to rejoin" --Kick Message

function AFKKickinAFK(ply, afkbool)
	if afkbool then
		AFKKickintab[ply] = CurTime()
	else
		if !ply:getDarkRPVar("AFK") then
			AFKKickintab[ply] = nil
		end
	end
end

hook.Add("playerSetAFK", "AFKKickinAFK", AFKKickinAFK)



function AFKConnecting()
	local playertokick = nil
	if (#player.GetAll()) + AFKKickinMinOpenSlots >= game.MaxPlayers() then
		
		for v,k in pairs(AFKKickintab) do
			
			if ( not v:IsValid() ) then
				AFKKickintab[v] = nil 
				continue
			end
			
			if AFKKickintab[v] + AFKKickinGracePeriod <= CurTime()  then
				if !playertokick then
					playertokick = v
				else
					if AFKKickintab[playertokick] <= AFKKickintab[v] then
						playertokick = v
					end
				end
			end
		end
		
		if ( playertokick ) then
			playertokick:Kick(AFKKickinKickMessage)
		end
	end
end
hook.Add("PlayerConnect", "AFKConnect", AFKConnecting)
