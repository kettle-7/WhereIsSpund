extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

@onready var left: RayCast2D = $left
@onready var right: RayCast2D = $right
var dir = 10
var health = 3
const gravity = 5

func _process(delta: float) -> void:
	
	move_local_x(dir)
	if left.is_colliding():
		dir = 5
		animated_sprite_2d.flip_h = false
		
	if right.is_colliding():
		dir = -5
		animated_sprite_2d.flip_h = true


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.name == "Bulletarea":
		health -= 1
		modulate = Color.RED
		timer.start()
	
	if health < 1:
		
		queue_free()


func _on_timer_timeout() -> void:
	modulate = Color.WHITE
	
