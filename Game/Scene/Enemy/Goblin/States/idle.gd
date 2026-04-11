extends GoblinState

func enter(_previous_state_path: String, _data := {}) -> void:
	goblin.animation_player.play("Idle")
	
	var wait_time: float = randf_range(1.0, 2.0)
	goblin.wait_timer.start(wait_time)
	if not goblin.wait_timer.timeout.is_connected(on_wait_timer_timeout):
		goblin.wait_timer.timeout.connect(on_wait_timer_timeout)

func exit() -> void:
	if goblin.wait_timer.timeout.is_connected(on_wait_timer_timeout):
		goblin.wait_timer.timeout.disconnect(on_wait_timer_timeout)

func physics_update(_delta: float) -> void:
	goblin.velocity.y += goblin.GRAVITY * _delta
	goblin.velocity.x = move_toward(goblin.velocity.x, 0, _delta * goblin.FRICTION)
	goblin.move_and_slide()
	
	check_state_transition()
	
func check_state_transition() -> void:
	pass

func on_wait_timer_timeout() -> void:
	emit_finished(PATROL, {})
