extends State

class_name EnemyHit

@export var Take_Damage: Take_Damage
@export var character_state_machine: CharacterStateMachine
@export var animation_player: AnimationPlayer
@export var dead_state: State
@export var dead_node : String="dead"
@export var knockback_speed: float=100.0
@export var return_state: State
@onready var timer: Timer=$Timer

func _ready():
	Take_Damage.connect("on_hit",on_damageable_hit)	
func on_enter():	
	timer.start() 
#either switch to hit or dead depending on enemy health
func on_damageable_hit(node: Node, damage_amount: int, knockback_direction: Vector2):
	if Take_Damage.health>0:
		animation_player.play("hurt")
		#apply knockback
		character.velocity= knockback_speed * knockback_direction
		emit_signal("interrupt_state", self)
	else:
		emit_signal("interrupt_state",dead_state)
		playback.travel(dead_node)
#reset enemy's velocity
func on_exit():
	character.velocity=Vector2.ZERO

func _on_timer_timeout():
	next_state=return_state
