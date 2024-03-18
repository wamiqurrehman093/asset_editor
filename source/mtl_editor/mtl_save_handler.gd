extends Node


var mtl_editor: MtlEditor = null


func save_mtl_file() -> void:
	var file: FileAccess = FileAccess.open(mtl_editor.path_line_edit.text, FileAccess.WRITE)
	if file:
		var file_string: String = mtl_editor.get_materials_file_string()
		file.store_string(file_string)
		file.close()
		mtl_editor.update_preview()
	else:
		push_error("Error opening file: %s " % mtl_editor.path_line_edit.text)
