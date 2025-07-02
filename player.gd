extends CharacterBody2D

var spawnx = -1206
var spawny = -500
const SPEED = 13
const JUMP_VELOCITY = -70.0
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
@onready var ray_cast_2d = $AnimatedSprite2D/RayCast2D

@onready var walljump_timer = $"walljump timer"

@onready var particles = $"player leaf particles"

@onready var animatedsprite = $AnimatedSprite2D

@onready var collision_shape_2d_2 = $feet

@onready var collision_shape_2d_head = $head

@onready var bubble = $bubble

@onready var debuglabel = $debuglabel

@onready var foreground: Node = $"../.."

@onready var cyote_jump_timer: Timer = $CyoteJumpTimer
@onready var footstep_1: AudioStreamPlayer = $footstep1
@onready var footstep_2: AudioStreamPlayer = $footstep2




@export var bubbleon = 0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")



func _on_pa_area_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
	if str(area.get_name()) == "bounce_hitbox" and velocity.y < 1:
		$Timer.start()
		Input.action_press ("jump", 1)
		
		
		
		velocity.y = -150
 # handle checkpoint collisions
	if str(area.get_name()) == "checkpoint":
		spawnx = area.node_2d.global_position.x
		spawny = area.node_2d.global_position.y - 5
 # handle spike collisions
	if str(area.get_name()) == "spikes":
		
		
		
		
		
		global_position.x = spawnx
		global_position.y = spawny
		velocity.x = 0
		velocity.y = 0

	if str(area.get_name()) == "grabbable1"   or str(area.get_name()) == "grabbable2":
		grabbed = 1
		grabbedid = area
		
	if str(area.get_name()) == "waterarea":
		inwater = true
	

		
func _physics_process(delta):
	# Add the gravity and wall jump
	
	if inwater:
		velocity.y -= 0.02 * gravity
		velocity.y *= 0.99
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
		ray_cast_2d.target_position = Vector2(3,0)
	elif direction <0:
		animatedsprite.flip_h = true
		ray_cast_2d.target_position = Vector2(-3,0)
		
	if not is_on_floor():
		if is_on_wall_only() and velocity.y > 0 and ray_cast_2d.is_colliding():
			jumphold = 4
			velocity.y = 50
		elif velocity.y < 0:
			velocity.y += gravity * delta
		else:
			velocity.y += gravity * delta * 1.2
	
	
	#footstepsounds
	if animatedsprite.animation == "run" and animatedsprite.frame == 0 and not stepped:
		stepped = true
		footstep = !footstep
		if footstep:
			footstep_1.pitch_scale = randf_range(0.7,1.3)
			footstep_2.stop()
			footstep_1.play()
			
		else:
			footstep_1.pitch_scale = randf_range(0.7,1.3)
			footstep_1.stop()
			footstep_2.play()
		
	
	
	detectfall()
	
	
	if animatedsprite.frame != 0:
		stepped = false
	
	# Handle jump.
	if is_on_floor():
		was_on_floor = true
		cyote_jump_timer.start()
	
	
	if is_on_floor():
		jumphold = 0
	
	
	if Input.is_action_pressed("jump") and crouch == false and canjump == true and playercanmove == true and not inwater:
		if jumphold < 4 and velocity.y < 20 or jumphold < 4 and was_on_floor and not is_on_floor():
			velocity.y += JUMP_VELOCITY
			jumphold += 1
			if jumphold == 4:
				Input.action_release ("jump")

#walljump
	
	if is_on_wall_only() and velocity.y > 0 and ray_cast_2d.is_colliding():
		wallsliding = true
	else:
		wallsliding = false
	if Input.is_action_pressed("jump") and playercanmove == true and wallsliding:
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
	if crouch == false or not is_on_floor():
		if Input.is_action_pressed("left") and playercanmove == true and walljumptimer != 1:
				if velocity.x < 1 and not Input.is_action_pressed("right"):
					particles.emitting = true
				else:
					particles.emitting = false
				acceleration += -SPEED
		if Input.is_action_pressed("right") and playercanmove == true and walljumptimer != -1:
				if velocity.x > 1 and not Input.is_action_pressed("left"):
					particles.emitting = true
				else:
					particles.emitting = false
				acceleration += SPEED


	if not Input.is_action_pressed("left") and not Input.is_action_pressed("right") or not is_on_floor():
		particles.emitting = false
	
	
	
		playercanmove = true
	else:
		playercanmove = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	debuglabel.text = str(stepped)



#crouch
	if Input.is_action_pressed("crouch"):
		crouch = true
	else:
		crouch = false
	
	if crouch == true:
		collision_shape_2d_head.disabled = true
	else:
		collision_shape_2d_head.disabled = false
	
# handle animations
	if is_on_wall_only() and velocity.y > 0 and ray_cast_2d.is_colliding():
		
		animatedsprite.play("wallslide")
	elif velocity.y > 1 and not is_on_ceiling():
		animatedsprite.play("fall")
	elif velocity.y < -1 and not is_on_ceiling():
		animatedsprite.play("jump")
	elif crouch == true and playercanmove:
		animatedsprite.play("intocrouch")
	elif direction == 0:
		animatedsprite.play("idle")
	elif playercanmove:
		animatedsprite.play("run")
	else:
		animatedsprite.play("idle")
	
	if is_on_ceiling() and crouch == false:
		crouch = true
	
	
	
	
	if bubbleon == 1:
		$bubble.play("expand")
		
	else:
		$bubble.play("pop")
	
	if bubbleon == 1:
		if Input.is_action_pressed("crouch") == false:
			velocity.y = -40
			if Input.is_action_pressed("jump"):
				bubbleon = 0
				jumphold = 1
		else:
			velocity.y = 40
	
	
	
	if grabbed == 1 and Input.is_action_pressed("grab"):
		global_position = global_position.lerp(grabpos, delta * 10)
		velocity.x = 0
		velocity.y = 0
	if grabbedid != null:
		if str(grabbedid.get_name()) == "grabbable2" and Input.is_action_just_released("grab") and grabbed == 1:
			if grabbedid.node_2d.path_follow_2d.progress_ratio < 0.5:
				velocity.y = -400
			else:
				velocity.y = -200
		elif grabbed == 1 and Input.is_action_just_released("grab"):
			velocity.y = -240
	
	
	move_and_slide()



func detectfall():
	
	if is_on_floor():
		if not justonground:
			footstep_1.play()
			footstep_2.play()
			justonground = true
	else:
		justonground = false


func _on_poparea_body_entered(_body):
		bubbleon = 0



func _on_walljump_timer_timeout():
	walljumptimer = 0
	


func _on_pa_area_shape_exited(_area_rid, area, _area_shape_index, _local_shape_index):
	if str(area.get_name()) == "grabbable1" or str(area.get_name()) == "grabbable2":
		grabbed = 0
	
	if str(area.get_name()) == "waterarea":
		inwater = 0
		velocity.y = 0


func _on_cyote_jump_timer_timeout() -> void:
	was_on_floor = false
