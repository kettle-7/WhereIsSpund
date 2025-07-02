extends Node2D

@onready var camera: Camera2D = $MainCamera;
@onready var stageTimer: Timer = $StageTimer;
@onready var evilDude: Sprite2D = $EvilDude;
@onready var townChunk: Sprite2D = $Background1/TownChunk;

var stage = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (stage == 0):
		camera.set_zoom(camera.get_zoom() * Vector2(1.005, 1.005))
	elif (stage == 2):
		camera.set_zoom(camera.get_zoom() / Vector2(1.005, 1.005))
	elif (stage == 3):
		townChunk.move_local_y(-2.5);
	pass


func _on_stage_timer_timeout() -> void:
	stage += 1;
	if (stage == 4):
		get_tree().change_scene_to_file("res://main.tscn")
	pass # Replace with function body.


func _on_skip_button_pressed() -> void:
	pass # Replace with function body.
