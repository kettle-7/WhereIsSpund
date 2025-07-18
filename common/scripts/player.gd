extends CharacterBody2D

const SPEED = 45
var JUMP_VELOCITY = -150.0
var jumphold = 0
var dir = 1
var acceleration = 0
var crouch = false
var canjump  = true
var shader_material : ShaderMaterial
var playercanmove = true
var wallsliding = false
var walljumptimer = 0
var grabbed = 0
var grabbedid = null
var grabpos = Vector2(0,0)
var inwater = false
var justbounced = false
var was_on_floor = false
var footstep = false
var stepped = false
var justonground = false
var canshoot = true
var candash = false
@onready var hurt_effect: TextureRect = $"../StaticUI/Hurt effect"

@onready var ray_cast_2d = $AnimatedSprite2D/RayCast2D
@onready var walljump_timer = $"walljump timer"
@onready var animatedsprite = $AnimatedSprite2D

const BULLET = preload("res://common/scenes/bullet.tscn")
@onready var collision_shape_2d_head = $head
@onready var bubble = $bubble
@onready var debuglabel = $debuglabel
@onready var cyote_jump_timer: Timer = $CyoteJumpTimer
@onready var shooting_cooldown: Timer = $"shooting cooldown"
@onready var shoot: AudioStreamPlayer = $shoot
@onready var hurt: AudioStreamPlayer = $hurt

@export var bubbleon = 0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	
		global_position.x = GAME.spawnx
		global_position.y = GAME.spawny
		velocity.x = 0
		velocity.y = 0

func _on_pa_area_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
	if str(area.get_name()) == "bounce_hitbox" and velocity.y < 1:
		$Timer.start()
		Input.action_press ("jump", 1)
		velocity.y = -150
	# handle checkpoint collisions
	if str(area.get_name()) == "checkpoint":
		GAME.spawnx = area.global_position.x
		GAME.spawny = area.global_position.y - 10
	# handle spike collisions
	if str(area.get_name()) == "spikes":
		if GAME.walljumpupgrade:
			animatedsprite.play("death_backpack_boots")
		elif GAME.jumpupgrade:
			animatedsprite.play("death_boots")
		else:
			animatedsprite.play("death")
		GAME.playerhealth = 100
		get_tree().reload_current_scene()


	if str(area.get_name()) == "grabbable1"   or str(area.get_name()) == "grabbable2":
		grabbed = 1
		grabbedid = area
		
	
	if str(area.get_name()) == "hurtbox":
		hurt_effect.self_modulate.a = 1
		hurt.play()
		GAME.playerhealth -= randi_range(25,50)

