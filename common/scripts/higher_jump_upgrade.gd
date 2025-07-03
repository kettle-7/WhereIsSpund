extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GAME.jumpupgrade:
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	print("onarea")
	if area.get_name() == "player_area":
		print('inplayer')
		GAME.jumpupgrade = true
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("onbody")
	if body.get_name() == "Player":
		print('inplayer')
		GAME.jumpupgrade = true
		queue_free()
