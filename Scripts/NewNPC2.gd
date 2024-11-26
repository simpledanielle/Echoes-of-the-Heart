extends StaticBody2D

enum Emotion { CALM, ANGRY }  # Only CALM and ANGRY emotions
@export var emotion_effect: Emotion = Emotion.CALM  # Emotion this item applies
@export var remove_on_use: bool = true  # Whether the item disappears after use

@export var npc_id: String
@export var npc_name: String

@onready var choice_container = "res://Resources/Dialog/dialog_data.json" # Make sure to link this to the actual node path in your scene tree # Reference to the dialog resource

var dialog_tree = {}  # Declare dialog_tree as an empty dictionary
# Dialog vars
@onready var dialog_manager = $DialogManager
@export var dialog_resource: Dialog
var current_state = "start"
var current_branch_index = 0

func _ready():
	# Load dialog data
	dialog_resource.load_from_json("res://Resources/Dialog/dialog_data.json")
	# Initialize npc ref
	dialog_manager.npc = self

func start_dialog():
	var npc_dialogs = dialog_resource.get_npc_dialog(npc_id)
	if npc_dialogs == null:
		print("Error: No dialog found for NPC ID:", npc_id)
		return
	
	if npc_dialogs.is_empty():
		print("Error: Dialog array is empty for NPC ID:", npc_id)
		return

	dialog_manager.show_dialog(self)


# Get current branch dialog
func get_current_dialog():
	var npc_dialogs = dialog_resource.get_npc_dialog(npc_id) 
	if current_branch_index < npc_dialogs.size():
		for dialog in npc_dialogs[current_branch_index]["dialogs"]:
			if dialog["state"] == current_state:
				return dialog
	return null

# Update dialog branch
func set_dialog_tree(branch_index):
	current_branch_index = branch_index
	current_state = "start"

# Update dialog state
func set_dialog_state(state):
	current_state = state


func apply_emotion(emotion_choice: String):
	var player = get_tree().get_nodes_in_group("player")[0]
	if player:
		match emotion_choice:
			"ANGRY":
				player.set_emotion(Emotion.ANGRY)
			"CALM":
				player.set_emotion(Emotion.CALM)
			_:
				player.set_emotion(Emotion.CALM)  # Default emotion
		print("Applied emotion:", emotion_choice)
		
		if remove_on_use:
			queue_free()  # Remove the item from the scene
	else:
		print("Player node not found.")



# Update choices in dialog, and trigger emotion when a choice is made
func update_choices(choices: Dictionary):
	# Remove all previous buttons
	for child in choice_container.get_children():
		choice_container.remove_child(child)
		child.queue_free()

	# Iterate through choices and update buttons
	for choice_text in choices.keys():
		var next_state = choices.get(choice_text)  # Get the next state for the choice
		var emotion = dialog_resource[npc_id][next_state]["emotion"]  # Get emotion from JSON

		var button = Button.new()
		button.text = choice_text
		button.connect("pressed", Callable(self, "_on_choice_selected").bind(next_state, emotion))
		choice_container.add_child(button)

func _on_choice_selected(next_state: String, emotion_choice: String):
	current_state = next_state
	apply_emotion(emotion_choice)  # Apply emotion based on the choice
   # Show the next dialog after the choice is made
