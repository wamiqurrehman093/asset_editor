class_name MaterialEditor extends HBoxContainer


@export var material_name_input: LineEdit
@export var defuse_color_r: LineEdit
@export var defuse_color_g: LineEdit
@export var defuse_color_b: LineEdit
@export var defuse_texture: LineEdit
@export var ambient_color_r: LineEdit
@export var ambient_color_g: LineEdit
@export var ambient_color_b: LineEdit
@export var ambient_texture: LineEdit
@export var specular_color_r: LineEdit
@export var specular_color_g: LineEdit
@export var specular_color_b: LineEdit
@export var specular_amount: LineEdit
@export var emission_color_r: LineEdit
@export var emission_color_g: LineEdit
@export var emission_color_b: LineEdit
@export var refraction_density: LineEdit
@export var opacity: LineEdit
@export var illumination: LineEdit
@export var preview_sphere: MeshInstance3D
@export var console_button: Button
@export var console_window: ConsoleWindow


var preview_material: StandardMaterial3D
var mtl_editor: MtlEditor


func _ready() -> void:
	preview_material = preview_sphere.material_override
	console_button.pressed.connect(console_window.popup)


func load_material(material_info: Dictionary):
	load_properties(material_info)
	update_preview()


func load_properties(material_info: Dictionary) -> void:
	set_material_name(material_info.name)
	load_defuse_color(material_info.defuse_color)
	load_defuse_texture(material_info.defuse_texture)
	load_ambient_color(material_info.ambient_color)
	load_ambient_texture(material_info.ambient_texture)
	load_specular_color(material_info.specular_color)
	load_specular_amount(material_info.specular_amount)
	load_emission_color(material_info.emission_color)
	load_refraction_density(material_info.refraction_density)
	load_opacity(material_info.opacity)
	load_illumination(material_info.illumination)


func set_material_name(material_name: String) -> void:
	self.material_name_input.text = material_name
	console_window.log_statement("Loading material [%s]." % material_name)


func load_defuse_color(defuse_color: Dictionary) -> void:
	self.defuse_color_r.text = defuse_color.r
	self.defuse_color_g.text = defuse_color.g
	self.defuse_color_b.text = defuse_color.b
	preview_material.set(
		"albedo_color",
		Color(float(defuse_color.r), float(defuse_color.g), float(defuse_color.b))
	)
	console_window.log_statement("Loaded defuse color.")


func load_defuse_texture(defuse_texture: String) -> void:
	if defuse_texture.is_empty():
		return
	self.defuse_texture.text = defuse_texture


func load_ambient_color(ambient_color: Dictionary) -> void:
	self.ambient_color_r.text = ambient_color.r
	self.ambient_color_g.text = ambient_color.g
	self.ambient_color_b.text = ambient_color.b
	console_window.log_statement("Loaded ambient color.")


func load_ambient_texture(ambient_texture: String) -> void:
	if ambient_texture.is_empty():
		return
	self.ambient_texture.text = ambient_texture
	var ambient_texture_path: String = FileHandling.get_directory_from_file_path(mtl_editor.path_line_edit.text) + "/" + ambient_texture
	if FileAccess.file_exists(ambient_texture_path):
		var image = Image.load_from_file(ambient_texture_path)
		var texture = ImageTexture.create_from_image(image)
		preview_material.set("ao_texture", texture)
		console_window.log_statement("Loaded ambient texture.")
	else:
		console_window.log_error("Error loading ambient texture:")
		console_window.log_error("-> Ambient texture file doesn't exist!")


func load_specular_color(specular_color: Dictionary) -> void:
	self.specular_color_r.text = specular_color.r
	self.specular_color_g.text = specular_color.g
	self.specular_color_b.text = specular_color.b
	console_window.log_statement("Loaded specular color.")


func load_specular_amount(specular_amount: String) -> void:
	self.specular_amount.text = specular_amount
	console_window.log_statement("Loaded specular amount.")


func load_emission_color(emission_color: Dictionary) -> void:
	self.emission_color_r.text = emission_color.r
	self.emission_color_g.text = emission_color.g
	self.emission_color_b.text = emission_color.b
	console_window.log_statement("Loaded emission color.")


func load_refraction_density(refraction_density: String) -> void:
	self.refraction_density.text = refraction_density
	console_window.log_statement("Loaded refraction density.")


