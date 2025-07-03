extends Node

var playerhealth = 100
var spawnx = 98
var spawny = 70
var requestedDialogue = [];
var postDialogueCallback = func(): get_tree().change_scene_to_file("res://main.tscn")
var jumpupgrade = false
var walljumpupgrade = false
var dashupgrade = false
