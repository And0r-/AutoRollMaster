AutoRoll = LibStub("AceAddon-3.0"):GetAddon("FdHrT_AutoRoll")
local L = LibStub("AceLocale-3.0"):GetLocale("AutoRoll")

-- 48	Blackfathom Deeps
-- 230	Blackrock Depths
-- 229	Blackrock Spire
-- 429	Dire Maul
-- 90	Gnomeregan
-- 349	Maraudon
-- 389	Ragefire Chasm
-- 129	Razorfen Downs
-- 47	Razorfen Kraul
-- 1001	Scarlet Halls
-- 1004	Scarlet Monastery
-- 1007	Scholomance
-- 33	Shadowfang Keep
-- 329	Stratholme
-- 36	The Deadmines
-- 34	The Stockade
-- 109	The Temple of Atal'Hakkar
-- 70	Uldaman
-- 43	Wailing Caverns
-- 209	Zul'Farrak
-- 309	Zul'Gurub

-- 469	Blackwing Lair
-- 409	Molten Core
-- 509	Ruins of Ahn'Qiraj
-- 531	Temple of Ahn'Qira


function AutoRoll:GetOptions()
	return { 
    	handler = AutoRoll,
  		name = "",
  		type = "group",
  		childGroups = "tab",
  		args = {
			settings = {
				name = L["overview"],
				type = "group",
				order = 1,
				args = self:GetOptionSettings(),
		    },
			itemGroups = {
				name = L["advanced options"],
				type = "group",
				order = 2,
				args = self:GetOptionItemGroups("itemGroups"),
		    },
			itemGroupsRaid = {
				name = "Raid rules",
				type = "group",
				order = 2,
				hidden = "isItemGropsRaidHidden",
				args = self:GetOptionItemGroups("itemGroupsRaid"),
		    },
			debug = {
				name = "Debug",
				type = "group",
				order = 3,
				args = self:GetOptionDebug(),
		    },
      	},
	}
end

function AutoRoll:isItemGropsRaidHidden(info)
	return self:getItemGroupPointer() ~= "itemGroupsRaid"
end

function AutoRoll:GetOptionSettings()
	return { --profileItemGroupsEnabled
		raidItemGroups = {
			name = L["accept share config"],
			desc = L["accept share config desc"],
			type = "toggle",
			order = 1,
			get = "IsGuildItemGroupsEnabled",
			set = "ToggleGuildItemGroupsEnabled",
			width = "full",
		},
		-- I do not see a solution to do this so it is working for everyone. xloot will overwrite to lot.
		-- saveRollOptionsEnabled = {
		-- 	name = "Beim würfeln kann man angeben das nächste mal wieder das selbe zu wählen",
		-- 	desc = "Past/würfelt das nächste mal beim selben item automatisch, wenn 'merken' im Würfelfenster aktiviert wird",
		-- 	type = "toggle",
		-- 	order = 2,
		-- 	get = "IssavedItemsEnabled",
		-- 	set = "TogglesavedItemsEnabled",
		-- 	width = "full",
		-- },
		profileItemGroups = {
			name = L["use local config"],
			desc = L["use local config desc"],
			type = "toggle",
			order = 3,
			get = "IsProfileItemGroupsEnabled",
			set = "ToggleProfileItemGroupsEnabled",
			width = "full",
		},
		-- show a short enable disable list for the itemGroups when enabled. disable advanced tab when not enabled.



		send2raid = {
			name = L["send rules to raid"],
			desc = L["send rules to raid desc"],
			type = "execute",
			order = -2,
			func = "SendRaidConfig",
		},

		sendRemove2raid = {
			name = "remove raid rules",
			desc = "raid rules will be deleted on all raid members!",
			type = "execute",
			order = -1,
			func = "SendRaidConfigRemove",
		},

		


	}
end

function AutoRoll:GetOptionDebug()
	return {
		status = {
			name = "Status",
			desc = "Zeige informationen über die share itemvergabe",
			type = "execute",
			order = 2,
			func = "PrintAllShareStatus",
		},
		reset = {
			name = "Reset",
			desc = "Setzt die gleichmässige itemvergabe zurück",
			type = "execute",
			order = 3,
			func = "ResetShare",
		},
		nl2 = {
			type = "header",
			name = "",
			order = 4,
		},
	}
end


