extends Node

var playerhealth = 100
var spawnx = 2900
var spawny = -8230
var jumpupgrade = true
var walljumpupgrade = true
var dashupgrade = true
var seenNPCs = []
var requestedDialogue = [];
var postDialogueCallback = func(): get_tree().change_scene_to_file("res://common/scenes/main.tscn")
var NPCRequest = "";
var gameDialogues = {
	"ladder": [[0, "Hey, have you seen my cat, Spund? "],[1, "Yeah, he's just up there on that big chunk of rock, but I\ndon't think you'll be able to reach it normally. "],[1, "Hmmm...... "],[1, "Oh! I have an idea. I have a ladder you could\nborrow, it's not doing too much for me right now. "],[0, "That would be great! "],[1, "Alright then, here you go. Good\nluck on your quest to find Spund! "]]
}
