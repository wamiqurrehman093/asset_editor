class_name ConsoleWindow extends Window


@export var command_input: LineEdit
@export var command_submit: Button
@export var logs: RichTextLabel


signal command_submitted


func _ready() -> void:
	close_requested.connect(hide)
	command_submit.pressed.connect(_on_command_submitted)
	command_input.text_submitted.connect(_on_command_submitted)


func log_statement(statement: String, color: String = "#66AA77", bold: bool = false) -> void:
	var formated_statement: String = "[color=%s]" % color + statement + "[/color]"
	formated_statement = "[b]" + formated_statement + "[/b]" if bold else formated_statement
	logs.text += formated_statement + "\n"


func log_error(error: String, color: String = "#AA7766") -> void:
	log_statement(error, color)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		hide()


func _on_command_submitted(command_text: String = "") -> void:
	if command_input.text.is_empty():
		return
	log_statement(command_input.text, "#666")
	command_submitted.emit(command_input.text)
	command_input.text = ""
