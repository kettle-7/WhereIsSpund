extends Node

var playerhealth = 100
var spawnx = 98
var spawny = 70
var jumpupgrade = true
var walljumpupgrade = true
var dashupgrade = true
var requestedDialogue = [[0, "eeeeeeeeeeeeeeeeeeeeeee"], [1, "üüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüüü\nüüüüüüüüüüüü"]];
var postDialogueCallback = func(): get_tree().change_scene_to_file("res://main.tscn")
