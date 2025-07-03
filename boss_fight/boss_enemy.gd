extends CharacterBody2D
@onready var player: CharacterBody2D = $"../Player"
const BOSS_BULLET = preload("res://boss_fight/boss_bullet.tscn")
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var health = 20
@onready var timer: Timer = $Timer
@onready var timer_2: Timer = $Timer2



var can_see_player = false


func _process(delta: float) -> void:
	
	
	global_position = lerp(global_position, player.global_position,0.01)
	
	if not player.global_position.x > global_position.x:
		animated_sprite_2d.flip_h = false
	else:
		animated_sprite_2d.flip_h = true
	
	
	move_and_slide()


func _on_timer_timeout() -> void:
	modulate = Color.WHITE
	


func _on_view_area_area_entered(area: Area2D) -> void:
	if area.name == "player_area":
		can_see_player = true
	


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.name == "Bulletarea":
		
		health -= 1
		modulate = Color.RED
		timer.start()
	
	if health < 1:
		
		queue_free()


func _on_timer_2_timeout() -> void:
	var instance = BOSS_BULLET.instantiate()
	instance.global_position = global_position
	instance.look_at(player.global_position)
	add_sibling(instance)
