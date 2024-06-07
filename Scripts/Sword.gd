extends Area2D

@export var damage: int=10
@export var player: Player
@export var facing_shape: FacingCollisionShape2D

func _ready():
	monitoring=false
	player.connect("facing_direction_changed", _on_player_facing_direction_changed)

func _on_body_entered(body):
	for child in body.get_children():
		#checks if the sword is entering the enemy
		if child is Take_Damage:
			#get direction from sword to body
			var direction_to_damageable=(body.global_position- get_parent().global_position )
			var direction_sign= sign(direction_to_damageable.x)
			
			if(direction_sign>0):
				child.hit(damage, Vector2.RIGHT)
			elif(direction_sign<0):
				child.hit(damage, Vector2.LEFT)
			else:
				child.hit(damage, Vector2.ZERO)
				
#flips the sword hitbox depending on which direction the player is facing
func _on_player_facing_direction_changed(facing_right: bool):
	if(facing_right):
		facing_shape.position=facing_shape.facing_right_position
	else:
		facing_shape.position=facing_shape.facing_left_position
	