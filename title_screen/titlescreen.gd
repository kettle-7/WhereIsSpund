extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (GAME.hasPlayed):
		$"../PlayButton2".visible = true;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _pressed():
	# feed to other scene
	if GAME.hasPlayed:
		get_tree().change_scene_to_file("res://common/scenes/main.tscn");
		return;
	GAME.hasPlayed = true;
	get_tree().change_scene_to_file("res://opening_scene/openingcutscene.tscn");


func _on_reset_pressed() -> void:
	GAME.playerhealth = 100
	GAME.spawnx = 98
	GAME.spawny = 70
	GAME.jumpupgrade = false
	GAME.walljumpupgrade = false
	GAME.dashupgrade = false
	GAME.seenNPCs = []
	get_tree().change_scene_to_file("res://opening_scene/openingcutscene.tscn")
	pass # Replace with function body.
