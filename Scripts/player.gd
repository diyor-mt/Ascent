extends CharacterBody2D
class_name Player
@export var speed : float = 200.0

@onready var sprite : Sprite2D = $Sprite2D
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var state_machine : CharacterStateMachine = $CharacterStateMachine
@onready var walking_sound: AudioStreamPlayer2D=$walk
@export var anim_player: AnimationPlayer
var health: float=100.0
var enemy_in_range=false
var enemy_cooldown=true

var is_player_alive=true


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction : Vector2 = Vector2.ZERO
signal facing_direction_changed(facing_right:bool)
func _ready():
	animation_tree.active = true

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_vector("left", "right", "up", "down")
	
	# Control whether to move or not to move
	if direction.x != 0 && state_machine.check_if_can_move():
		velocity.x = direction.x * speed
		if is_on_floor() && !walking_sound.playing:
			walking_sound.play()	
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		

	move_and_slide()
	
	
	update_animation_parameters()
	update_facing_direction()
	enemy_attack()
	if health<=0:
		is_player_alive=false
		health=0
		anim_player.play("dead")
		
		self.queue_free()
		
		
	
func update_animation_parameters():
	animation_tree.set("parameters/move/blend_position", direction.x)
func update_facing_direction():
	if direction.x > 0:
		sprite.flip_h = false
		
	elif direction.x < 0:
		sprite.flip_h = true
	emit_signal("facing_direction_changed",!sprite.flip_h)
	
	
func player():
	pass

func _on_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_in_range=true
		


func _on_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_in_range=false
	
func enemy_attack():
	if enemy_in_range and enemy_cooldown==true:
		health-=20
		enemy_cooldown=false
		$cooldown.start()
			


func _on_cooldown_timeout():
	enemy_cooldown=true
	
