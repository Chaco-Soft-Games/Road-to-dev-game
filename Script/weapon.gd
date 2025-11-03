extends Node2D
class_name Gun

@onready var anim = $AnimationPlayer
@onready var attack_area = $AttackArea

@export var weapon_type = "sword"

func _ready():
	anim.play("Idle")

func shoot():
	if anim.is_playing():
		anim.stop()
	anim.play("Attack")

	# Aplicar daño al atacar
	apply_damage_to_enemies()

	await anim.animation_finished
	anim.play("Idle")

func apply_damage_to_enemies():
	# Usando el Area2D para detectar enemigos
	for body in attack_area.get_overlapping_bodies():
		if body.has_method("take_damage"):
			body.take_damage(Global.weapon_damage[weapon_type])
			print(" Enemigo recibió ", Global.weapon_damage[weapon_type], " de daño")
