extends PlayerState

func enter(_previous_state_path: String, _data := {}) -> void:
	player.can_air_attack = false
	player.velocity.y = 0.0
	player.animation_player.play("AttackJump")
	player.animation_player.animation_finished.connect(on_animation_finished)
	
func physics_update(_delta: float) -> void:
	player.velocity.x = move_toward(player.velocity.x, 0, _delta * 2000)
	
	player.move_and_slide()

func exit() -> void:
	if player.animation_player.animation_finished.is_connected(on_animation_finished):
		player.animation_player.animation_finished.disconnect(on_animation_finished)
	player.attack_area.monitoring = false

func on_animation_finished(_anim_name: String) -> void:
	emit_finished(FALLING, {})

func attack_acl() -> void:
	var dir: float = -1 if player.sprite_2d.flip_h else 1
	player.velocity.x = 200 * dir
