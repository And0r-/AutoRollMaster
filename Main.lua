local AutoRoll = LibStub("AceAddon-3.0"):NewAddon("FdHrT_AutoRoll", "AceConsole-3.0", "AceEvent-3.0", "AceComm-3.0", "AceSerializer-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("AutoRoll")

-- @todo:  save this in AutoRoll, to not have dublications...
AutoRoll.rollOptions = {[0]=L["Pass"], [1]=L["Need"], [2]=L["Greed"]}
AutoRoll.itemQuality = {[2]="|cFF1eff00"..L["uncommon"].."|r", [3]="|cff0070dd"..L["rare"].."|r", [4]="|cffa335ee"..L["epic"].."|r", [5]="|cffff8000"..L["legendary"].."|r", [6]="|cffe6cc80"..L["artifact"].."|r"}
AutoRoll.conditionOperaters = {["=="]=L["equal"],[">="]=L["minimum"],["<="]=L["maximum"],[">"]=L["bigger then"],["<"]=L["lower then"]}
AutoRoll.dungeonList = {[309]=L["Zul'Gurub"],[249]=L["Ony"], [409]=L["MC"], [469]=L["BWL"], [389]="test instance"}
AutoRoll.conditionList = {["disenchanter"]=L["is disenchanter"], ["quality"]=L["Quality"], ["dungeon"]=L["Dungeon"], ["party_member"]=L["in group with"], ["lua"]="Lua",["disabled"]=L["disabled"],["deleted"]=L["deleted"],["item"]=L["item"]}





--wow api, tis will do a lot other addons, i'm not sure is it local a lot faster?
local GetLootRollItemInfo = GetLootRollItemInfo
local GetLootRollItemLink = GetLootRollItemLink
local GetItemInfoInstant = GetItemInfoInstant
local GetNumGroupMembers = GetNumGroupMembers
local GetPlayerInfo = C_LootHistory.GetPlayerInfo


local dbDefaults = {
	profile = {
		enabled = true, -- the addon self is enabled per default
		guildItemGroupsEnabled = true, -- use a group config to auto roll in a raid from a guild leader
		--savedItemsEnabled = true, -- add the options to store 
		profileItemGroupsEnabled = false, -- on default it should not use any ItemGroups to auto roll.

		disenchanter = false,
		itemGroupsPointer = "itemGroups",

		-- savedItems = { -- it will be possible to remember the decision on the roll frame. this is stored here
		-- 	--[19698] = 0,
		-- },

		itemGroupsRaid = {
			raidSize = nil, -- When i get a itemGroupsRaid ruleset for a raid store here the group size. when the group size will be smaler then 40% or less then 2 i know the raid is finish and the itemGroupsRaid will be deleted. 
		}, -- here are the groups stored you recive from raid lead
		itemGroups = { -- When not stored in the savedItems it will check the items groups
			--thank you lua for your ugly mixed aray hash disaster...
			rolls = {}, -- data about current rolls with share function, when this rollId is finished we have to check do we have won the item. and update the itemgroup share data. rolls[rollId] = itemGroupId
			share = {}, -- round robin data of all groups. e.g: share[itemGroupId].loot_counter 
			{
				description = L["ZG coin desc"],
				enabled = true,
				share = {
					enabled = true,
					size = "raid"
				},
				rollOptionSuccsess = 2,
				conditions = {
					[1] = {
						type = "item",
						args = {"19698,19699,19700,19701,19702,19703,19704,19705,19706"},
					}
				},
			},
			{
				description = L["ZG bijous desc"],
				enabled = true,
				share = {
					enabled = true,
				},
				rollOptionSuccsess = 2,
				conditions = {
					[1] = {
						type = "item",
						args = {"19707,19708,19709,19710,19711,19712,19713,19714,19715"},
					}
				},
			},
			{ -- 
				description = L["all items disenchanter"],
				enabled = true, 
				share = {
					enabled = false,
				},
				rollOptionSuccsess = 2,
				conditions = {
					[1] = {
						type = "disenchanter",
						args = {true},
					}
				},
			},
			{ -- 
				description = L["all green items"],
				enabled = false, 
				share = {
					enabled = false,
				},
				rollOptionSuccsess = 0,
				conditions = {
					[1] = {
						type = "quality",
						args = {
							"==", 
							2, --0 - Poor, 1 - Common, 2 - Uncommon, 3 - Rare, 4 - Epic, 5 - Legendary, 6 - Artifact, 7 - Heirloom, 8 - WoW Token
						}, 
					}
					-- the following conditions are not implemented yet, and only a hint for me
					-- dungeon = 309, -- condition work only in ZG
					-- inGroupWith = {
					--		"oneOf", "Player1,Player2,Player3",
					--		"allOf", "Player1,Player2,Player3",
					-- }, 
					-- perhaps i add a lua solution to, we will see
				},
			},
		},
	},
}

function Copy_Table(src, dest)
	for index, value in pairs(src) do
		if type(value) == "table" then
			dest[index] = {}
			Copy_Table(value, dest[index])
		else
			dest[index] = value
		end
	end
end

function AutoRoll:OnInitialize()
    -- Called when the addon is loaded
    self:RegisterChatCommand("rl", function() ReloadUI() end)
    self:loadDb()

    self:refreshOptions()
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("AutoRoll3000", "AutoRoll3000")
    self:RegisterChatCommand("ar3", "ChatCommand")
end

function AutoRoll:OnEnable()
    -- Called when the addon is enabled
    self:RegisterEvent("START_LOOT_ROLL")
    self:RegisterEvent("LOOT_HISTORY_ROLL_COMPLETE")

    -- @Todo: only use the comm "ar3" and "ar3_data" so it is possible to send on ar3 hei ther is a raid config with id xyz or delete raid config xyz and then send it on the data channel. 
   	-- maybe after a client recive ther is a raid config xyz he has to send back i need the data and then wisper it back. and use the compression only on data
    self:RegisterComm("ar3_rc") -- recive a confi
    self:RegisterComm("ar3_rmc") -- remove the raid config


    self:checkItemGroupPointer()

    StaticPopupDialogs["CONFIRM_RECIVE_CONFIG_AR3"] = {
		text = "%s send you a AutoRoll3000 config for this raid. install it?",
		button1 = "Yes",
		button2 = "No",
		OnAccept = function(self, config)
		  AutoRoll:ReciveItemGroupRaid(config)
		end,
		timeout = 20,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
	};

    StaticPopupDialogs["CONFIRM_REMOVE_CONFIG_AR3"] = {
		text = "%s will remove your AutoRoll3000 Raid config. Remove it?",
		button1 = "Yes",
		button2 = "No",
		OnAccept = function(self)
		  AutoRoll:setItemGroupPointer("itemGroups")
		end,
		timeout = 20,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
	};
    -- Register AutoRoll db on Core addon, and set only the scope to this addon db. So profile reset works fine for all the addons.
    --self.db = FdHrT:AddAddonDBDefaults(dbDefaults).profile.AutoRoll;

    
    --LibStub("AceConfig-3.0"):RegisterOptionsTable("AutoRoll", options.args.ar, {"ar"})
end

function AutoRoll:loadDb()
	self.db = LibStub("AceDB-3.0"):New("AutoRollDB", dbDefaults, true)
	self.profilOptions = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)

	self.db.RegisterCallback(self, "OnProfileChanged", "refreshOptions")
	self.db.RegisterCallback(self, "OnProfileCopied", "refreshOptions")
	self.db.RegisterCallback(self, "OnProfileReset", "refreshOptions")
