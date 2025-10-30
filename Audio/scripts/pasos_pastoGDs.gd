extends Node

@onready var pasos_pasto: AudioStreamPlayer2D = $Pasos_Pasto

func _ready():
	pasos_pasto.play()
	
