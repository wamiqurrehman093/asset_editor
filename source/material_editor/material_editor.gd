class_name MaterialEditor extends HBoxContainer


@export var material_title: Label
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


func _ready() -> void:
	preview_material = preview_sphere.material_override
	console_button.pressed.connect(console_window.popup)


func load_material(material_info: Dictionary):
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
	self.material_title.text = material_name
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
	self.defuse_texture.text = defuse_texture
	if FileAccess.file_exists(defuse_texture):
		preview_material.set("albedo_texture", load(defuse_texture))
		console_window.log_statement("Loaded defuse texture.")
	else:
		console_window.log_error("Error loading defuse texture:")
		console_window.log_error("-> Defuse texture file doesn't exist!")


func load_ambient_color(ambient_color: Dictionary) -> void:
	self.ambient_color_r.text = ambient_color.r
	self.ambient_color_g.text = ambient_color.g
	self.ambient_color_b.text = ambient_color.b
	console_window.log_statement("Loaded ambient color.")


func load_ambient_texture(ambient_texture: String) -> void:
	self.ambient_texture.text = ambient_texture
	if FileAccess.file_exists(ambient_texture):
		preview_material.set("ao_texture", load(ambient_texture))
		console_window.log_statement("Loaded ambient texture.")
	else:
		console_window.log_error("Error loading ambient texture:")
		console_window.log_error("-> Ambient texture file doesn't exist!")


func load_specular_color(specular_color: Dictionary) -> void:
	self.specular_color_r.text = specular_color.r
	self.specular_color_g.text = specular_color.g
	self.specular_color_b.text = specular_color.b


func load_specular_amount(specular_amount: String) -> void:
	self.specular_amount.text = specular_amount


func load_emission_color(emission_color: Dictionary) -> void:
	self.emission_color_r.text = emission_color.r
	self.emission_color_g.text = emission_color.g
	self.emission_color_b.text = emission_color.b


func load_refraction_density(refraction_density: String) -> void:
	self.refraction_density.text = refraction_density


func load_opacity(opacity: String) -> void:
	self.opacity.text = opacity


func load_illumination(illumination: String) -> void:
	self.illumination.text = illumination
