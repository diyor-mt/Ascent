
extends State

class_name GroundState

@export var max_charge_time: float = 3.0
@export var min_jump_velocity: float = -500.0
@export var max_jump_velocity: float = -1000.0
@export var air_state : State
@export var jump_animation : String = "jump"
@export var attack_state: State
@export var attack_node: String= "attack1"
@export var attack_animation : String = "attack1"
@onready var buffer_timer: Timer = $BufferTimer
@export var jump_sound: AudioStreamPlayer2D

var jump_timer: float = 0.0
var is_charging_jump: bool = false
#go to air state
func state_process(delta):
	if(!character.is_on_floor() && buffer_timer.is_stopped()):
		next_state = air_state
#handles the charge of the jump and attack
func state_input(event : InputEvent):
	if(event.is_action_pressed("jump")):
		start_charging_jump()
			  
	elif(event.is_action_released("jump")):
		end_charging_jump()
	elif(event.is_action_pressed("attack")):
		attack()
#jump charge starts at 0 seconds and goes up to 2
func start_charging_jump():
	is_charging_jump = true
	jump_timer = 0.0
	
#releases the jump
func end_charging_jump():
	if is_charging_jump:
		is_charging_jump = false
		#longer the spacebar is pressed, the higher player jumps
		var charge_percent = jump_timer / max_charge_time
		var jump_velocity = lerp(min_jump_velocity, max_jump_velocity, charge_percent)
		character.velocity.y = jump_velocity
		next_state = air_state
		playback.travel(jump_animation)
		jump_sound.play()
#processes ongoing jump
func _process(delta):
	if is_charging_jump:
		jump_timer += delta
		jump_timer = clamp(jump_timer, 0, max_charge_time)
#starts the attack state		
func attack():
	next_state=attack_state
	playback.travel(attack_node)



