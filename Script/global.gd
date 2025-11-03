extends Node

var player_max_health = 100
var player_speed = 150.0
var default_attack_cooldown = 0.5
var default_weapon_scale = Vector2(0.2, 0.2)

# Dash
var dash_speed = 400.0
var dash_time = 0.15
var dash_cooldown = 1.0

# Daños
var weapon_damage = {
	"sword": 25,
	"axe": 40,
	"dagger": 15
}
