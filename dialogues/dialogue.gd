extends Node2D

@onready var PlayerSpeech: Label = $PlayerSpeechContainer/P/MarginContainer/PlayerSpeech;
@onready var NPCSpeech: Label = $NPCSpeechContainer/P/MarginContainer/NPCSpeech;
@onready var heartbeatTimer: Timer = $DialogueHeartbeat;

var currentDialogue = [];
var line = 0;
var beats = 0;
var direction = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentDialogue = GAME.requestedDialogue;
	if (GAME.NPCRequest == "farmer"):
		$Farmer.visible = true;
	elif (GAME.NPCRequest == "wizard"):
		$Wizard.visible = true;
	elif (GAME.NPCRequest == "climber"):
		$Climber.visible = true;
	line = 0;
	beats = 0;
	direction = 0;
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
		if (direction == 0):
			direction = 1;
			beats = 0;
		elif (direction == 1):
			direction = 2;
		else:
			direction = 0;
			beats = 0;
			line += 1;
			if (line >= len(currentDialogue)):
				heartbeatTimer.stop();
				GAME.postDialogueCallback.call();
				return;
		if (currentDialogue[line][0]):
			$PlayerSpeechContainer.visible = false;
			$NPCSpeechContainer.visible = true;
		else:
			$PlayerSpeechContainer.visible = true;
			$NPCSpeechContainer.visible = false;
	if (direction == 0):
		if (currentDialogue[line][0]):
			NPCSpeech.text = currentDialogue[line][1].substr(0, beats);
		else:
			PlayerSpeech.text = currentDialogue[line][1].substr(0, beats);
		pass
	elif (direction == 1):
		return;
	else:
		if (currentDialogue[line][0]):
			NPCSpeech.text = currentDialogue[line][1].substr(beats,-1);
		else:
			PlayerSpeech.text = currentDialogue[line][1].substr(beats, -1);
		pass
