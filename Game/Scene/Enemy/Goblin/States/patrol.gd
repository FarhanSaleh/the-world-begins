extends GoblinState

func enter(_previous_state_path: String, _data := {}) -> void:
	goblin.speed = goblin.PATROL_SPEED
	goblin.animation_player.play("Walk")
	
	var target = goblin.get_player_in_chase_area()
	if target:
		emit_finished(CHASE, {"target": target})
	
	var rand_flip: float = [false, true].pick_random()
	goblin.flip_body(rand_flip)
	
	var wait_time: float = randf_range(1.0, 3.0)
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
	goblin.velocity.x = move_toward(goblin.velocity.x, goblin.speed * goblin.direction, _delta * goblin.FRICTION)
	if goblin.wall_detector.is_colliding():
		goblin.flip_body(!goblin.sprite_2d.flip_h)
		
	goblin.move_and_slide()
	
func on_wait_timer_timeout() -> void:
	emit_finished(IDLE, {})

func on_chase_area_body_entered(body: Node2D) -> void:
	if body is Player:
		emit_finished(CHASE, {"target": body})
