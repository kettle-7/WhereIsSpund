extends Node2D
@onready var powerup_6: AudioStreamPlayer2D = $Powerup6


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	powerup_6.play()
	GAME.playerhealth = 100
	queue_free()
