local L = LibStub("AceLocale-3.0"):NewLocale("AutoRoll", "enUS", true)

--@localization(locale="enUS", format="lua_additive_table")@

--@do-not-package@
L["Pass"] = "Pass"
L["Need"] = "Need"
L["Greed"] = "Greed"

L["uncommon"] = "Uncommon"
L["rare"] = "Rare"
L["epic"] = "Epic"
L["legendary"] = "Legendary"
L["artifact"] = "Artifact"



L["equal"] = "equal"
L["minimum"] = "at least"
L["maximum"] = "at most"
L["bigger then"] = "is greater than"
L["lower then"] = "is smaller than"

L["Zul'Gurub"] = "Zul'Gurub"
L["Ony"] = "Ony"
L["MC"] = "MC"
L["BWL"] = "BWL"

L["Quality"] = "Quality"
L["Dungeon"] = "Dungeon"
L["in group with"] = "Grouped with"
L["disabled"] = "Disabled"
L["deleted"] = "Delete"
L["item"] = "Item"


L["ZG coin desc"] = "ZG Coins"
L["ZG bijous desc"] = "ZG Bijous"
L["all green items"] = "All green items"
L["all items disenchanter"] = "All items (only disenchanters)"


L["roll"] = "Roll"
L["for"] = "for"

L["has one"] = "has one" -- 14/20 has one (this round)

L["All player has a"] = "All players have a"
L["Start a new round"] = "Start a new round" -- 15/05 ist das ein Befehl, oder eine Beschreibung?


L["overview"] = "Overview"
L["advanced options"] = "Advanced Options"


L["accept share config"] = "Automatically accept rules from raid management"
L["accept share config desc"] = "Raid leadership can override my conditions during a raid"

L["use local config"] = "Enable rolling conditions"
L["use local config desc"] = "Disables the local AutoRoll conditions"

L["headerDescription"] = "Multiple groups can be defined here. \rIf all conditions in the first group are fulfilled, the action is executed. \rIf not, the next group of conditions is evaluated."

L["itemGroup activ"] = "Active"
L["itemGroup activ desc"] = "Condition group is active" -- 15/05 ist es normal dass hier die Beschreibung keine Aktion beschreibt, sondern ein Zustand?

L["share active"] = "Round-robin"
L["share active desc"] = "Everyone in the group receives the same number of items"

L["itemGroup name"] = "Group name"

L["conditions"] = "Conditions"
L["conditions desc"] = "Required to enable group"


L["auto roll"] = "Automatic rolling"
L["auto roll desc"] = "Displays what should happen to an item when all conditions are fulfilled."

L["add group"] = "Add group"
L["add group desc"] = "Add a new empty group"
L["new group name"] = "New group"

L["remove group"] = "Delete group"
L["remove group desc"] = "Delete this group (cannot be undone)"

L["share hint"] = "Sharing is enabled. You only participate in rolls for items until you get one. \rAfterwards, you pass until everyone got one."

L["add condition"] = "Add condition"
L["add condition desc"] = "Add a new condition to the group"


L["item condition desc"] = "Comma-separated list with item IDs. Eg. 19698,19699,19700"

L["partyMember conditon oneOf"] = "One of"
L["partyMember conditon allOf"] = "All of"
L["partyMember conditon desc"] = "Comma-sparated list of player names"

L["coming soon"] = "Not implemented yet, coming soon :D"


L["have all items this round"] = "Have already received my item, pass on the next."
L["entitlement to x"] = "Am entitled to" 
L["entitlement to x, will roll next time"] = "item/s. Rolling on the next."

L["round"] = "Round"
L["total won"] = "Total won"

L["switch to default rules"] = "Raid has broken up, switch to your own rules"



L["send rules to raid"] = "Raid start"
L["send rules to raid desc"] = "Send your own rules to all in raid that have this addon"

L["send raid end"] = "Raid end"
L["send raid end desc"] = "Turns off the raid rules for everyone."

L["disenchanter toogle"] = "Disenchanters"
L["disenchanter toogle desc"] = "I am responsible for disenchanting the unnecessary items in raids"

L["is disenchanter"] = "Disenchanter"

L["send you a AutoRoll3000 config for this raid. install it?"] = "sends you AutoRoll3000 rules for this raid, install?"
L["will remove your AutoRoll3000 Raid config. Remove it?"] = "wants to delete the AutoRoll3000 raid rules. Clear?"
L["Yes"] = "Yes"
L["No"] = "No"

L["Raid Rules are now active"] = "Raid rules are now active"
L["Raid Rules are now not active"] = "Raid rules turned off"

L["Raid rules"] = "Reaid rules"
L["Easy Rules"] = "Easy rules"

L["Raid Tools"] = "Raid Tools"
L["raid tools desc"] = "Here you can send your AutoRoll3000 rules for everyone in the group for this raid. \rAs long as the raid is running, the rules can no longer be changed!"

--@end-do-not-package@