end

function AutoRoll:ChatCommand(input)
    if not input or input:trim() == "" then
        InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
        InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
    else
        LibStub("AceConfigCmd-3.0"):HandleCommand("ar3", "AutoRoll3000", input)
    end
end

function AutoRoll:GetRollIdData(rollId)
	local itemInfo = {["rollId"] = rollId}
	itemInfo.texture, itemInfo.name, itemInfo.count, itemInfo.quality, itemInfo.bindOnPickUp, itemInfo.canNeed, itemInfo.canGreed, itemInfo.canDisenchant, itemInfo.reasonNeed, itemInfo.reasonGreed, itemInfo.reasonDisenchant, itemInfo.deSkillRequired = GetLootRollItemInfo(rollId);
	itemInfo.itemId, itemInfo.itemType, itemInfo.itemSubType, itemInfo.itemEquipLoc, itemInfo.icon, itemInfo.itemClassID, itemInfo.itemSubClassID = GetItemInfoInstant(GetLootRollItemLink(itemInfo.rollId));

	itemInfo.itemLink = GetLootRollItemLink(itemInfo.rollId)

	return itemInfo
end

-- Fake roll data used when you use the AutoRoll:troll function for a test roll
function AutoRoll:GetRollIdDataDebug(rollId, itemId)
	local itemInfo = {
		rollId = rollId,
		count = 1,
		itemId = itemId or 19698,
	}

	itemInfo.name, itemInfo.itemLink, itemInfo.quality, _, _, itemInfo.itemType, itemInfo.itemSubType, _, itemInfo.itemEquipLoc, itemInfo.texture, _ = GetItemInfo(itemInfo.itemId)
	return itemInfo
