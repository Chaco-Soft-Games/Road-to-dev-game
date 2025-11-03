extends CharacterBody2D
class_name Beetle

@onready var anim = $AnimatedSprite2D

# --- Configuración del enemigo ---
var speed: float = 40.0
var max_health: int = 300
var health: int = max_health
var is_dead: bool = false

# --- Movimiento aleatorio ---
var direction = Vector2.ZERO
var move_time = 0.0
var idle_time = 0.0
var is_moving = false
var is_hurt = false  # Nuevo flag para saber si está reproduciendo Hurt

func _ready():
	randomize()
	_set_idle()

func _physics_process(delta):
	if is_dead or is_hurt:
		return

	if is_moving:
		var collision = move_and_collide(direction * speed * delta)
		if collision:
			_set_idle()
		move_time -= delta
		if move_time <= 0:
			_set_idle()
	else:
		idle_time -= delta
		if idle_time <= 0:
			_set_move()

func _set_move():
	is_moving = true
	move_time = randf_range(1.0, 3.0)
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	anim.play("Run")

	if direction.x != 0:
		anim.scale.x = -1 if direction.x > 0 else 1

func _set_idle():
	is_moving = false
	idle_time = randf_range(1.0, 2.0)
	direction = Vector2.ZERO
	anim.play("Idle")

# --- Sistema de vida y daño ---
func take_damage(amount: int):
	if is_dead:
		return

	health -= amount
	print("Beetle recibió daño:", amount, "| Vida restante:", health)

	if health <= 0:
		die()
	else:
		_play_hurt()

func _play_hurt():
	if is_hurt or is_dead:
		return

	is_hurt = true
	anim.play("Hurt")
	
	# Esperar a que termine Hurt y volver a animación correcta
	await anim.animation_finished
	is_hurt = false
	
	# Volver a Idle o Run según estado
	if is_moving:
		anim.play("Run")
	else:
		anim.play("Idle")

func die():
	is_dead = true
	direction = Vector2.ZERO
	anim.play("Death")
	await anim.animation_finished
	queue_free()
