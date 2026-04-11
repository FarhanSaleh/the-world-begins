class_name PlayerState extends State

const IDLE: String = "Idle"
const RUNNING: String = "Running"
const JUMPING: String = "Jumping"
const FALLING: String = "Falling"
const WALKING: String = "Walking"
const ATTACK1: String = "Attack1"
const ATTACK2: String = "Attack2"
const ATTACK3: String = "Attack3"
const ATTACK_JUMP: String = "AttackJump"
const ROLL: String = "Roll"

var player: Player
var previous_state: String = IDLE

func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(player != null, "The PlayerState state type must be used only in the player scene. It needs the owner to be a Player node.")
