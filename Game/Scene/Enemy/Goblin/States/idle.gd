extends GoblinState

func enter(_previous_state_path: String, _data := {}) -> void:
	goblin.animation_player.play("Idle")
	
	var target = goblin.get_player_in_chase_area()
	if target:
		emit_finished(CHASE, {"target": target})
	
	var wait_time: float = randf_range(1.0, 2.0)
	goblin.wait_timer.start(wait_time)
	if not goblin.wait_timer.timeout.is_connected(on_wait_timer_timeout):
		goblin.wait_timer.timeout.connect(on_wait_timer_timeout)
		
	if not goblin.chase_area.body_entered.is_connected(on_chase_area_body_entered):
		goblin.chase_area.body_entered.connect(on_chase_area_body_entered)

func exit() -> void:
	if goblin.wait_timer.timeout.is_connected(on_wait_timer_timeout):
		goblin.wait_timer.timeout.disconnect(on_wait_timer_timeout)
		
	if goblin.chase_area.body_entered.is_connected(on_chase_area_body_entered):
		goblin.chase_area.body_entered.disconnect(on_chase_area_body_entered)

func physics_update(_delta: float) -> void:
	goblin.velocity.y += goblin.GRAVITY * _delta
	goblin.velocity.x = move_toward(goblin.velocity.x, 0, _delta * goblin.FRICTION)
	goblin.move_and_slide()
	
func on_wait_timer_timeout() -> void:
	emit_finished(PATROL, {})

func on_chase_area_body_entered(body: Node2D) -> void:
	if body is Player:
		emit_finished(CHASE, {"target": body})
