extends Node


func get_directory_from_file_path(path: String) -> String:
	var path_list = path.split("/")
	var path_without_file_name = path.replace(path_list[-1], "")
	return path_without_file_name