func _physics_process(delta):
	
	
	if GAME.playerhealth < 10:
		if GAME.walljumpupgrade:
			animatedsprite.play("death_backpack_boots")
		elif GAME.jumpupgrade:
			animatedsprite.play("death_boots")
		else:
			animatedsprite.play("death")
		
		await get_tree().create_timer(0.9375).timeout
		GAME.playerhealth = 100
		get_tree().reload_current_scene()
	
	if GAME.jumpupgrade:
		JUMP_VELOCITY = -160
	else:
		JUMP_VELOCITY = -110
	
	if (Input.is_key_pressed(KEY_E)):
		GAME.spawnx = global_position.x;
		GAME.spawny = global_position.y;
	
	if (Input.is_key_pressed(KEY_R)):
		get_tree().reload_current_scene();
	
	
	if is_on_floor():
		candash = true
	
	if Input.is_action_just_pressed("dash") and candash and GAME.dashupgrade:
		candash = false
		if Input.is_action_pressed("left"):
			acceleration += -SPEED * 25
		if Input.is_action_pressed("right"):
			acceleration += SPEED * 25
	
	if grabbedid != null:
		grabpos = grabbedid.global_position
	
	var direction = Input.get_axis("left", "right")
	if playercanmove == true:
		dir = Input.get_axis("left", "right")
	
	if direction:
		velocity.x = acceleration
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if direction > 0:
		animatedsprite.flip_h = false
		ray_cast_2d.target_position = Vector2(7,0)
	elif direction <0:
		animatedsprite.flip_h = true
		ray_cast_2d.target_position = Vector2(-7,0)
		
	if not is_on_floor():
		if is_on_wall_only() and velocity.y > 0 and ray_cast_2d.is_colliding():
			jumphold = 1
			velocity.y = 50
		elif velocity.y < 0:
			velocity.y += gravity * delta
		else:
			velocity.y += gravity * delta * 1.8
	
	if animatedsprite.frame != 0:
		stepped = false
	
	# Handle jump.
	if is_on_floor():
		was_on_floor = true
		cyote_jump_timer.start()
	
	if is_on_floor():
		jumphold = 0
	
	if Input.is_action_pressed("up") and canjump == true and playercanmove == true and not inwater:
		if jumphold < 4 and velocity.y < 20 or jumphold < 4 and was_on_floor and not is_on_floor():
			velocity.y += JUMP_VELOCITY
			jumphold += 1
			if jumphold == 4:
				Input.action_release ("up")

	# walljump
	if is_on_wall_only() and velocity.y > 0 and ray_cast_2d.is_colliding() and GAME.walljumpupgrade:
		wallsliding = true
	else:
		wallsliding = false
	if Input.is_action_pressed("up") and playercanmove == true and wallsliding:
		walljumptimer = direction * -1
		walljump_timer.start()
		velocity.y = -200
		if direction:
			velocity.x = move_toward(velocity.x, 0, -SPEED - 150)
			direction = !direction
			acceleration = -acceleration
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED + 150)
			direction = !direction
			acceleration = -acceleration
			
	if is_on_floor():
		acceleration *= 0.9
	else:
		acceleration *= 0.91
	# acceleration

	if Input.is_action_pressed("left") and playercanmove == true and walljumptimer != 1:
			acceleration += -SPEED
	if Input.is_action_pressed("right") and playercanmove == true and walljumptimer != -1:
			acceleration += SPEED

	playercanmove = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	debuglabel.text = str(stepped)

	# crouch
	# handle animations
	if is_on_wall_only() and velocity.y > 0 and ray_cast_2d.is_colliding():
		if GAME.walljumpupgrade:
			animatedsprite.play("wallslide_backpack_boots")
		elif GAME.jumpupgrade:
			animatedsprite.play("wallslide_boots")
		else:
			animatedsprite.play("wallslide")
	elif velocity.y > 1 and not is_on_ceiling(): #fall
		if GAME.walljumpupgrade:
			animatedsprite.play("fall_backpack_boots")
		elif GAME.jumpupgrade:
			animatedsprite.play("fall_boots")
		else:
			animatedsprite.play("fall")
	elif velocity.y < -1 and not is_on_ceiling(): #jump
		if GAME.walljumpupgrade:
			animatedsprite.play("jump_backpack_boots")
		elif GAME.jumpupgrade:
			animatedsprite.play("jump_boots")
		else:
			animatedsprite.play("jump")
	elif direction == 0: #idle
		if GAME.walljumpupgrade:
			animatedsprite.play("idle_backpack_boots")
		elif GAME.jumpupgrade:
			animatedsprite.play("idle_boots")
		else:
			animatedsprite.play("idle")
	elif playercanmove: #run
		if GAME.walljumpupgrade:
			animatedsprite.play("run_backpack_boots")
		elif GAME.jumpupgrade:
			animatedsprite.play("run_boots")
		else:
			animatedsprite.play("run")
	else: #idle
		if GAME.walljumpupgrade:
			animatedsprite.play("idle_backpack_boots")
		elif GAME.jumpupgrade:
			animatedsprite.play("idle_boots")
		else:
			animatedsprite.play("idle")
	
	# bullets
	if Input.is_action_pressed("z") and canshoot:
		var instance = BULLET.instantiate()
		instance.position = Vector2(0,0)
		shooting_cooldown.start()
		instance.global_position = global_position
		instance.direction = !animatedsprite.flip_h
		canshoot = false
		shooting_cooldown.start()
		shoot.play()
		add_sibling(instance)
		
	
	move_and_slide()

func _on_walljump_timer_timeout():
	walljumptimer = 0
	
func _on_pa_area_shape_exited(_area_rid, area, _area_shape_index, _local_shape_index):
	pass

func _on_cyote_jump_timer_timeout() -> void:
	was_on_floor = false

func _on_shooting_cooldown_timeout() -> void:
	canshoot = true


func _farmer_speech(area: Area2D) -> void:
	if ("ladder" in GAME.seenNPCs):
		$"../Ladder".visible = true;
		$"../Ladder/StaticBody2D/CollisionPolygon2D".disabled = false;
		return;
	GAME.seenNPCs.append("ladder");
	GAME.requestedDialogue = GAME.gameDialogues["ladder"];
	GAME.NPCRequest = "farmer";
	GAME.spawnx = global_position.x;
	GAME.spawny = global_position.y;
	get_tree().change_scene_to_file("res://dialogues/dialogue.tscn");
	pass # Replace with function body.


func _on_animated_sprite_2d_animation_finished(anim) -> void:
	pass # Replace with function body.
