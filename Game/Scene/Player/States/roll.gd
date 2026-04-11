extends PlayerState

func enter(_previous_state_path: String, _data := {}) -> void:
	var dir = Input.get_axis("Left", "Right")
	
	if dir == 0:
		dir = -1 if player.sprite_2d.flip_h else 1
	
	player.velocity.x = dir * player.dash_speed
	player.animation_player.play("Roll")
	player.animation_player.animation_finished.connect(on_animation_finished, CONNECT_ONE_SHOT)

func exit() -> void:
	if player.animation_player.animation_finished.is_connected(on_animation_finished):
		player.animation_player.animation_finished.disconnect(on_animation_finished)

func physics_update(_delta: float) -> void:
	player.velocity.x = move_toward(player.velocity.x, 0, 1000 * _delta)
	player.velocity.y += player.gravity * _delta 
	player.move_and_slide()
	
func on_animation_finished(anim_name: String) -> void:
	if anim_name == "Roll":
		player.velocity.x = 0
		if player.is_on_floor():
			emit_finished(IDLE, {})
		else:
			emit_finished(FALLING, {})
	
