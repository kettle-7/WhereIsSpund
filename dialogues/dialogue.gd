extends Node2D

@onready var PlayerSpeech = $PlayerSpeechContainer/P/MarginContainer/PlayerSpeech;
@onready var NPCSpeech = $NPCSpeechContainer/P/MarginContainer/NPCSpeech;

var currentDialogue = [];
var line = 0;
var beats = 0;
var direction = true;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentDialogue = GAME.requestedDialogue;
	line = 0;
	beats = 0;
	direction = true;
	if (currentDialogue[0][0]):
		$PlayerSpeechContainer.hidden = false;
		$NPCSpeechContainer.hidden = true;
	else:
		$PlayerSpeechContainer.hidden = true;
		$NPCSpeechContainer.hidden = false;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_heartbeat() -> void:
	beats += 1;
	if (beats >= len(currentDialogue[line][1])):
		if (direction):
			direction = !direction;
			beats = 0;
		else:
			direction = !direction;
			beats = 0;
			line += 1;
		if (currentDialogue[0][0]):
			$PlayerSpeechContainer.hidden = false;
			$NPCSpeechContainer.hidden = true;
		else:
			$PlayerSpeechContainer.hidden = true;
			$NPCSpeechContainer.hidden = false;
