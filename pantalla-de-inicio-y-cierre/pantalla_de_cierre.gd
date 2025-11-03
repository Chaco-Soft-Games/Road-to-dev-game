extends Control

@onready var anim_player: AnimationPlayer = $ColorRect/TextureRect/AnimationPlayer

func _ready() -> void:
	anim_player.play("exit_fade")

	anim_player.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "exit_fade":
		get_tree().quit()  # Cierra el juego
