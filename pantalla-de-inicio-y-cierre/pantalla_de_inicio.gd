extends Control

@onready var anim_player: AnimationPlayer = $ColorRect/TextureRect/AnimationPlayer

func _ready() -> void:
	anim_player.play("fade_in_out")
	# anim_player.animation_finished.connect(_on_animation_finished)

 #func _on_animation_finished(anim_name: String) -> void:
	# if anim_name == "fade_in_out":
		 #get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
