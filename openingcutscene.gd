extends Node2D

@onready var camera: Camera2D = $MainCamera;
@onready var stageTimer: Timer = $StageTimer;
@onready var evilDude: Sprite2D = $EvilDude;
@onready var townChunk: Sprite2D = $Background1/TownChunk;
@onready var hayzeGifs: CanvasLayer = $HayzeGifs;

var stage = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hayzeGifs.visible = false;
	camera.set_zoom(Vector2(5, 5))
	camera.move_local_x(-300);
	camera.move_local_y(-30);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (stage > 4): return;
	elif (stage == 1 || stage == 2):
		camera.set_zoom(camera.get_zoom() / Vector2(1.005, 1.005))
		camera.move_local_x(1);
		camera.move_local_y(0.1);
	elif (stage == 3 || stage == 4):
		townChunk.move_local_y(-2.5);
	pass


func _on_stage_timer_timeout() -> void:
	stage += 1;
	if (stage == 5):
		hayzeGifs.visible = true;
		$HayzeGifs/Container/Animation1.play();
		$Background1.visible = false;
	pass # Replace with function body.


func _on_skip_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn");
	pass # Replace with function body.


func _on_hayzeGifs_done() -> void:
	get_tree().change_scene_to_file("res://main.tscn");
	pass # Replace with function body.
