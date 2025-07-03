extends Node2D

@onready var PlayerSpeech: Label = $PlayerSpeechContainer/P/MarginContainer/PlayerSpeech;
@onready var NPCSpeech: Label = $NPCSpeechContainer/P/MarginContainer/NPCSpeech;
@onready var heartbeatTimer: Timer = $DialogueHeartbeat;

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
		$PlayerSpeechContainer.visible = false;
		$NPCSpeechContainer.visible = true;
	else:
		$PlayerSpeechContainer.visible = true;
		$NPCSpeechContainer.visible = false;
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
			if (line >= len(currentDialogue)):
				heartbeatTimer.stop();
				GAME.postDialogueCallback.call();
		if (currentDialogue[line][0]):
			$PlayerSpeechContainer.visible = false;
			$NPCSpeechContainer.visible = true;
		else:
			$PlayerSpeechContainer.visible = true;
			$NPCSpeechContainer.visible = false;
	if (direction):
		if (currentDialogue[line][0]):
			NPCSpeech.text = currentDialogue[line][1].substr(0, beats)
		else:
			PlayerSpeech.text = currentDialogue[line][1].substr(0, beats)
		pass
	else:
		if (currentDialogue[line][0]):
			NPCSpeech.text = currentDialogue[line][1].substr(beats,-1)
		else:
			PlayerSpeech.text = currentDialogue[line][1].substr(beats, -1)
		pass
