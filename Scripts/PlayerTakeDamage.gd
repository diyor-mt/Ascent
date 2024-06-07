extends Node


class_name PlayerTakeDamage

signal on_hit(node:Node, damage_taken: int, knockback_direction: Vector2)
@export var dead_animation_name : String="dead"
@export var health: float=100:
	get:
		return health
	set(value):
		SignalBus.emit_signal("on_health_changed",get_parent(),value-health)
		health=value


func hit(damage: int, knockback_direction: Vector2):
	health-=damage
	emit_signal("on_hit", get_parent(), damage, knockback_direction)

func _on_animation_tree_animation_finished(anim_name):
	if(anim_name==dead_animation_name):
		#character is finished dying, remove from game
		get_parent().queue_free()
