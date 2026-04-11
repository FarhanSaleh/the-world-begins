class_name Goblin
extends Enemy

const GRAVITY: float = 980.0
const FRICTION: float = 500.0
const PATROL_SPEED: float = 20.0
const CHASE_SPEED: float = 60.0

@onready var edge_detector: RayCast2D = $EdgeDetector
@onready var wall_detector: RayCast2D = $WallDetector
@onready var wait_timer: Timer = $WaitTimer

var speed: float = PATROL_SPEED
var direction: float = 1.0

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	velocity.y = min(velocity.y, GRAVITY)

func flip_body(flip: bool) -> void:
	sprite_2d.flip_h = flip
	direction = -1.0 if flip else 1.0
	edge_detector.position.x = -4.0 if flip else 4.0
	wall_detector.target_position.x = -8.0 if flip else 8.0
	attack_area.scale.x = -1 if flip else 1
