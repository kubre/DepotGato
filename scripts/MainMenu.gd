class_name MainMenu

extends CanvasLayer

var level_count := GameData.levels.size()

const level_button_scn := preload("res://assests/LevelButton.tscn")

@export var level_selection: GridContainer
@export var level_container: PanelContainer
@export var play_button: Button
@export var max_score_label: Label


func _ready() -> void:
	create_level_buttons()
	load_ui_elements()


func create_level_buttons() -> void:
	# Clear any existing buttons
	for child in level_selection.get_children():
		child.queue_free()

	# Add buttons for each level
	for i in range(level_count):
		var button: Button = level_button_scn.instantiate()
		button.text = "LEVEL " + str(i + 1)
		button.disabled = i > GameData.unlocked_level
		button.pressed.connect(load_level.bind(i))
		level_selection.add_child(button)


func load_ui_elements() -> void:
	max_score_label.text = "MAX SCORE: " + str(GameData.max_score)
	play_button.pressed.connect(_on_play_pressed)


func load_level(level_number: int) -> void:
	GameData.current_level = level_number
	get_tree().change_scene_to_file("res://GameWorld.tscn")


func _on_play_pressed() -> void:
	level_container.show()


func _on_infinite_mode_button_pressed() -> void:
	load_level(GameData.INFINITE_LEVEL)
