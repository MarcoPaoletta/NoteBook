extends Control
const UNTILTLED = "Untitled"
var app_name = "Note Book"
var current_file = UNTILTLED
var maximize = false

func _process(delta):
	if Input.is_key_pressed(KEY_ESCAPE) or Input.is_key_pressed(KEY_CONTROL) and Input.is_key_pressed(KEY_Q):
		get_tree().quit()
	if Input.is_key_pressed(KEY_F11):
		maximize = false
		OS.window_fullscreen = !OS.window_fullscreen
	if Input.is_key_pressed(KEY_CONTROL) and Input.is_key_pressed(KEY_S):
		save_file()
	if Input.is_key_pressed(KEY_CONTROL) and Input.is_key_pressed(KEY_SHIFT) and Input.is_key_pressed(KEY_S):
		$SaveFileDialog.popup()
	if Input.is_key_pressed(KEY_CONTROL) and Input.is_key_pressed(KEY_N):
		new_file()
	if Input.is_key_pressed(KEY_CONTROL) and Input.is_key_pressed(KEY_O):
		$FileDialog.popup()
		
		
func _ready():
	update_window_title()
	OS.center_window()
	# FILE BUT
	$MenuButtonFile.get_popup().add_item("New")
	$MenuButtonFile.get_popup().add_item("Open")
	$MenuButtonFile.get_popup().add_item("Save")
	$MenuButtonFile.get_popup().add_item("Save as")
	$MenuButtonFile.get_popup().add_item("Quit")
	$MenuButtonFile.get_popup().connect("id_pressed", self, "on_item_pressed")
	# ABOUT BUT
	$MenuButtonHelp.get_popup().add_item("GitHub")
	$MenuButtonHelp.get_popup().add_item("About")
	$MenuButtonHelp.get_popup().connect("id_pressed", self, "on_item_help_pressed")

func update_window_title():
	OS.set_window_title(app_name + " - " + current_file)

func new_file():
	current_file = UNTILTLED
	update_window_title()
	$TextEdit.text = ""
func on_item_pressed(id):
	var item_name = $MenuButtonFile.get_popup().get_item_text(id)
	if item_name == "Open":
		$FileDialog.popup()
	elif item_name == "Save":
		save_file()
	elif item_name == "Save as":
		$SaveFileDialog.popup()
	elif item_name == "Quit":
		get_tree().quit()
	elif item_name == "New":
		new_file()
		
func on_item_help_pressed(id):
	var item_name = $MenuButtonHelp.get_popup().get_item_text(id)
	if item_name == "About":
		$AboutDialog.popup()
	elif item_name == "GitHub":
		OS.shell_open("https://github.com/MarcoPaoletta")
	
func _on_OpenFile_pressed():
	$FileDialog.popup_centered()

func _on_SaveFile_pressed():
	$SaveFileDialog.popup_centered()
	
func _on_FileDialog_file_selected(path):
	var f = File.new()
	f.open(path, 1)
	$TextEdit.text = f.get_as_text()
	f.close()
	current_file = path
	update_window_title()

func _on_SaveFileDialog_file_selected(path):
	var f = File.new()
	f.open(path, 2)
	f.store_string($TextEdit.text)
	f.close()

func save_file():
	var path = current_file
	if path == UNTILTLED:
		$SaveFileDialog.popup()
	else:
		var f = File.new()
		f.open(path, 2)
		f.store_string($TextEdit.text)
		f.close()	

