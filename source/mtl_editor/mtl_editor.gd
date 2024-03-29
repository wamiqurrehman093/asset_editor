class_name MtlEditor extends Control


@export var path_line_edit: LineEdit
@export var browse_button: Button
@export var load_button: Button
@export var save_button: Button
@export var close_button: Button
@export var file_dialog: FileDialog
@export var back_button: Button
@export var materials_container: VBoxContainer


func _ready() -> void:
	MtlLoadHandler.mtl_editor = self
	MtlSaveHandler.mtl_editor = self
	MtlLoadHandler.load_from_cache()
	browse_button.pressed.connect(file_dialog.popup)
	load_button.pressed.connect(MtlLoadHandler.load_mtl_file)
	save_button.pressed.connect(MtlSaveHandler.save_mtl_file)
	close_button.pressed.connect(_on_close_button_pressed)
	file_dialog.file_selected.connect(path_line_edit.set_text)
	back_button.pressed.connect(get_tree().change_scene_to_file.bind("res://source/main/main.tscn"))


func _on_close_button_pressed() -> void:
	MtlLoadHandler.clear_previous_file()
	path_line_edit.text = ""
	close_button.disabled = true
	save_button.disabled = true


func get_materials_file_string() -> String:
	var materials_file_string: String = ""
	for material: MaterialEditor in materials_container.get_children():
		materials_file_string += material.get_file_string() + "\n"
	return materials_file_string


func update_preview() -> void:
	for material: MaterialEditor in materials_container.get_children():
		material.update_preview()
