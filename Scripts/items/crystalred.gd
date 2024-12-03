extends Area2D

enum Emotion { CALM, ANGRY }
@export var emotion_effect: Emotion = Emotion.CALM  # Set default emotion effect for the item

var current_node = "start"
var player_in_range = false
var interacting_item = null
var dialogue_visible = false
var dialogue_tree = {
	"start": {
		"text": "A crystal. Looks very hot",
		"choices": [
			{"text": "Hold it", "next": "hold_it"},
			{"text": "Shake it", "next": "shake_it"}
		]
	},
	"hold_it": {
		"text": "A child is inside. They appreciate the love.",
		"choices": []
	},
	"shake_it": {
		"text": "A small child is inside. They look annoyed.",
		"choices": []
	}
}

@onready var dialogue_label = $"Angry Dialogue/Dialogue"
@onready var choice_container = $"Angry Dialogue/ChoiceContainer"

func _ready():
	dialogue_label.visible = false
	choice_container.visible = false

# Detect if player enters interaction range
func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true
		interacting_item = self  # Set this item as the active interacting item
		print("Player in range of NPC. Press [E]")

# Detect if player exits interaction range
func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		if interacting_item == self:
			interacting_item = null  # Clear the active interacting item
		hide_dialogue()
		print("Player left the range of NPC")

# Toggle dialogue with interaction
func _process(delta):
	if player_in_range and Input.is_action_just_pressed("ui_interact"):
		if interacting_item == self:  # Ensure interaction is with the correct item
			if dialogue_visible:
				hide_dialogue()
			else:
				show_dialogue()

# Show dialogue text and choices
func show_dialogue():
	var node = dialogue_tree[current_node]
	dialogue_label.text = node["text"]
	dialogue_label.visible = true
	choice_container.visible = true
	update_choices(node["choices"])
	dialogue_visible = true

# Hide dialogue
func hide_dialogue():
	dialogue_label.visible = false
	choice_container.visible = false
	dialogue_visible = false

# Update dialogue choices dynamically
func update_choices(choices):
	# Clear previous choices
	for child in choice_container.get_children():
		child.queue_free()

	# Create new choice buttons
	for choice in choices:
		var button = Button.new()
		button.text = choice["text"]
		button.connect("pressed", Callable(self, "_on_choice_selected").bind(choice["next"]))
		choice_container.add_child(button)

# Handle choice selection and node navigation
func _on_choice_selected(next_node):
	current_node = next_node
	if current_node == "hold_it" or current_node == "shake_it":
		apply_emotion()  # Set emotion and remove item after interaction
	else:
		show_dialogue()

# Apply emotion effect to player and remove item
func apply_emotion():
	var player = get_tree().get_nodes_in_group("player")[0]
	player.set_emotion(emotion_effect)
	hide_dialogue()
	queue_free()  # Remove the item after interaction
