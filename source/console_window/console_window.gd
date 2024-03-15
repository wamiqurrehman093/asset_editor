class_name ConsoleWindow extends Window


@export var logs: VBoxContainer
@export var command_input: LineEdit
@export var command_submit: Button


signal command_submitted


func _ready() -> void:
	close_requested.connect(hide)


func log_statement(statement: String, color: Color = Color.BLACK) -> void:
	var statement_log: Label = Label.new()
	statement_log.text = statement
	statement_log.set("theme_override_colors/font_color", color)
	logs.add_child(statement_log)


func log_error(error: String, color: Color = Color.RED) -> void:
	log_statement(error, color)
