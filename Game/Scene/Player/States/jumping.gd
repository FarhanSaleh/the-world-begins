extends PlayerState

func enter(_previous_state_path: String, _data := {}) -> void:
	player.coyote_timer.stop()
	player.velocity.y = -player.jump_impulse
	player.animation_player.play("Jump")

func physics_update(delta: float) -> void:
	var input_direction_x := Input.get_axis("Left", "Right")
	
	if input_direction_x != 0:
		player.flip_body(input_direction_x < 0)
		player.velocity.x = move_toward(player.velocity.x, input_direction_x * player.speed, delta * player.ACCELERATION)
	
	player.velocity.y += player.gravity * delta
	player.move_and_slide()

	check_state_transition()

func check_state_transition() -> void:
	if Input.is_action_just_pressed("Attack") and player.can_air_attack:
		emit_finished(ATTACK_JUMP, {})
		return 
		
	if player.velocity.y >= 0:
		emit_finished(FALLING, {})
		
