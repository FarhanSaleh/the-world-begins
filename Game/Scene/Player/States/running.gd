extends PlayerState

func enter(_previous_state_path: String, _data := {}) -> void:
	player.animation_player.play("Run")
	player.speed = player.RUN_SPEED

func physics_update(delta: float) -> void:
	player.velocity.y += player.gravity * delta
	
	var input_direction_x := Input.get_axis("Left", "Right")
	if input_direction_x != 0:
		player.flip_body(input_direction_x < 0)
		player.velocity.x = move_toward(player.velocity.x, input_direction_x * player.speed, delta * player.ACCELERATION)
	player.move_and_slide()
	
	check_state_transition(input_direction_x)

func check_state_transition(dir: float) -> void:
	if Input.is_action_pressed("Alt"):
		emit_finished(WALKING, {})
		return
	
	if Input.is_action_just_pressed("Dash"):
		emit_finished(ROLL, {})
		return
		
	if not player.is_on_floor():
		emit_finished(FALLING, {})
		return
		
	if Input.is_action_just_pressed("Jump"):
		emit_finished(JUMPING, {})
		return
		
	if is_equal_approx(dir, 0.0):
		emit_finished(IDLE, {})
		return
		
	if Input.is_action_just_pressed("Attack"):
		emit_finished(ATTACK1, {})
