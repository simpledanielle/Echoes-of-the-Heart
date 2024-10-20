extends Area2D

enum Emotion { CALM, ANGRY } 
var player_in_range = false


func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):  # Ensure the player has been added to the "player" group
		player_in_range = true
		print("player is in range, press 'E' to interact")  # Change the player's emotion to Angry
	   
func _on_Area2D_body_exited(body):
		if body.is_in_group("player"):
			player_in_range = false
			print("Player left the range")


func _process(delta):
	if player_in_range and Input.is_action_just_pressed("ui_interact"):
		print("Player interacted with the item")
		var player = get_tree().get_nodes_in_group("player")[0]
		player.set_emotion(Emotion.ANGRY)
