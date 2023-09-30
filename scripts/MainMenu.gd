class_name MainMenu

extends CanvasLayer

var level_count := GameData.levels.size()

const level_button_scn := preload("res://assests/LevelButton.tscn")

@export var level_selection: GridContainer
@export var level_container: PanelContainer
@export var play_button: Button


func _ready() -> void:
	for child in level_selection.get_children():
		child.queue_free()

	for i in range(level_count):
		var button: Button = level_button_scn.instantiate()
		button.text = "LEVEL " + str(i + 1)
		button.pressed.connect(load_level.bind(i))
		level_selection.add_child(button)

	play_button.pressed.connect(_on_play_pressed)


func load_level(level_number: int) -> void:
	GameData.current_level = level_number
	get_tree().change_scene_to_file("res://GameWorld.tscn")


func _on_play_pressed() -> void:
	level_container.show()
