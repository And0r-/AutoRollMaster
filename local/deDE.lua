local L = LibStub("AceLocale-3.0"):NewLocale("AutoRoll", "deDE")

if not L then return end
--@localization(locale="deDE", format="lua_additive_table", handle-subnamespaces="concat")@

--@do-not-package@
L["Pass"] = "Passen"
L["Need"] = "Bedarf"
L["Greed"] = "Gier"

L["uncommon"] = "Außergewöhnlich"
L["rare"] = "Selten"
L["epic"] = "Episch"
L["legendary"] = "Legendär"
L["artifact"] = "Artefakt"



L["equal"] = "ist gleich"
L["minimum"] = "ist mindestens"
L["maximum"] = "ist höchstens"
L["bigger then"] = "ist höher als"
L["lower then"] = "ist kleiner als"

L["Zul'Gurub"] = "Zul'Gurub"
L["Ony"] = "Ony"
L["MC"] = "MC"
L["BWL"] = "BWL"

L["Quality"] = "Qualität"
L["Dungeon"] = "Dungeon"
L["in group with"] = "In der Gruppe mit"
L["disabled"] = "Deaktiviert"
L["deleted"] = "Löschen"
L["item"] = "Item"


L["ZG coin desc"] = "ZG Münzen"
L["ZG bijous desc"] = "ZG Schmuck"
L["all green items"] = "Alle grünen Items"
L["all items disenchanter"] = "Alle Items (nur Entzauberer)"


L["roll"] = "Würfle"
L["for"] = "für"

L["has one"] = "haben diese Runde eins" -- 14/20 has one (this round)

L["All player has a"] = "Alle Spieler haben ein/e"
L["Start a new round"] = "Starte eine neue Runde"


L["overview"] = "Übersicht"
L["advanced options"] = "Erweiterte Einstellungen"


L["accept share config"] = "Regeln von Raidleitung automatisch annehmen"
L["accept share config desc"] = "Während einem Raid kann die Leitung meine eigenen AutoRoll Regeln überschreiben."

L["use local config"] = "Würfelregeln einschalten"
L["use local config desc"] = "Schaltet die eigenen AutoRoll regeln ein"

L["headerDescription"] = "Hier können verschiedene Gruppen definiert werden. \rWenn alle Regeln der ersten gruppe erfüllt sind, wird die Aktion ausgeführt. \rWenn nicht, wird die nächste Gruppe überprüft."

L["itemGroup activ"] = "Aktiv"
L["itemGroup activ desc"] = "Regel Gruppe ist Aktiv"

L["share active"] = "Aufteilen"
L["share active desc"] = "Jeder in der Gruppe erhält möglichst gleich viel Items"

L["itemGroup name"] = "Gruppen Name"

L["conditions"] = "Regeln"
L["conditions desc"] = "Bedingungen damit die Gruppe zum Einsatz kommt"


L["auto roll"] = "Automatisch Würfeln"
L["auto roll desc"] = "Gibt an was mit den Items geschehen soll, welche alle Regeln erfüllen."

L["add group"] = "Gruppe hinzufügen"
L["add group desc"] = "Füge eine neue, leere Gruppe hinzu"
L["new group name"] = "Neue Gruppe"

L["remove group"] = "Gruppe Lösche"
L["remove group desc"] = "Lösche diese Gruppe (kann nicht rückgängig gemacht werden)"

L["share hint"] = "Aufteilen ist aktiv. Auf ein Item wird nur gefürfelt bis man eins hat. \rDanach wird gepasst bis alle eins haben."

L["add condition"] = "Regel hinzufügen"
L["add condition desc"] = "Füge eine neue Regel der Gruppe hinzu"


L["item condition desc"] = ", separierte liste mit Item Id's. Z.b: 19698,19699,19700"

L["partyMember conditon oneOf"] = "Einer von"
L["partyMember conditon allOf"] = "Alle von"
L["partyMember conditon desc"] = ", separierte liste von Spielernamen"

L["coming soon"] = "Noch nicht umgesetzt, kommt bald :D"


L["have all items this round"] = "Habe bereits mein(e) Items erhalten, passe auf das nächste."
L["entitlement to x"] = "Habe noch Anrecht auf" 
L["entitlement to x, will roll next time"] = "item/s. Würfle auf das Nächste"

L["round"] = "Runde"
L["total won"] = "Total gewonnen"


L["switch to default rules"] = "Raid hat sich aufgelöst, wechsle zu den eigenen Regeln"


L["raid tools desc"] = "Hier kann man seine AutoRoll3000 Regeln, für diesen Raid an alle in der Gruppe senden.\rSolange der Raid läuft können die Regeln jedoch nicht mehr verändert werden!"

L["send rules to raid"] = "Raid Start"
L["send rules to raid desc"] = "Sendet deine Regeln an allen im Raid die das Addon haben. Regeln können danach erst wieder bearbeitet werden, wenn der Raid durch ist!"



L["send raid end"] = "Raid Ende"
L["send raid end desc"] = "Schaltet bei allen die Raid regeln aus."

L["disenchanter toogle"] = "Entzauberer"
L["disenchanter toogle desc"] = "Ich bin zuständig die nicht benötigten Items in Raids zu entzaubern"

L["is disenchanter"] = "Ist Entzauberer"

L["send you a AutoRoll3000 config for this raid. install it?"] = "sendet dir AutoRoll3000 Regeln für diesen Raid, Installieren?"
L["will remove your AutoRoll3000 Raid config. Remove it?"] = "möchte die AutoRoll3000 Raidregeln löschen. Löschen?"
L["Yes"] = "Ja"
L["No"] = "Nein"

L["Raid Rules are now active"] = "Raidregeln sind nun aktiv"
L["Raid Rules are now not active"] = "Raidregeln ausgeschaltet"

L["Raid rules"] = "Reaidregeln"
L["Easy Rules"] = "Einfache Regeln"
L["Raid Tools"] = "Raid Tools"


--@end-do-not-package@
