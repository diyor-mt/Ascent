extends Node
class_name Take_Damage

signal on_hit(node:Node, damage_taken: int, knockback_direction: Vector2)
@export var dead_animation_name : String="dead"
@export var health: float=50:
	get:
		return health
	set(value):
		SignalBus.emit_signal("on_health_changed",get_parent(),value-health)
		health=value

#hits the enemy and decreases health
func hit(damage: int, knockback_direction: Vector2):
	health-=damage
	emit_signal("on_hit", get_parent(), damage, knockback_direction)
#gets rid of enemy from scene once he is dead
func _on_animation_tree_animation_finished(anim_name):
	if(anim_name==dead_animation_name):
		#character is finished dying, remove from game
		get_parent().queue_free()
