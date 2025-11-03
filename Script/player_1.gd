extends CharacterBody2D
class_name Player_1

@onready var anim = $AnimatedSprite2D
@onready var body = $AnimatedSprite2D
@onready var Weapon_Slot = $Weapon_Slot
@onready var Weapon = $Weapon_Slot/Weapon

# --- Movimiento ---
var is_run = false

# --- Dash (solo flags y lógica) ---
var is_dashing = false
var can_dash = true
var dash_direction = Vector2.ZERO
var dash_timer := Timer.new()

# --- Vida ---
var health = Global.player_max_health
var is_dead = false

# --- Ataque ---
var can_attack = true
var attack_timer := Timer.new()

func _ready():
	# Escalar arma
	if Weapon:
		Weapon.scale = Global.default_weapon_scale
	
	# Timer de ataque
	attack_timer.wait_time = Global.default_attack_cooldown
	attack_timer.one_shot = true
	add_child(attack_timer)
	attack_timer.connect("timeout", Callable(self, "_on_attack_cooldown_timeout"))

	# Timer de dash
	dash_timer.wait_time = Global.dash_time
	dash_timer.one_shot = true
	add_child(dash_timer)
	dash_timer.connect("timeout", Callable(self, "_on_dash_end"))

func _physics_process(_delta):
	if is_dead:
		return

	var direction = Input.get_vector("left", "right", "up", "down")

	if is_dashing:
		velocity = dash_direction * Global.dash_speed
	else:
		velocity = direction * Global.player_speed

	move_and_slide()
	changeAnim(direction)

	if direction.x != 0 and not is_dashing:
		body.scale.x = 1 if direction.x > 0 else -1

	if Weapon_Slot:
		var mouse_pos = get_global_mouse_position()
		Weapon_Slot.look_at(mouse_pos)
		Weapon_Slot.scale.y = -1 if mouse_pos.x < global_position.x else 1

func _input(event):
	if is_dead:
		return

	# Ataque
	if event.is_action_pressed("ATTACK") and Weapon and can_attack:
		can_attack = false
		Weapon.shoot()
		attack_timer.start()

	# Dash
	if event.is_action_pressed("DASH") and can_dash:
		start_dash()

func start_dash():
	is_dashing = true
	can_dash = false
	dash_direction = Input.get_vector("left", "right", "up", "down")
	if dash_direction == Vector2.ZERO:
		dash_direction = Vector2.RIGHT if body.scale.x > 0 else Vector2.LEFT
	dash_timer.start()

func _on_dash_end():
	is_dashing = false
	# Cooldown antes de permitir nuevo dash
	await get_tree().create_timer(Global.dash_cooldown).timeout
	can_dash = true

func changeAnim(direction):
	if is_dead:
		return

	if direction == Vector2.ZERO:
		if is_run:
			is_run = false
			anim.play("Idle")
	else:
		if not is_run:
			is_run = true
			anim.play("Run")

func _on_attack_cooldown_timeout():
	can_attack = true

# --- Recibir daño ---
func take_damage(amount: int):
	if is_dead:
		return

	health -= amount
	print("Jugador recibió daño: ", amount, " Vida restante: ", health)
	if health <= 0:
		die()

func die():
	is_dead = true
	anim.play("Death")
	$CollisionShape2D.disabled = true
	velocity = Vector2.ZERO
	anim.connect("animation_finished", Callable(self, "_on_death_animation_finished"))

func _on_death_animation_finished():
	queue_free()
