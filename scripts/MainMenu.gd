extends Node2D

var level_count := GameData.levels.size()
const level_button_scn := preload("res://assests/LevelButton.tscn")


func _ready() -> void:
	for child in $LevelSelection.get_children():
		child.queue_free()

	for i in range(level_count):
		var button: LevelButton = level_button_scn.instantiate()
		button.text = "LEVEL " + str(i + 1)
		$LevelSelection.add_child(button)
		button.pressed.connect(load_level.bind(i))


func load_level(level_number: int) -> void:
	var game_world: GameWorld = load("res://GameWorld.tscn").instantiate()
	game_world.set_game_level(level_number)

	var root = get_tree().root
	var menu := root.get_node("GameWorld")
	root.remove_child(menu)

	root.add_child(game_world)
