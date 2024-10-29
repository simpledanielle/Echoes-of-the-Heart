extends Node2D  # or whatever node type you are using for the door

# Predefined code to open the door
var unlock_code: String = "1234"  # Change this to your desired code
var entered_code: String = ""  # To store the player's input

# Scene to switch to when the door is unlocked
var next_scene_path: String = "res://Scenes/calmpuzzle.tscn"  # Change this to your desired scene path

# Reference to the Label that displays the entered code
@onready var code_display: Label = $TileMapLayer/Codedisplay  # Adjust the path if needed

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Door is ready. Enter the code to unlock.")
	code_display.text = ""  # Clear the display when the game starts

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Check for input every frame
	if Input.is_action_just_pressed("ui_accept"):  # Assuming you use Enter key to confirm input
		check_code()  # Check the entered code

# Function to handle number input
func _input(event: InputEvent):
	if event is InputEventKey and event.is_pressed():
		# Handle number keys (0-9)
		match event.keycode:
			KEY_0:
				add_number_to_code("0")
			KEY_1:
				add_number_to_code("1")
			KEY_2:
				add_number_to_code("2")
			KEY_3:
				add_number_to_code("3")
			KEY_4:
				add_number_to_code("4")
			KEY_5:
				add_number_to_code("5")
			KEY_6:
				add_number_to_code("6")
			KEY_7:
				add_number_to_code("7")
			KEY_8:
				add_number_to_code("8")
			KEY_9:
				add_number_to_code("9")
			KEY_BACKSPACE:
				remove_last_digit()

# Function to add number to the entered code
func add_number_to_code(number: String):
	entered_code += number  # Append the number to the entered code
	print("Entered code:", entered_code)  # Print the current input for debugging
	code_display.text = entered_code  # Update the Label with the current input

# Function to remove the last digit from the entered code
func remove_last_digit():
	if entered_code.length() > 0:
		entered_code = entered_code.substr(0, entered_code.length() - 1)
		print("Current code after backspace:", entered_code)
		code_display.text = entered_code  # Update the Label after removal

# Function to check the entered code
func check_code():
	if entered_code == unlock_code:
		print("Door unlocked!")
		open_door()  # Call the function to open the door
	else:
		print("Incorrect code. Try again.")
	entered_code = ""  # Reset entered code after checking
	code_display.text = ""  # Clear the display after checking

# Function to open the door and change the scene
func open_door():
	# Change to the next scene when the door is unlocked
	get_tree().change_scene_to_file("res://Scenes/calmpuzzle.tscn")