end

-- Only for addon develop:

-- start a new roll for a ZG coin and rollId 1
-- /run AutoRoll:troll(1)

-- fake a win of the item from rollId 1
-- /run AutoRoll:rollItemWon(1)

-- start a new roll for item id 1234
-- /run AutoRoll:troll(1,1234)

-- Debug function to emulate a roll windows event
function AutoRoll:troll(rollId, itemId)
	local itemInfo = self:GetRollIdDataDebug(rollId, itemId);
	self:CheckRoll(itemInfo)
end

function AutoRoll:START_LOOT_ROLL(event, rollId)
	local itemInfo = self:GetRollIdData(rollId);
	self:CheckRoll(itemInfo)
end

function AutoRoll:CheckRoll(itemInfo)
	if self.db.profile.enabled == false then return false end
	local currentItemGroupId

		if 
			(self:getItemGroupPointer() == "itemGroupsRaid" and self.db.profile.guildItemGroupsEnabled) or 
			(self:getItemGroupPointer() == "itemGroups" and self.db.profile.profileItemGroupsEnabled) then
			currentItemGroupId = self:findGroup(itemInfo,self.db.profile[self:getItemGroupPointer()]);
		end

	-- no active itemGroup found for this roll window, abort
	if currentItemGroupId == nil then return false end

	local currentItemGroup = self.db.profile[self:getItemGroupPointer()][currentItemGroupId]

	if currentItemGroup.share.enabled then
		-- round robin mode. only roll when player not have more then the other from currentItemGroupId.
		self:CheckShare(itemInfo, currentItemGroupId, currentItemGroup)
	else
		-- auto roll
		self:Print(L["roll"].." "..self.rollOptions[currentItemGroup.rollOptionSuccsess].." "..L["for"].." "..itemInfo.itemLink);
		RollOnLoot(itemInfo.rollId, currentItemGroup.rollOptionSuccsess);
	end
end

-- /ar3
-- /run AutoRoll:SendRaidConfig()
-- /run AutoRoll:installItemGroupRaidFromItemGroups()
-- /run AutoRoll:checkItemGroupPointer()

function AutoRoll:installItemGroupRaidFromItemGroups()
	local itemGroupsRaid = {}
	Copy_Table(self.db.profile.itemGroups, itemGroupsRaid)
	itemGroupsRaid.raidSize = GetNumGroupMembers()

	self:installItemGroupRaid(itemGroupsRaid)
end

function AutoRoll:ReciveItemGroupRaid(itemGroupsRaidMessage)
	local LibDeflate = LibStub:GetLibrary("LibDeflate")
	local ctext = LibDeflate:DecodeForWoWAddonChannel(itemGroupsRaidMessage)
	local text = LibDeflate:DecompressDeflate(ctext)

	local _,itemGroupsRaid = self:Deserialize(text)

	self:installItemGroupRaid(itemGroupsRaid)
end

function AutoRoll:installItemGroupRaid(itemGroupsRaid)
    -- simulate a recive from a raid itemGroup
    self.db.profile.itemGroupsRaid = itemGroupsRaid

    -- share reset
    self.db.profile.itemGroupsRaid.share = {}

    -- switch to Raid config
    self:setItemGroupPointer("itemGroupsRaid")

    self:Print("Raid Rules are now active")

    -- recive raid config when you are not in a group make no sence but better check it here
    self:checkItemGroupPointer()
end

function AutoRoll:OnCommReceived(prefix, message, distribution, sender)
	if sender == UnitName("player") then return end -- ignore mesage from my self
	if self:getItemGroupPointer() == "itemGroupsRaid" and prefix == "ar3_rc" then return end -- when you allready has a raid config do not recive. 

	-- check should we do the command or is a user confirm required
	-- @Todo: user GetGuildInfo to check is the sender in my guild
	-- @Todo: check is it possible to fake the sender
	if self.db.profile.guildItemGroupsEnabled and (UnitIsGroupAssistant(sender) or UnitIsGroupLeader(sender)) then
		-- install/remove Raid Rules
		if prefix == "ar3_rc" then
			self:ReciveItemGroupRaid(message)
		elseif prefix == "ar3_rmc" then
			self:setItemGroupPointer("itemGroups")
		end
	else
		-- user has to confirm before the Raid Rules will be installed/removed
		if prefix == "ar3_rc" then
			self:confirmRaidConfigRecive(message, sender)
		elseif prefix == "ar3_rmc" then
			self:confirmRemoveRaidConfig(sender)
		end
	end
