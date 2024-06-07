extends Node

class_name CharacterStateMachine

@export var character : CharacterBody2D
@export var animation_tree : AnimationTree
@export var curr_state : State
#stores all of the states
var states : Array[State]

func _ready():
	
	for child in get_children():
		if(child is State):
			#adds child node if it's a state
			states.append(child)
			
			# Set the states up with what they need to function
			child.character = character
			child.playback = animation_tree["parameters/playback"]
			
			#connect to interrupt signal
			child.connect("interrupt_state",on_state_interrupt_state)
			
		else:
			#to show that child is not state
			push_warning("Child " + child.name + " is not a State for CharacterStateMachine")

func _physics_process(delta):
	#check if there is a next state
	if(curr_state.next_state != null):
		switch_states(curr_state.next_state)
		
	curr_state.state_process(delta)


func check_if_can_move():
	return curr_state.can_move

#switch to new state
func switch_states(new_state : State):
	#exit current state
	if(curr_state != null):
		curr_state.on_exit()
		curr_state.next_state = null
	#set new state and enter it
	curr_state = new_state
	
	curr_state.on_enter()

#handle current state input
func _input(event : InputEvent):
	curr_state.state_input(event)

#for when the current state is interrupted
func on_state_interrupt_state(new_state: State):
	switch_states(new_state)
	
