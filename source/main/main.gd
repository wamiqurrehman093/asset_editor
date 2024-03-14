class_name Main extends Control


@export var mtl_editor_button: Button
@export var quit_button: Button


func _ready() -> void:
	mtl_editor_button.pressed.connect(get_tree().change_scene_to_file.bind("res://source/mtl_editor/mtl_editor.tscn"))
	quit_button.pressed.connect(get_tree().quit)
