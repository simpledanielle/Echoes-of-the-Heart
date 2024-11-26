extends Control

@onready var panel = $CanvasLayer
@onready var item_speaker = $CanvasLayer/Panel/itembox/itemSpeaker
@onready var item_text = $CanvasLayer/Panel/itembox/itemText
@onready var item_options = $CanvasLayer/Panel/itembox/itemOptions

func _ready():
	hide_dialog()

#show dialog box
func show_dialog(speaker, text, options):
	panel.visible = true

	#populate data
	item_speaker.text = speaker
	item_text.text = text
	
	#Remove existing options
	for option in item_options.get_children():
		item_options.remove_child(option)
		
	# Populate options
	for option in options.keys():
		var button = Button.new()
		button.text = option
		button.add_theme_font_size_override("font_size", 20)
		button.pressed.connect(_on_option_selected.bind(option))
		item_options.add_child(button)

# Handle response selection	
func _on_option_selected(option):
	get_parent().handle_dialog_choice(option)

# hide dialog box
func hide_dialog():
	panel.visible = false
	Global.player.can_move = true


#close dialog
func _on_close_button_pressed():
	hide_dialog()