end

function AutoRoll:confirmRemoveRaidConfig(playerName)
	StaticPopup_Show("CONFIRM_REMOVE_CONFIG_AR3", playerName)
end

function AutoRoll:confirmRaidConfigRecive(itemGroups, playerName)
	local dialog = StaticPopup_Show("CONFIRM_RECIVE_CONFIG_AR3", playerName)
	dialog.data = itemGroups
end

function AutoRoll:SendRaidConfig()
	if self:getItemGroupPointer() == "itemGroups" then
		self:installItemGroupRaidFromItemGroups()
	end
	local LibDeflate = LibStub:GetLibrary("LibDeflate")
	local s = self:Serialize(self.db.profile.itemGroupsRaid)
	local cs = LibDeflate:CompressDeflate(s)
	cs = LibDeflate:EncodeForWoWAddonChannel(cs)
	self:SendCommMessage("ar3_rc", cs, "RAID", "", "BULK")
end

function AutoRoll:SendRaidConfigRemove()
	self:setItemGroupPointer("itemGroups")
	self:SendCommMessage("ar3_rmc", "remove raid config", "RAID", "", "BULK")
end

function AutoRoll:setItemGroupPointer(value)
	if value == "itemGroupsRaid" then 
		self:RegisterEvent("GROUP_ROSTER_UPDATE") 
	else
		self:UnregisterEvent("GROUP_ROSTER_UPDATE") 
	end

	self.db.profile.itemGroupsPointer = value
	self:refreshOptions();
end

function AutoRoll:GROUP_ROSTER_UPDATE()
	self:checkItemGroupPointer();
end

function AutoRoll:getItemGroupPointer()
	return self.db.profile.itemGroupsPointer
end

function AutoRoll:checkItemGroupPointer()
	local itemGroups = self:getItemGroupPointer()
	if itemGroups == "itemGroups" then return end

	if itemGroups == "itemGroupsRaid" then
		-- Curent itemGroup is for a raid. check are we allready in this group
		if self.db.profile[itemGroups].raidSize ~= nill and (self.db.profile[itemGroups].raidSize / 2) < GetNumGroupMembers() then
			-- group looks ok for raid ruls
			return 
		end
	end
	-- no working itemGroups detected. set to default
	self:Print(L["switch to default rules"])
	self:setItemGroupPointer("itemGroups")
end



-- Raid lead can shere a itemGroup to all raid members with this addon. this temporary itemGroup should work until the end of the dungeon.
-- function AutoRoll:isRaidItemGroup()
-- 	-- There are no dungeon session id, so i have to track self is it the same group
-- end

function AutoRoll:CheckConditions(itemInfo, itemGroup)
	if itemGroup.conditions == nil then return false end

	-- Check all Conditions
	for ic, condition in pairs(itemGroup.conditions) do
		if AutoRoll:CheckCondition(itemInfo, condition) == false then
			-- Condition fails try next itemGroup
			return false
		end
	end
	-- All Conditions true, une this itemGroup
	return true
end

function AutoRoll:CheckCondition(itemInfo, condition)
	if condition.type == "item" then 
		return tContains({strsplit(",",condition.args[1])},tostring(itemInfo.itemId))
	elseif condition.type == "disabled" then 
		return true
	elseif condition.type == "disenchanter" then 
		return self.db.profile.disenchanter == condition.args[1]
	elseif condition.type == "lua" then 
		return true
	elseif condition.type == "party_member" then
		for i,playerName in ipairs({strsplit(",",condition.args[2])}) do
			if UnitInRaid(playerName) or UnitInParty(playerName) then
				if condition.args[1] == "oneOf" then
					return true
				end
			else
				if condition.args[1] == "allOf" then
					return false
				end
			end
		end
		if condition.args[1] == "oneOf" then
			return false
		else
			return true
		end
	elseif condition.type == "dungeon" then 
		local instanceId = select(8,GetInstanceInfo())
		return instanceId == condition.args[1]
	elseif condition.type == "quality" then 
		-- Validate bevore use the evel loadstring function...
		if self.conditionOperaters[condition.args[1]] == nil or self.itemQuality[condition.args[2]] == nil then return false end
		 
		local f = assert(loadstring("return "..itemInfo.quality.." "..condition.args[1].." "..condition.args[2]))
		return f()
	end

	return true -- Condition type not known, ignore it
end

function AutoRoll:findGroup(itemInfo, itemGroups)
	if itemGroups == nil then return nil end -- no itemGroups created

	for i, itemGroup in pairs(itemGroups) do
		if itemGroup.enabled == false then break end

		if self:CheckConditions(itemInfo, itemGroup) then 
			return i 
		end
	end
	return nil




