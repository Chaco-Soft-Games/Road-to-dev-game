extends CanvasLayer

@onready var anim = $AnimationPlayer
func _ready():
	layer = -1
	get_node("AnimationPlayer").play("Transicion_2")

func change_scene(path : String) -> void:
	layer = 1
	anim.play("Transicion_2")
	get_tree().change_scene_to_file(path)
	anim.play_backwards("Transicion_2")
	layer = -1
