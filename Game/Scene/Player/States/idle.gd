extends PlayerState

func enter(_previous_state_path: String, _data := {}) -> void:
	player.animation_player.play("Idle")

func physics_update(delta: float) -> void:
	player.velocity.y += player.gravity * delta
	player.velocity.x = move_toward(player.velocity.x, 0, delta * player.FRICTION)
	player.move_and_slide()
	
	check_state_transition()
	
func check_state_transition() -> void:
	if not player.is_on_floor():
		emit_finished(FALLING, {})
		return
		
	if Input.is_action_just_pressed("Attack"):
		emit_finished(ATTACK1, {})
		return
		
	if Input.is_action_just_pressed("Jump"):
		emit_finished(JUMPING, {})
		return
		
	if Input.get_axis("Left", "Right") != 0:
		emit_finished(RUNNING, {})
		
