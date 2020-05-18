local L = LibStub("AceLocale-3.0"):NewLocale("AutoRoll", "enUS")


--@localization(locale="enUS", format="lua_additive_table")@

--@do-not-package@
-- @todo: ugly hack, i get a error L do not exist on a german client. so it is working for me at the moment, when aceLocale do not return the not needed langues i have to check this.
if L == nul then return end


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


L["ZG coin desc"] = "ZG coins"
L["ZG bijous desc"] = "ZG bijoux"
L["all green items"] = "all green items"


L["roll"] = "Roll"
L["for"] = "for"

L["has one"] = "has one" -- 14/20 has one (this round)

L["All player has a"] = "All players have a"
L["Start a new round"] = "Start a new round" -- 15/05 ist das ein Befehl, oder eine Beschreibung?


L["overview"] = "Overview"
L["advanced options"] = "Advanced Options"


L["accept share config"] = "Guild leadership decides what I roll on (coming in second beta)"
L["accept share config desc"] = "Guild leadership can override my conditions during a raid"

L["use local config"] = "Enable rolling conditions"
L["use local config desc"] = "Disables the local AutoRoll conditions"

L["headerDescription"] = "Multiple groups can be defined here. \rIf all conditions in the first group are fulfilled, the action is executed. \rIf not, the next group of conditions is evaluated."

L["itemGroup activ"] = "Active"
L["itemGroup activ desc"] = "Condition group is active" -- 15/05 ist es normal dass hier die Beschreibung keine Aktion beschreibt, sondern ein Zustand?

L["share active"] = "Share" -- 15/05 Split = in mehrere Teile teilen, Share = aushändigen/teilen im sozialen Sinne. kA was besser stimmt.
L["share active desc"] = "Share among group"

L["itemGroup name"] = "Group name"

L["conditions"] = "Conditions"
L["conditions desc"] = "Required to enable group"


L["auto roll"] = "Automatic rolling"
L["auto roll desc"] = "Displays what should happen to an item when all conditions are fulfilled."

L["add group"] = "Add group"
L["add group desc"] = "Add a new empty group"
L["new group name"] = "New group"

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

L["send rules to raid"] = "send rules to raid"
L["send rules to raid desc"] = "Send your own rules to all in raid that have this addon"


--@end-do-not-package@
