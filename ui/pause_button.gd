extends TextureButton
@onready var player: CharacterBody2D = $"../../../Player"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (!GAME.wantsMusic):
		$"../../../AudioStreamPlayer".stop();
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _pressed() -> void:
	GAME.spawnx = player.global_position.x;
	GAME.spawny = player.global_position.y;
	get_tree().change_scene_to_file("res://title_screen/titlescreen.tscn");


func _on_soundnt_button_pressed() -> void:
	GAME.wantsMusic = !GAME.wantsMusic;
	if (!GAME.wantsMusic):
		$"../../../AudioStreamPlayer".stop();
	else:
		$"../../../AudioStreamPlayer".play();
	pass # Replace with function body.
