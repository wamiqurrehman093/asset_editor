class_name MtlEditor extends Control


@export var path_line_edit: LineEdit
@export var browse_button: Button
@export var load_button: Button
@export var file_dialog: FileDialog
@export var back_button: Button


func _ready() -> void:
	browse_button.pressed.connect(file_dialog.popup)
	load_button.pressed.connect(_on_load_button_pressed)
	file_dialog.file_selected.connect(path_line_edit.set_text)
	back_button.pressed.connect(get_tree().change_scene_to_file.bind("res://source/main/main.tscn"))


func _on_load_button_pressed() -> void:
	if path_line_edit.text.is_absolute_path() or path_line_edit.text.is_relative_path():
		var content: String = get_file_content(path_line_edit.text)
		var content_lines: PackedStringArray = content.split("\n")
		for content_line: String in content_lines:
			if content_line.is_empty() or content_line.begins_with("#"):
				continue
			print(content_line)


func get_file_content(file_path: String) -> String:
	var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
	return file.get_as_text()
