extends CharacterBody2D

@onready var animation_tree: AnimationTree=$AnimationTree
@export var speed: float = 30.0
@export var sprite: Sprite2D
var dead =false
var player_in_area=false
var player=null
var player_in_hitbox=false
@export var animation_player: AnimationPlayer
var player_chase=false
@export var sprite2d: Sprite2D
@export var hit_state: State
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	dead=false
	animation_tree.active=true
	
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
#chase player if he is not dead	
	if !dead:
		$detection_area_right/CollisionShape2D.disabled=false
		$detection_area_left/CollisionShape2D.disabled=false
		#walk towards player if he can be detected and attack him
		if player_in_area:
			position += (player.position-position)/speed
			animation_player.play("walk")
			if player_in_hitbox:
				animation_player.play("attack1")
		else:
			animation_player.play("idle")
		
		
			
#do not chase player if he is dead	
	if dead:
		$detection_area_right/CollisionShape2D.disabled=true
		$detection_area_left/CollisionShape2D.disabled=true
	move_and_slide()

#check to see if the player is on the right
func _on_detection_area_body_entered(body):
	if body.has_method("player"):
		player_in_area=true
		player=body
		sprite2d.flip_h=false


func _on_detection_area_body_exited(body):
	if body.has_method("player"):
		player_in_area=false
		
#check to see if the player is on the left and flip the sprite
func _on_detection_area_left_body_entered(body):
	if body.has_method("player"):
		player_in_area=true
		player=body
		sprite2d.flip_h=true


func _on_detection_area_left_body_exited(body):
	if body.has_method("player"):
		player_in_area=false


func enemy():
	pass
	


#player has lef the hitbox area
func _on_hitbox_body_exited(body):
	if body.has_method("player"):
		player_in_hitbox=false;

#player has entered hitbox area
func _on_hitbox_body_entered(body):
	if body.has_method("player"):
		player_in_hitbox=true;
		player=body