function AutoRoll:GetOptionItemGroups(itemGroupName)

	local itemGroups = {
		headerDescription = {
			type = "description",
			name = L["headerDescription"],
			order = 0,
		},
	}

	for itemGroupId,dbItemGroup in ipairs(self:GetItemGroupDb(itemGroupName)) do

		itemGroups["itemGroup"..itemGroupId] = {
			name = dbItemGroup.description,
			type = "group",
			inline = true,
			disabled = "isItemGroupDisabled",
			width = "full",
			order  = itemGroupId,
			args = {
				description = {
					name = L["itemGroup name"],
					type = "input",
					order = 0,
					get = "getItemGroupDescription",
					set = "setItemGroupDescription",
					arg = itemGroupId,
					width = "full",
				},
				enabled = {
					name = L["itemGroup activ"],
					desc = L["itemGroup activ desc"],
					type = "toggle",
					order = 1,
					get = "IsItemGroupEnabled",
					set = "ToggleItemGroupEnabled",
					arg = itemGroupId,
				},
				share = {
					name = L["share active"],
					desc = L["share active desc"],
					type = "toggle",
					order = 2,
					get = "IsItemGroupShareEnabled",
					set = "ToggleItemGroupShareEnabled",
					arg = itemGroupId,
				},

				shareOptions = self:GetItemGroupShareOptions(itemGroupName, itemGroupId, 3), 

				newline1 = {
					name = "",
					type = "description",
					width = "full",
					order = 4,
				},
				rs = {
      				name = L["auto roll"]..":",
      				desc = L["auto roll desc"],
      				type = "select",
      				order = 6,
      				values = self.rollOptions,
      				get = "GetItemGroupRollOptionSuccsess",
      				set = "SetItemGroupRollOptionSuccsess",
      				style = "dropdown",
      				arg = itemGroupId,
    			},
    			conditions = {
					name = L["conditions"],
					desc = L["conditions desc"],
					type = "group",
					order = 7,
					inline = true,
					width = "full",
					args = self:GetOptionItemGroupConditions(itemGroupName, itemGroupId),
				},
			}
		};
	end

	itemGroups.addItemGroupButton = {
		name = L["add group"],
		desc = L["add group desc"],
		type = "execute",
		disabled = "isItemGroupDisabled",
		order = -1,
		func = "AddItemGroupOption",
		--arg = itemGroupId,
	}

	return itemGroups;
end

function AutoRoll:GetItemGroupShareOptions(itemGroupName, itemGroupId, order)
	return {
		name = "",
		type = "group",
		width = "full",
		order  = order,
		hidden = self:IsItemGroupShareEnabled({[1]=itemGroupName,["arg"]=itemGroupId}) == false,
		args = {
			description = {
				name = L["share hint"],
				type = "description",
				order = 1,
			},
		},
		arg = itemGroupId,
	}
end

function AutoRoll:GetOptionItemGroupConditions(itemGroupName, itemGroupId)
	local conditions = {}
	conditions.addConditionButton = {
		name = L["add condition"],
		desc = L["add condition desc"],
		type = "execute",
		order = -1,
		func = "AddConditionOption",
		arg = itemGroupId,
	}

	if self:GetItemGroupDb(itemGroupName)[itemGroupId].conditions == nil then return conditions end

	local order = 1;
	for conditionId,condition in ipairs(self:GetItemGroupDb(itemGroupName)[itemGroupId].conditions) do
		if condition.type ~= "deleted" then 

			conditions["condition"..conditionId] = {
	  				name = "",
	  				desc = "",
	  				type = "select",
	  				order = order,
	  				values = self.conditionList,
	  				get = "GetConditionType",
	  				set = "SetConditionType",
	  				style = "dropdown",
	  				--width = "half",
	  				arg = {itemGroupId,conditionId},
			}
			order = order +1;

			if condition.type == "item" then conditions, order =self:AddItemConditonOptions(conditions,order,itemGroupId,conditionId) end
			if condition.type == "quality" then conditions, order =self:AddQualityConditonOptions(conditions,order,itemGroupId,conditionId) end
			if condition.type == "dungeon" then conditions, order =self:AddDungeonConditonOptions(conditions,order,itemGroupId,conditionId) end
			if condition.type == "party_member" then conditions, order =self:AddPartyMemberConditonOptions(conditions,order,itemGroupId,conditionId) end
			if condition.type == "lua" then conditions, order =self:AddLuaConditonOptions(conditions,order,itemGroupId,conditionId) end


			conditions["condition"..conditionId.."nl"] = {
				type = "header",
				name = "",
				order = order,
			}
			order = order +1;
		end
	end

	return conditions
