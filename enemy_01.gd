extends CharacterBody2D
@onready var player: CharacterBody2D = $"../../Player"
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var health = 3
@onready var timer: Timer = $Timer

var can_see_player = false
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "Bulletarea":
		health -= 1
		modulate = Color.RED
		timer.start()
	
	if health < 1:
		
		queue_free()

func _process(delta: float) -> void:
	
	if can_see_player:
		global_position = lerp(global_position, player.global_position,0.01)
	print(can_see_player)
	if player.global_position.x > global_position.x:
		animated_sprite_2d.flip_h = false
	else:
		animated_sprite_2d.flip_h = true
	
	
	move_and_slide()


func _on_timer_timeout() -> void:
	modulate = Color.WHITE
	


func _on_view_area_area_entered(area: Area2D) -> void:
	if area.name == "player_area":
		can_see_player = true
	