func load_opacity(opacity: String) -> void:
	self.opacity.text = opacity
	console_window.log_statement("Loaded opacity.")


func load_illumination(illumination: String) -> void:
	self.illumination.text = illumination
	console_window.log_statement("Loaded illumination.")


func get_file_string() -> String:
	var file_string: String = ""
	file_string += get_material_name_file_string()
	file_string += get_defuse_color_file_string()
	file_string += get_defuse_texture_file_string()
	file_string += get_ambient_color_file_string()
	file_string += get_ambient_texture_file_string()
	file_string += get_specular_color_file_string()
	file_string += get_specular_amount_file_string()
	file_string += get_emission_color_file_string()
	file_string += get_refraction_density_file_string()
	file_string += get_opacity_file_string()
	file_string += get_illumination_file_string()
	return file_string


func get_material_name_file_string() -> String:
	if material_name_input.text.is_empty():
		material_name_input.text = "material"
	return "newmtl " + material_name_input.text + "\n"


func get_defuse_color_file_string() -> String:
	if defuse_color_r.text.is_empty(): defuse_color_r.text = "0"
	if defuse_color_g.text.is_empty(): defuse_color_g.text = "0"
	if defuse_color_b.text.is_empty(): defuse_color_b.text = "0"
	return "Kd " + defuse_color_r.text + " " + defuse_color_g.text + " " + defuse_color_b.text + "\n"


func get_defuse_texture_file_string() -> String:
	if defuse_texture.text.is_empty(): return ""
	return "map_Kd " + defuse_texture.text + "\n"


func get_ambient_color_file_string() -> String:
	if ambient_color_r.text.is_empty(): ambient_color_r.text = "0"
	if ambient_color_g.text.is_empty(): ambient_color_g.text = "0"
	if ambient_color_b.text.is_empty(): ambient_color_b.text = "0"
	return "Ka " + ambient_color_r.text + " " + ambient_color_g.text + " " + ambient_color_b.text + "\n"


func get_ambient_texture_file_string() -> String:
	if ambient_texture.text.is_empty(): return ""
	return "map_Ka " + ambient_texture.text + "\n"


func get_specular_color_file_string() -> String:
	if specular_color_r.text.is_empty(): specular_color_r.text = "0"
	if specular_color_g.text.is_empty(): specular_color_g.text = "0"
	if specular_color_b.text.is_empty(): specular_color_b.text = "0"
	return "Ks " + specular_color_r.text + " " + specular_color_g.text + " " + specular_color_b.text + "\n"


func get_specular_amount_file_string() -> String:
	if specular_amount.text.is_empty(): return ""
	return "Ns " + specular_amount.text + "\n"


func get_emission_color_file_string() -> String:
	if emission_color_r.text.is_empty(): emission_color_r.text = "0"
	if emission_color_g.text.is_empty(): emission_color_g.text = "0"
	if emission_color_b.text.is_empty(): emission_color_b.text = "0"
	return "Ke " + emission_color_r.text + " " + emission_color_g.text + " " + emission_color_b.text + "\n"


func get_refraction_density_file_string() -> String:
	if refraction_density.text.is_empty(): return ""
	return "Ni " + refraction_density.text + "\n"


func get_opacity_file_string() -> String:
	if opacity.text.is_empty(): return ""
	return "d " + opacity.text + "\n"


func get_illumination_file_string() -> String:
	if illumination.text.is_empty(): return ""
	return "illum " + illumination.text + "\n"


func update_preview() -> void:
	update_defuse_texture_preview()


func update_defuse_texture_preview() -> void:
	if defuse_texture.text.is_empty():
		return
	var defuse_texture_path: String = FileHandling.get_directory_from_file_path(
		mtl_editor.path_line_edit.text
	) + "/" + defuse_texture.text
	if FileAccess.file_exists(defuse_texture_path):
		var image = Image.load_from_file(defuse_texture_path)
		var texture = ImageTexture.create_from_image(image)
		preview_material.set("albedo_texture", texture)
		console_window.log_statement("Loaded defuse texture.")
	else:
		console_window.log_error("Error loading defuse texture:")
		console_window.log_error("-> Defuse texture file doesn't exist!")
		console_window.log_error("-> Defuse texture path = %s" % defuse_texture_path)