end


function AutoRoll:AddItemConditonOptions(conditions,order,itemGroupId,conditionId)
--		arg = {itemGroupId,conditionId},

	conditions["condition"..conditionId.."Items"] = {
		name = "",
		desc = L["item condition desc"],
		type = "input",
		order = order,
		get = "GetConditionArg",
		set = "SetConditionArg",
		arg = {itemGroupId,conditionId,1},
		width = 1.9,
	}
	order = order +1

	return conditions, order;
end

function AutoRoll:AddQualityConditonOptions(conditions,order,itemGroupId,conditionId)
--		arg = {itemGroupId,conditionId},

	conditions["condition"..conditionId.."QualityOperator"] = {
		name = "",
		desc = "",
		type = "select",
		order = order,
		get = "GetConditionArg",
		set = "SetConditionArg",
		style = "dropdown",
		values = self.conditionOperaters,
		arg = {itemGroupId,conditionId,1},
	}
	order = order +1

	conditions["condition"..conditionId.."Quality"] = {
		name = "",
		type = "select",
		order = order,
		get = "GetConditionArg",
		set = "SetConditionArg",
		style = "dropdown",
		values = self.itemQuality,
		arg = {itemGroupId,conditionId,2},
	}
	order = order +1

	return conditions, order;
end

function AutoRoll:AddDungeonConditonOptions(conditions,order,itemGroupId,conditionId)
--		arg = {itemGroupId,conditionId},

	conditions["condition"..conditionId.."Dungeon"] = {
		name = "",
		type = "select",
		order = order,
		get = "GetConditionArg",
		set = "SetConditionArg",
		style = "dropdown",
		values = self.dungeonList,
		arg = {itemGroupId,conditionId,1},
	}
	order = order +1

	return conditions, order;
end

function AutoRoll:AddPartyMemberConditonOptions(conditions,order,itemGroupId,conditionId)
--		arg = {itemGroupId,conditionId},
	conditions["condition"..conditionId.."PartyMemberOperator"] = {
		name = "",
		type = "select",
		order = order,
		get = "GetConditionArg",
		set = "SetConditionArg",
		style = "dropdown",
		values = {["oneOf"]=L["partyMember conditon oneOf"],["allOf"]=L["partyMember conditon allOf"]},
		arg = {itemGroupId,conditionId,1},
	}
	order = order +1

	conditions["condition"..conditionId.."PartyMember"] = {
		name = "",
		desc = L["partyMember conditon desc"],
		type = "input",
		order = order,
		get = "GetConditionArg",
		set = "SetConditionArg",
		arg = {itemGroupId,conditionId,2},
	}
	order = order +1

	return conditions, order;
end

function AutoRoll:AddLuaConditonOptions(conditions,order,itemGroupId,conditionId)
--		arg = {itemGroupId,conditionId},

	conditions["condition"..conditionId.."Lua"] = {
		name = L["coming soon"],
		desc = "",
		type = "description",
		order = order,
		--get = "GetConditionArg",
		--set = "SetConditionArg",
		--arg = {itemGroupId,conditionId,1},
		--width = 1.9,
	}
	order = order +1

	return conditions, order;
end

function AutoRoll:refreshOptions()
	local options = self:GetOptions();
	if options.args.itemGroupsRaid.hidden == false then self:Print("Raid is not hidden :)") end
	options.args.profiles = self.profilOptions
	LibStub("AceConfigRegistry-3.0"):NotifyChange("AutoRoll3000")
    LibStub("AceConfig-3.0"):RegisterOptionsTable("AutoRoll3000", options)
end

function AutoRoll:GetConditionArg(info)
	return self:GetItemGroupDb(info[1])[info.arg[1]].conditions[info.arg[2]].args[info.arg[3]]
end

function AutoRoll:SetConditionArg(info, value)
	self:GetItemGroupDb(info[1])[info.arg[1]].conditions[info.arg[2]].args[info.arg[3]] = value
end

function AutoRoll:AddConditionOption(info)
	if self:GetItemGroupDb(info[1])[info.arg].conditions == nil then self:GetItemGroupDb(info[1])[info.arg].conditions = {} end
	tinsert(self:GetItemGroupDb(info[1])[info.arg].conditions, {type = "disabled", args = {true}});

	self:refreshOptions();
