extends Node2D

@onready var camera: Camera2D = $MainCamera;

var stage = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	camera.set_zoom(camera.get_zoom() * Vector2(1.005, 1.005))
	pass
