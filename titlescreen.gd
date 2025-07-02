extends Control

var player_scene = preload("res://openingcutscene.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _pressed():
	# feed to other scene
	get_tree().root.add_child(player_scene);
	get_node("/root/Control").free();
	print("you do not have legs")
