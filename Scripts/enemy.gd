extends CharacterBody2D


@export var health: int = 3
@export var max_health: int = 3
@onready var health_bar = $ProgressBar

@export var attack_damage: int = 1
@export var attack_interval: float = 1.5
@export var move_speed: float = 100
@export var detection_range: float = 200

var player_in_range = false
@onready var player =  get_parent().get_node(".")  # Adjust path as needed
@onready var attack_timer = Timer.new()



func _ready():
	health_bar.max_value = max_health 
	health_bar.value = health
	add_child(attack_timer)
	attack_timer.wait_time = attack_interval
	attack_timer.connect("timeout", Callable(self, "attack_player"))
	$Sprite2D/Area2D/CollisionShape2D.connect("body_entered", Callable(self, "_on_AttackRange_body_entered"))
	$Sprite2D/Area2D/CollisionShape2D.connect("body_exited", Callable(self, "_on_AttackRange_body_exited"))
	
func _process(delta):
	if player and global_transform.origin.distance_to(player.global_transform.origin) <= detection_range:
		# Calculate the direction vector to the player and normalize it for movement
		var direction = (player.global_transform.origin - global_transform.origin).normalized()
		global_position += direction * move_speed * delta  # Move toward the player

func _on_AttackRange_body_entered(body):
	if body.name == "Player":
		player_in_range = true
		attack_timer.start()

func _on_AttackRange_body_exited(body):
	if body.name == "Player":
		player_in_range = false
		attack_timer.stop()


func attack_player():
	# Check if the player reference is valid
	if player:
		# Check if the player has the 'take_damage' method
		if player.take_damage:
			player.take_damage(attack_damage)
			print("Enemy attacked player! Damage dealt:", attack_damage)
		else:
			print("Error: Player does not have 'take_damage' method.")
	else:
		print("Error: Player not found.")


func take_damage(amount: int):
	health -= amount
	health = clamp(health, 0, max_health)
	health_bar.value = health
	if health <= 0:
		die()

func die():
	queue_free()
