extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_area_entered(area: Area2D) -> void:
	GAME.playerhealth = 100
	get_tree().change_scene_to_file("res://sprites_and_animations/deathscene.tscn")
	pass # Replace with function body.
