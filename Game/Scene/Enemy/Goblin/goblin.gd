class_name Goblin
extends Enemy

const GRAVITY: float = 980.0
const FRICTION: float = 500.0
const PATROL_SPEED: float = 20.0
const CHASE_SPEED: float = 50.0

@onready var edge_detector: RayCast2D = $EdgeDetector
@onready var wall_detector: RayCast2D = $WallDetector
@onready var wait_timer: Timer = $WaitTimer
@onready var state_machine: StateMachine = $StateMachine
@onready var chase_area: Area2D = $ChaseArea
@onready var attack_trigger_area: Area2D = $AttackTriggerArea
@onready var state_label: Label = $StateLabel

var speed: float = PATROL_SPEED
var direction: float = 1.0
var health_point: float = 40.0

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	state_label.text = state_machine.state.name

func _physics_process(_delta: float) -> void:
	velocity.y = min(velocity.y, GRAVITY)

func flip_body(flip: bool) -> void:
	sprite_2d.flip_h = flip
	direction = -1.0 if flip else 1.0
	edge_detector.position.x = -4.0 if flip else 4.0
	wall_detector.target_position.x = -8.0 if flip else 8.0
	attack_area.scale.x = -1.0 if flip else 1.0
	chase_area.scale.x = -1.0 if flip else 1.0
	attack_trigger_area.scale.x = -1.0 if flip else 1.0

func apply_knockback(source_position: Vector2, strength: float):
	super(source_position, strength)
	state_machine._transition_to_next_state(GoblinState.HURT)

func get_player_in_chase_area() -> Player:
	var bodies = chase_area.get_overlapping_bodies()
	for body in bodies:
		if body is Player:
			return body
	return null

func get_player_in_attack_trigger_area() -> Player:
	var bodies = attack_trigger_area.get_overlapping_bodies()
	for body in bodies:
		if body is Player:
			return body
	return null
