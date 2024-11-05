extends Area2D

enum Emotion { CALM, ANGRY } 
var player_in_range = false
@onready var dialogue_ui = get_node("DialogueUI")  # Adjust path to your Dialogue UI

@export var emotion_effect: Emotion = Emotion.CALM  # Set emotion type via inspector
@export var points: int = 10  # Points to add

func _ready():
	# Locate the DialogueUI node in the scene tree
	dialogue_ui = get_node("DialogueUI")  # Adjust the path based on your scene structure

	# Verify if the node exists
	if dialogue_ui:
		dialogue_ui.visible = false  # Ensure it starts hidden
	else:
		print("Error: DialogueUI node not found!")

func shows_dialogue():
	if dialogue_ui:
		dialogue_ui.visible = true
	else:
		print("Error: Unable to show DialogueUI; node not found.")

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):  # Ensure player has been added to "player" group
		player_in_range = true
		print("Player is in range, press 'E' to interact")

func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		print("Player left the range")

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("ui_interact"):
		show_dialogue()

# Shows dialogue with options
func show_dialogue():
	dialogue_ui.visible = true
	dialogue_ui.show_dialogue("Do you want to interact with this item?", "Yes", "No")
	dialogue_ui.connect("dialogue_choice", Callable(self, "_on_dialogue_choice"))

# Handles player choice from dialogue
func _on_dialogue_choice(choice: String):
	if choice == "Yes":
		print("Player chose to interact!")
		apply_emotion()
	else:
		print("Player chose not to interact.")
	dialogue_ui.visible = false

# Applies the emotion effect and removes the item
func apply_emotion():
	var player = get_tree().get_nodes_in_group("player")[0]
	player.set_emotion(emotion_effect)
	queue_free()  # Remove the item after interaction
