extends PlayerState

var can_jump: bool = false

func enter(previous_state_path: String, _data := {}) -> void:
	player.animation_player.play("Fall")
	can_jump = false
	if previous_state_path != JUMPING and previous_state_path != ATTACK_JUMP:
		player.coyote_timer.start()
		can_jump = true
		if not player.coyote_timer.timeout.is_connected(on_coyote_timeout):
			player.coyote_timer.timeout.connect(on_coyote_timeout)

func exit() -> void:
	if player.coyote_timer.timeout.is_connected(on_coyote_timeout):
		player.coyote_timer.timeout.disconnect(on_coyote_timeout)
	player.coyote_timer.stop()

func physics_update(delta: float) -> void:
	var input_direction_x := Input.get_axis("Left", "Right")
	if input_direction_x != 0:
		player.flip_body(input_direction_x < 0)
		player.velocity.x = move_toward(player.velocity.x, input_direction_x * player.speed, delta * player.ACCELERATION)
	
	player.velocity.y += player.gravity * delta
	player.move_and_slide()
	
	check_state_transition(input_direction_x)

func on_coyote_timeout() -> void:
	can_jump = false
	
func check_state_transition(dir: float) -> void:
	if Input.is_action_just_pressed("Attack") and player.can_air_attack:
		emit_finished(ATTACK_JUMP, {})
		return 
	
	if can_jump and Input.is_action_just_pressed("Jump"):
		emit_finished(JUMPING, {})
		return
		
	if player.is_on_floor():
		if is_equal_approx(dir, 0.0):
			emit_finished(IDLE, {})
		else:
			emit_finished(RUNNING, {})
		return
