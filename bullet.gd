extends Node2D
var direction = false
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if direction:
		move_local_x(10)
		animated_sprite_2d.flip_h = false
	else:
		move_local_x(-10)
		animated_sprite_2d.flip_h = true



func _on_area_2d_body_entered(body: Node2D) -> void:
	queue_free()
