extends Node

var playerhealth = 100
var spawnx = 98
var spawny = 70
var jumpupgrade = true
var walljumpupgrade = true
var dashupgrade = true
var seenNPCs = []
var requestedDialogue = [];
var postDialogueCallback = func(): get_tree().change_scene_to_file("res://common/scenes/main.tscn")
var NPCRequest = "";
var gameDialogues = {
	"ladder": [[0, "i'm the main character"],[1, "waaaaaaaaaaaaaaa :<"]]
}
