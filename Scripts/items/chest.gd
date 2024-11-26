extends Area2D


enum Emotion { CALM, ANGRY }
@export var emotion_effect: Emotion = Emotion.ANGRY  # Set default emotion effect for the item

var current_node = "start"
var player_in_range = false
var dialogue_visible = false
var dialogue_tree = {
	"start": {
		"text": "A chest. Looks valuable",
		"choices": [
			{"text": "Hit it", "next": "hit_it"},
			{"text": "Yell at it", "next": "yell_at_it"}
		]
	},
	"hit_it": {
		"text": "Someone was in there",
		"choices": []
	},
	"yell_at_it": {
		"text": "Hey do you mind?!",
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
		print ("Player in range of NPC. Press [E]")

# Detect if player exits interaction range
func _on_Area2D_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		hide_dialogue()
		print("Player left the range of NPC")

# Toggle dialogue with interaction
func _process(delta):
	if player_in_range and Input.is_action_just_pressed("ui_interact"):
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
	if current_node == "hit_it":
		apply_emotion()  # Set emotion and remove item after interaction
	elif current_node == "yell_at_it":
		hide_dialogue()  # Hide dialogue if player chooses to leave
	else:
		show_dialogue()

# Apply emotion effect to player and remove item
func apply_emotion():
	var player = get_tree().get_nodes_in_group("player")[0]
	player.set_emotion(emotion_effect)
	hide_dialogue()
	queue_free()  # Remove the item after interaction
