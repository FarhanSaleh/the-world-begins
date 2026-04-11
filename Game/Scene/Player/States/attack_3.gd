extends PlayerState

func enter(_previous_state_path: String, _data := {}) -> void:
	player.velocity.x = 0.0
	player.animation_player.play("Attack3")
	if not player.animation_player.animation_finished.is_connected(on_animation_finished):
		player.animation_player.animation_finished.connect(on_animation_finished)

func exit() -> void:
	if player.animation_player.animation_finished.is_connected(on_animation_finished):
		player.animation_player.animation_finished.disconnect(on_animation_finished)
	player.attack_area.monitoring = false
	
func physics_update(_delta: float) -> void:
	player.velocity.y += player.gravity * _delta
	player.velocity.x = move_toward(player.velocity.x, 0, _delta * 2000)
	player.move_and_slide()
	check_state_transition()

func on_animation_finished(_anim_name: String) -> void:
	emit_finished(IDLE, {})

func check_state_transition() -> void:
	if Input.is_action_just_pressed("Dash"):
		emit_finished(ROLL, {})
		return
	
	if not player.is_on_floor():
		emit_finished(FALLING, {})
		return
	
func attack_acl() -> void:
	var dir: float = -1 if player.sprite_2d.flip_h else 1
	player.velocity.x = 150 * dir
