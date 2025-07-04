extends Node2D


@onready var credittybox: VBoxContainer = $CredittyBox

var credits_time = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (credits_time):
		credittybox.set_position(Vector2(credittybox.get_position().x, credittybox.get_position().y - 1));
	pass


func _on_first_hayzegif_done() -> void:
	$FireGif/AnimatedSprite2D.visible = false;
	$AnotherTimer.start();
	pass # Replace with function body.


func _credits_time() -> void:
	print("e")
	credits_time = true;
	$DoneTimer.start();
	pass # Replace with function body.


func _on_done_timer_timeout() -> void:
	print("d")
	get_tree().change_scene_to_file("res://title_screen/titlescreen.tscn")
	pass # Replace with function body.


func _on_another_timer_timeout() -> void:
	$FireGif.visible = false;
	$CreditsTimer.start();
	$AnimatedSprite2D2.play();
	pass # Replace with function body.
