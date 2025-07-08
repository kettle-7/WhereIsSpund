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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if (Input.is_key_pressed(KEY_C)):
		_on_skip_button_pressed();


func _on_stage_timer_timeout() -> void:
	stage += 1;
	if (stage == 5):
		hayzeGifs.visible = true;
		$HayzeGifs/Container/Animation1.play();
		$Background1.visible = false;
	pass # Replace with function body.


func _on_skip_button_pressed() -> void:
	get_tree().change_scene_to_file("res://common/scenes/main.tscn");
	pass # Replace with function body.


func _on_hayzeGifs_done() -> void:
	get_tree().change_scene_to_file("res://common/scenes/main.tscn");
	pass # Replace with function body.