end

-- a little bit messy at the moment, 
function AutoRoll:CheckShare(itemInfo, currentItemGroupId)
	self.db.profile[self:getItemGroupPointer()].rolls[itemInfo.rollId] = currentItemGroupId;
	if self.db.profile[self:getItemGroupPointer()].share[currentItemGroupId] == nil then self:initShare(currentItemGroupId) end
 	local sharedata = self.db.profile[self:getItemGroupPointer()].share[currentItemGroupId];

	sharedata.loot_counter = sharedata.loot_counter +1;
	sharedata.party_member = GetNumGroupMembers(); -- it is possible that one of the group do not want any zg coins. so we need a option later to change the party_member size by hand...
--		print("vor würfeln. has_loot: "..has_loot)
	if sharedata.has_loot < 1 then
		--würfeln
		self:Print(self.rollOptions[self.db.profile[self:getItemGroupPointer()][currentItemGroupId].rollOptionSuccsess].." "..L["for"].." "..itemInfo.itemLink.." "..sharedata.loot_counter.."/"..sharedata.party_member.." "..L["has one"]);
		RollOnLoot(itemInfo.rollId, self.db.profile[self:getItemGroupPointer()][currentItemGroupId].rollOptionSuccsess);
	else
		self:Print(self.rollOptions[0].." "..L["for"].." "..itemInfo.itemLink.." "..sharedata.loot_counter.."/"..sharedata.party_member.." "..L["has one"]);
		RollOnLoot(itemInfo.rollId, 0);
	end

	if sharedata.party_member <= sharedata.loot_counter then
		sharedata.loot_counter = 0;
		sharedata.has_loot = sharedata.has_loot -1;
		sharedata.loot_round = sharedata.loot_round +1;
		self:Print(L["All player has a"].." "..self.db.profile[self:getItemGroupPointer()][currentItemGroupId].description..". "..L["Start a new round"]);
	end
end

function AutoRoll:initShare(currentItemGroupId)
	self.db.profile[self:getItemGroupPointer()].share[currentItemGroupId] = {
		loot_counter = 0,
		has_loot = 0,
		loot_round = 1,
		has_won_total = 0,
	}
end

-- -- This stupid event do not return the rollId! 
-- -- so i will not store the item id to check it here... perhaps i will change my mind later
-- function AutoRoll:LOOT_ITEM_ROLL_WON(event, itemLink, rollQuntity, rollType, roll, upgraded)
-- 	self:Print("LOOT_ITEM_ROLL_WON entdeckt. item von rollid: "..rollId.." gewonnen")
-- 	self:rollItemWon(rollId)
-- end

-- /run AutoRoll:rollItemWon(1)
function AutoRoll:rollItemWon(rollId)
	if self.db.profile[self:getItemGroupPointer()].rolls[rollId] then
		local sharedata = self.db.profile[self:getItemGroupPointer()].share[self.db.profile[self:getItemGroupPointer()].rolls[rollId]]
		sharedata.has_loot = sharedata.has_loot +1;
		sharedata.has_won_total = sharedata.has_won_total +1;
	end
end

--	LOOT_HISTORY_ROLL_COMPLETE is very complex i have to work with the complete roll history from wow. 
--  At the moment i use only the info is the winner is me. This will be a lot easyser with LOOT_ITEM_ROLL_WON.
--  When I will track all winners this function should work:

function AutoRoll:LOOT_HISTORY_ROLL_COMPLETE()
	local hid, rollId, players, done, _ = 1;

	-- Any roll is done now. so loop over all the wow lootHistory data and check is ther a entry for a open rollid...
	while true do
		rollId, _, players, done = C_LootHistory.GetItem(hid);
		if not rollId then
			return
		elseif done and self.db.profile[self:getItemGroupPointer()].rolls[rollId] then
			-- found it...
			--print(rollId.." abgeschlossen ");
			break
		end
		hid = hid+1
	end

	-- There is no function to get the winner of the item. i have to loop over all players and get a lot of data about the history id of this player 
	for j=1, players do
		local name, class, rtype, roll, is_winner, is_me = GetPlayerInfo(hid, j)
		if is_winner then
			-- print("gewinner von ".._.." ist: "..name.." class: "..class);
			-- perhaps i will add here a loot history feature, but not at the moment.
			if is_me then
				self:rollItemWon(rollId)
			end
			break
		end
	end

	self.db.profile[self:getItemGroupPointer()].rolls[rollId] = nil -- ignore this rollId in the history data next time
end
