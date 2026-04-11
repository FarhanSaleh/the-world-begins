extends GoblinState

func enter(_previous_state_path: String, _data := {}) -> void:
	goblin.speed = goblin.PATROL_SPEED
	goblin.animation_player.play("Walk")
	
	var rand_flip: float = [false, true].pick_random()
	goblin.flip_body(rand_flip)
	
	var wait_time: float = randf_range(1.0, 3.0)
	goblin.wait_timer.start(wait_time)
	if not goblin.wait_timer.timeout.is_connected(on_wait_timer_timeout):
		goblin.wait_timer.timeout.connect(on_wait_timer_timeout)
	
func exit() -> void:
	if goblin.wait_timer.timeout.is_connected(on_wait_timer_timeout):
		goblin.wait_timer.timeout.disconnect(on_wait_timer_timeout)
	
func physics_update(_delta: float) -> void:
	goblin.velocity.y += goblin.GRAVITY * _delta
	goblin.velocity.x = move_toward(goblin.velocity.x, goblin.speed * goblin.direction, _delta * goblin.FRICTION)
	if goblin.wall_detector.is_colliding():
		goblin.flip_body(!goblin.sprite_2d.flip_h)
		
	goblin.move_and_slide()
	check_state_transition()
	
func check_state_transition() -> void:
	pass

func on_wait_timer_timeout() -> void:
	emit_finished(IDLE, {})
