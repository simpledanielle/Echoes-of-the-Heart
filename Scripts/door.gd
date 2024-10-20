extends Area2D


enum Emotion { CALM, ANGRY}

var required_emotion = Emotion.CALM  # Set this to the specific emotion for the door
var next_scene_path = "res://Scenes/calmpuzzle.tscn"  # Path to the next scene

var player_in_range = false

func _ready():
	print("Door ready, requires emotion: ", required_emotion)

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true
		print("Player is in range of the door, press 'E' to try to open")

func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		print("Player left the door range")

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("ui_interact"):
		print("Player is trying to open the door")
		
		# Get the player from the group
		var players = get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			var player = players[0]
			if player.current_emotion == required_emotion:
				print("Emotion matches! Door opens.")
				# Change to the next scene
				get_tree().change_scene_to_file("res://Scenes/calmpuzzle.tscn")
			else:
				print("Emotion does not match. Door remains closed.")
