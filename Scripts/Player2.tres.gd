extends CharacterBody2D

var speed = 100  # speed in pixels/sec


func _physics_process(_delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed

	move_and_slide()
	
	if Input.is_action_just_pressed("interact"):
		execute_interaction()

@export var all_interactions = []
@onready var interactLabel = $"Interaction Components/InteractLabel"


func _ready():
	update_interactions()

#Interaction Stuff

func _on_interaction_area_area_entered(area: Area2D) -> void:
	all_interactions. insert(0, area)
	update_interactions()

func _on_interaction_area_area_exited(area: Area2D) -> void:
	all_interactions.erase(area)
	update_interactions()


func update_interactions():
	if all_interactions:
		interactLabel.text = all_interactions[0].interact_label
	else:
		interactLabel.text = ""


func execute_interaction():
	if all_interactions:
		
		var cur_interaction = all_interactions[0]
		match cur_interaction.interact_type:
			"print_text" : print(cur_interaction.interact_value)




#Emotion Stuff
# In Player.gd or GameManager.gd
enum Emotion { CALM, ANGRY }  # Define emotions
var current_emotion = Emotion.CALM  # Default emotion
var player_in_range = false

# Function to change the current emotion
func set_emotion(new_emotion):
		current_emotion = new_emotion
		print ("Current emotion: ", current_emotion)  # Update UI
		
		#Update label
		var label = get_node("Camera2D/UI/EmotionLabel")
		match current_emotion:
			Emotion.CALM:
				label.text = "Calm"
			Emotion.ANGRY:
				label.text = "Angry"
		

# Example interaction to change emotions
func interact_with_item(item_type):
	if item_type == "angry_item":
		set_emotion(Emotion.ANGRY)
	elif item_type == "calm_item":
		set_emotion(Emotion.CALM)



# Check for key presses to simulate emotion change
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		set_emotion(Emotion.ANGRY)
	elif Input.is_action_just_pressed("ui_cancel"):
		set_emotion(Emotion.CALM)



func _on_area_2d_body_entered(body: Node2D) -> void:
	pass



func _on_area_2d_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
	
	
