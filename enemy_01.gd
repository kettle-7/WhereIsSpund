extends Node2D
@onready var player: CharacterBody2D = $"../../Player"
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var health = 3
@onready var timer: Timer = $Timer

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "Bulletarea":
		health -= 1
		modulate.r = 255
		timer.start()
	
	if health < 1:
		queue_free()

func _process(delta: float) -> void:
	
	global_position = lerp(global_position,player.global_position,0.01)
	
	if player.global_position.x > global_position.x:
		animated_sprite_2d.flip_h = false
	else:
		animated_sprite_2d.flip_h = true


func _on_timer_timeout() -> void:
	modulate.r = 0
