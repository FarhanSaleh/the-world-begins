extends GoblinState

func enter(_previous_state_path: String, _data := {}) -> void:
	goblin.animation_player.play("Attack1")
	if not goblin.animation_player.animation_finished.is_connected(on_animation_finished):
		goblin.animation_player.animation_finished.connect(on_animation_finished)
	
func exit() -> void:
	if goblin.animation_player.animation_finished.is_connected(on_animation_finished):
		goblin.animation_player.animation_finished.disconnect(on_animation_finished)
	
func physics_update(_delta: float) -> void:
	goblin.velocity.x = move_toward(goblin.velocity.x, 0, _delta * goblin.FRICTION)
	goblin.velocity.y += goblin.GRAVITY * _delta
	
	goblin.move_and_slide()
	
func on_animation_finished(_anim_name: String) -> void:
	var target = goblin.get_player_in_chase_area()
	var attack_target = goblin.get_player_in_attack_trigger_area()
	
	if attack_target:
		emit_finished(ATTACK1, {})
	elif target:
		emit_finished(CHASE, {"target": target})
	else:
		emit_finished(IDLE, {})
