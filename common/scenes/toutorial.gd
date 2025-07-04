extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate.a = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_anything_pressed():
		modulate.a -= 0.01
