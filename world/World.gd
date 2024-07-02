extends Node3D


func _input(event):
	# Quit the game if you press esc
	if Input.is_action_just_pressed("ui_cancel"): 
		get_tree().quit()


