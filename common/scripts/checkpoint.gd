extends Node2D

@onready var powerup_6: AudioStreamPlayer2D = $Powerup6

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate = Color.BLACK


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_checkpoint_area_entered(area: Area2D) -> void:
	if area.name == "player_area":
		powerup_6.play()
		modulate = Color.WHITE