end

function AutoRoll:AddItemGroupOption(info)
	tinsert(self:GetItemGroupDb(info[1]), {description = L["new group name"], conditions = {}, share = {}});
	self:refreshOptions();
end


function AutoRoll:GetConditionType(info)
	return self:GetItemGroupDb(info[1])[info.arg[1]].conditions[info.arg[2]].type
end

function AutoRoll:SetConditionType(info, value)
	self:GetItemGroupDb(info[1])[info.arg[1]].conditions[info.arg[2]].type = value
	self:refreshOptions();
end

function AutoRoll:GetItemGroupRollOptionSuccsess(info)
	return self:GetItemGroupDb(info[1])[info.arg].rollOptionSuccsess
end

function AutoRoll:SetItemGroupRollOptionSuccsess(info, value)
	self:GetItemGroupDb(info[1])[info.arg].rollOptionSuccsess = value
end

function AutoRoll:getItemGroupDescription(info)
	return self:GetItemGroupDb(info[1])[info.arg].description
end

function AutoRoll:setItemGroupDescription(info, value)
	self:GetItemGroupDb(info[1])[info.arg].description = value
	self:refreshOptions();
end

function AutoRoll:IsItemGroupEnabled(info)
	return self:GetItemGroupDb(info[1])[info.arg].enabled
end

function AutoRoll:ToggleItemGroupEnabled(info, value)
	self:GetItemGroupDb(info[1])[info.arg].enabled = value
end

function AutoRoll:IsProfileItemGroupsEnabled(info)
	return self.db.profile.profileItemGroupsEnabled
end

function AutoRoll:ToggleProfileItemGroupsEnabled(info, value)
	self.db.profile.profileItemGroupsEnabled = value
end

function AutoRoll:IsGuildItemGroupsEnabled(info)
	return self.db.profile.guildItemGroupsEnabled
end

function AutoRoll:ToggleGuildItemGroupsEnabled(info, value)
	self.db.profile.guildItemGroupsEnabled = value
end

-- function AutoRoll:IssavedItemsEnabled(info)
-- 	return self.db.profile.savedItemsEnabled
-- end

-- function AutoRoll:TogglesavedItemsEnabled(info, value)
-- 	self.db.profile.savedItemsEnabled = value
-- end



function AutoRoll:IsItemGroupShareEnabled(info)
	if self:GetItemGroupDb(info[1])[info.arg].share == nil then
		return false
	else
		return self:GetItemGroupDb(info[1])[info.arg].share.enabled
	end
end

function AutoRoll:ToggleItemGroupShareEnabled(info, value)
	self:GetItemGroupDb(info[1])[info.arg].share.enabled = value
	self:refreshOptions();
end

 
 function AutoRoll:ResetShare(info)
	if info.arg then
		-- reset share loot from this itemGroupId
		self:Print("Resette share von itemGroup: ".. info.arg)
		self.db.profile[self:getItemGroupPointer()].share[info.arg] = {}
	else
		-- reset all share loots!
		self:Print("Resette alle share daten")
		self.db.profile[self:getItemGroupPointer()].share = {}
	end
end

function AutoRoll:PrintShareStatus(info)
	local sharedata = self.db.profile[self:getItemGroupPointer()].share[info.arg]

	self:Print(self:GetItemGroupDb(info[1])[info.arg].description)
	self:Print(sharedata.loot_counter.."/"..sharedata.party_member.." "..L["has one"]);

	if sharedata.has_loot == 1 then
		self:Print(L["have all items this round"])
	else
		self:Print(L["entitlement to x"].." "..((sharedata.has_loot*-1)+1) .." "..L["entitlement to x, will roll next time"])
	end
	self:Print(L["round"]..": "..sharedata.loot_round);
	self:Print(L["total won"]..": "..sharedata.has_won_total);
end

function AutoRoll:PrintAllShareStatus(info)
	for i in pairs(self.db.profile[self:getItemGroupPointer()].share) do
		self:PrintShareStatus({[1]=self:getItemGroupPointer(), ["arg"]=i})
	end
end

function AutoRoll:GetItemGroupDb(itemGroupName)
	return self.db.profile[itemGroupName]
end


function AutoRoll:isItemGroupDisabled(info)
	if info[1] == "itemGroupsRaid" then return true end
	return false
end