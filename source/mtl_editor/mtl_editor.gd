class_name MtlEditor extends Control


const MATERIAL_EDITOR = preload("res://source/material_editor/material_editor.tscn")


@export var path_line_edit: LineEdit
@export var browse_button: Button
@export var load_button: Button
@export var save_button: Button
@export var close_button: Button
@export var file_dialog: FileDialog
@export var back_button: Button
@export var materials_container: VBoxContainer


var material_info_template: Dictionary = {
	"name": "",
	"defuse_color": {
		"r": "",
		"g": "",
		"b": ""
	},
	"defuse_texture": "",
	"ambient_color": {
		"r": "",
		"g": "",
		"b": ""
	},
	"ambient_texture": "",
	"specular_color": {
		"r": "",
		"g": "",
		"b": ""
	},
	"specular_amount": "",
	"emission_color": {
		"r": "",
		"g": "",
		"b": ""
	},
	"refraction_density": "",
	"opacity": "",
	"illumination": ""
}
var material_info: Dictionary = {}


func _ready() -> void:
	browse_button.pressed.connect(file_dialog.popup)
	load_button.pressed.connect(_on_load_button_pressed)
	save_button.pressed.connect(_on_save_button_pressed)
	close_button.pressed.connect(_on_close_button_pressed)
	file_dialog.file_selected.connect(path_line_edit.set_text)
	back_button.pressed.connect(get_tree().change_scene_to_file.bind("res://source/main/main.tscn"))


func _on_load_button_pressed() -> void:
	if path_line_edit.text.is_absolute_path() or path_line_edit.text.is_relative_path():
		clear_previous_file()
		load_new_file()


func clear_previous_file() -> void:
	material_info = {}
	for material_editor: MaterialEditor in materials_container.get_children():
		material_editor.queue_free()


func load_new_file() -> void:
	for content_line: String in get_file_content_lines():
		if content_line.is_empty() or content_line.begins_with("#"):
			continue
		if content_line.begins_with("newmtl "):
			if materials_container.get_child_count() > 0:
				load_material_info_for_material_editor()
			create_new_material(content_line.split(" ")[1])
		load_content_line(content_line)
	if materials_container.get_child_count() > 0:
		load_material_info_for_material_editor()
		save_button.disabled = false
		close_button.disabled = false


func get_file_content_lines() -> PackedStringArray:
	var content: String = get_file_content(path_line_edit.text)
	var content_lines: PackedStringArray = content.split("\n")
	return content_lines


func get_file_content(file_path: String) -> String:
	var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
	return file.get_as_text()


func load_content_line(content_line: String) -> void:
	if content_line.begins_with("Kd "):
		set_defuse_color_in_material_info(content_line)
	if content_line.begins_with("map_Kd "):
		set_defuse_texture_in_material_info(content_line)
	if content_line.begins_with("Ka "):
		set_ambient_color_in_material_info(content_line)
	if content_line.begins_with("map_Ka "):
		set_ambient_texture_in_material_info(content_line)
	if content_line.begins_with("Ks "):
		set_specular_color_in_material_info(content_line)
	if content_line.begins_with("Ns "):
		set_specular_amount_in_material_info(content_line)
	if content_line.begins_with("Ke "):
		set_emission_color_in_material_info(content_line)
	if content_line.begins_with("Ni "):
		set_refraction_density_in_material_info(content_line)
	if content_line.begins_with("d "):
		set_opacity_in_material_info(content_line)
	if content_line.begins_with("illum "):
		set_illumination_in_material_info(content_line)


func load_material_info_for_material_editor() -> void:
	materials_container.get_child(
		materials_container.get_child_count() - 1
	).load_material(material_info)


func create_new_material(material_name: String) -> void:
	create_new_material_editor()
	create_new_material_info(material_name)


func create_new_material_editor() -> void:
	materials_container.add_child(MATERIAL_EDITOR.instantiate())


func create_new_material_info(material_name: String) -> void:
	material_info = material_info_template.duplicate(true)
	material_info.name = material_name


func set_defuse_color_in_material_info(defuse_color_line: String) -> void:
	material_info.defuse_color.r = defuse_color_line.split(" ")[1]
	material_info.defuse_color.g = defuse_color_line.split(" ")[2]
	material_info.defuse_color.b = defuse_color_line.split(" ")[3]


func set_defuse_texture_in_material_info(defuse_texture_line: String) -> void:
	material_info.defuse_texture = defuse_texture_line.split("map_Kd ")[1]


func set_ambient_color_in_material_info(ambient_color_line: String) -> void:
	material_info.ambient_color.r = ambient_color_line.split(" ")[1]
	material_info.ambient_color.g = ambient_color_line.split(" ")[2]
	material_info.ambient_color.b = ambient_color_line.split(" ")[3]


func set_ambient_texture_in_material_info(ambient_texture_line: String) -> void:
	material_info.ambient_texture = ambient_texture_line.split("map_Ka ")[1]


func set_specular_color_in_material_info(specular_color_line: String) -> void:
	material_info.specular_color.r = specular_color_line.split(" ")[1]
	material_info.specular_color.g = specular_color_line.split(" ")[2]
	material_info.specular_color.b = specular_color_line.split(" ")[3]


func set_specular_amount_in_material_info(specular_amount_line: String) -> void:
	material_info.specular_amount = specular_amount_line.split(" ")[1]


func set_emission_color_in_material_info(emission_color_line: String) -> void:
	material_info.emission_color.r = emission_color_line.split(" ")[1]
	material_info.emission_color.g = emission_color_line.split(" ")[2]
	material_info.emission_color.b = emission_color_line.split(" ")[3]


func set_refraction_density_in_material_info(refraction_density_line: String) -> void:
	material_info.refraction_density = refraction_density_line.split(" ")[1]


func set_opacity_in_material_info(opacity_line: String) -> void:
	material_info.opacity = opacity_line.split(" ")[1]


func set_illumination_in_material_info(illumination_line: String) -> void:
	material_info.illumination = illumination_line.split(" ")[1]


func _on_save_button_pressed() -> void:
	pass


func _on_close_button_pressed() -> void:
	clear_previous_file()
	path_line_edit.text = ""
	close_button.disabled = true
	save_button.disabled = true
