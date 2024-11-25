extends CharacterBody2D

var speed = 100  # speed in pixels/sec
@onready var ray_cast_2D = $RayCast2D
var can_move = true

func _ready():
	Global.player = self

func _physics_process(_delta):
	if can_move:
		var direction = Input.get_vector("left", "right", "up", "down")
		velocity = direction * speed

	move_and_slide()
	
	if Input.is_action_just_pressed("interact"):
		execute_interaction()
	
	if velocity != Vector2.ZERO:
		ray_cast_2D.target_position = velocity.normalized() * 50

@export var all_interactions = []
@onready var interactLabel = $"Interaction Components/InteractLabel"


func _input(event):
	if can_move:
		if event.is_action_pressed("ui_interact"):
			var target = ray_cast_2D.get_collider()
			if target != null:
				if target.is_in_group("NPC"):
					print("I'm talking to an NPC!")
					can_move = false
					target.start_dialog()
	
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
		add_emotion_points("angry", 5)
		print("5 points")
	elif item_type == "calm_item":
		set_emotion(Emotion.CALM)
		add_emotion_points("calm", 10)
		print("10 points")


# Check for key presses to simulate emotion change
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		set_emotion(Emotion.ANGRY)
	elif Input.is_action_just_pressed("ui_cancel"):
		set_emotion(Emotion.CALM)
	if Input.is_action_just_pressed("ui_attack"):
		attack()



func _on_area_2d_body_entered(body: Node2D) -> void:
	pass



func _on_area_2d_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
	
	

#health stuff
var health: int = 100
@onready var health_bar = $Control/healthbar


func take_damage(amount: int):
	health -= amount
	update_health_bar()
	if health <= 0:
		die()
		
		
func update_health_bar():
	if health_bar:
		health_bar.value = health

func die():
	queue_free()


#attack range

@export var attack_damage: int = 1
@onready var attack_range = $Attack/AttackRange
@onready var attack_shape: CollisionShape2D = attack_range.get_node("CollisionShape2D")

#Method to attack 

func attack():
	print("Attack button pressed.")
	if attack_shape:
		attack_shape.disabled = false
		await get_tree().create_timer(0.2).timeout
		attack_shape.disabled = true
		print("Attack range disabled")

func _on_AttackRange_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(attack_damage)
		print("Enemy hit! Health reduced.")



#Emotion Points


# Emotion point variables
var calm_points: int = 0
var angry_points: int = 0

# Function to add points to an emotion
func add_emotion_points(emotion: String, points: int) -> void:
	match emotion:
		"calm":
			calm_points += points
			print("Calm points:", calm_points)
		"angry":
			angry_points += points
			print("Angry points:", angry_points)

# Function to subtract points from an emotion
func subtract_emotion_points(emotion: String, points: int) -> void:
	match emotion:
		"calm":
			calm_points = max(0, calm_points - points)  # Ensure points don't go below 0
			print("Calm points:", calm_points)
		"angry":
			angry_points = max(0, angry_points - points)
			print("Angry points:", angry_points)


# Call this function when the player interacts with an item

func interact(item: Node) -> void:
	interact_with_item(item)
