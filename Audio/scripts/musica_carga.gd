extends Node

@onready var musica_carga = $AudioStreamPlayer

func _ready():
	musica_carga.loop(true)
	musica_carga.play()
