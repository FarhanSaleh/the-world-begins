class_name Player extends CharacterBody2D

const WALK_SPEED: float = 40.0
const RUN_SPEED: float = 80.0
const ACCELERATION: float = 500.0
const FRICTION: float = 500.0
const MAX_FALL_SPEED: float = 980.0

var speed: float = RUN_SPEED
var gravity: float = 980.0
var jump_impulse: float = 270.0
var dash_speed: float = 300.0
var can_air_attack: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var attack_area: Area2D = $AttackArea
@onready var coyote_timer: Timer = $CoyoteTimer

func _ready() -> void:
	attack_area.monitoring = false

func _physics_process(_delta: float) -> void:
	velocity.y = min(velocity.y, MAX_FALL_SPEED)
	if is_on_floor():
		can_air_attack = true

func flip_body(flip: bool) -> void:
	sprite_2d.flip_h = flip
	attack_area.scale.x = -1 if flip else 1

func trigger_hit_impact(duration: float):
	Engine.time_scale = 0.05
	await get_tree().create_timer(duration * 0.05).timeout
	Engine.time_scale = 1.0

func _on_attack_area_body_entered(body: Node2D) -> void:
	trigger_hit_impact(0.3)
	if body is Enemy:
		body.apply_knockback(global_position, 100.0)
	
