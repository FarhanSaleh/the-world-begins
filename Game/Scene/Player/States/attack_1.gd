extends PlayerState

var next_combo = false

func enter(_previous_state_path: String, _data := {}) -> void:
	next_combo = false
	player.animation_player.play("Attack1")
	if not player.animation_player.animation_finished.is_connected(on_animation_finished):
		player.animation_player.animation_finished.connect(on_animation_finished)
	
func physics_update(_delta: float) -> void:
	player.velocity.x = move_toward(player.velocity.x, 0, _delta * player.FRICTION)
	player.velocity.y += player.gravity * _delta
	
	player.move_and_slide()
	check_state_transition()

func exit() -> void:
	if player.animation_player.animation_finished.is_connected(on_animation_finished):
		player.animation_player.animation_finished.disconnect(on_animation_finished)
	player.attack_area.monitoring = false

func on_animation_finished(_anim_name: String) -> void:
	if next_combo:
		emit_finished(ATTACK2, {})
		return
		
	emit_finished(IDLE, {})

func check_state_transition() -> void:
	if Input.is_action_just_pressed("Dash"):
		emit_finished(ROLL, {})
		return
		
	if Input.is_action_just_pressed("Attack"):
		next_combo = true
		return
		
	if not player.is_on_floor():
		emit_finished(FALLING, {})
		return
