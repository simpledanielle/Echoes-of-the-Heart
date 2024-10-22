extends StaticBody2D

var current_node = "start"
var player_in_range = false
var dialogue_visible = false
var dialogue_tree = {
	"start": {
		"text": "Hello! Do you need directions?",
		"choices": [
			{"text": "Nah get lost", "next": "nah_get_lost"},
			{"text": "Yeah I need help", "next": "yeah_I_need_help"}
		]
	},
	"nah_get_lost": {
		"text": "Don't talk to me anymore",
		"choices": [
	]
},
"yeah_I_need_help": {
	"text": "Focus on your feelings",
	"choices": []
	}
}

@onready var dialogue_label = $"NPC Dialogue/Dialogue"
@onready var choice_container = $"NPC Dialogue/ChoiceContainer"

func _ready():
	dialogue_label.visible = false
	choice_container.visible = false


func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true
		print ("Player in range of NPC. Press [E]")


func _on_Area2D_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		hide_dialogue()
		print("Player left the range of NPC")
		
		
func _process(delta):
	if player_in_range and Input.is_action_just_pressed("ui_interact"):
		if dialogue_visible:
			hide_dialogue()
		else:
			show_dialogue()

func show_dialogue():
	var node = dialogue_tree[current_node]
	dialogue_label.text = node["text"]
	dialogue_label.visible = true
	choice_container.visible = true
	update_choices(node["choices"])
	dialogue_visible = true

func hide_dialogue():
	dialogue_label.visible = false
	choice_container.visible = false
	dialogue_visible = false

func update_choices(choices):
	for child in choice_container.get_children():
		choice_container.remove_child(child)
		child.queue_free()

	for choice in choices:
		var button = Button.new()
		button.text =choice["text"]
		button.connect("pressed", Callable(self, "_on_choice_selected").bind(choice["next"]))
		choice_container.add_child(button)

func _on_choice_selected(next_node):
	current_node = next_node
	if current_node == "goodbye":
		hide_dialogue()
	else:
		show_dialogue()
