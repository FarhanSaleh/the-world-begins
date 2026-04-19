class_name GoblinState
extends State

const IDLE: String = "Idle"
const PATROL: String = "Patrol"
const JUMPING: String = "Jumping"
const FALLING: String = "Falling"
const ATTACK1: String = "Attack1"
const HURT: String = "Hurt"
const DEAD: String = "Dead"
const CHASE: String = "Chase"

var goblin: Goblin
var previous_state: String = IDLE

func _ready() -> void:
	await owner.ready
	goblin = owner as Goblin
	assert(goblin != null, "The PlayerState state type must be used only in the player scene. It needs the owner to be a Player node.")
