extends GoblinState

var target: Player = null

func enter(_previous_state_path: String, _data := {}) -> void:
	if _data.has("target"):
		target = _data["target"]
		
	goblin.animation_player.play("Run")
	goblin.speed = goblin.CHASE_SPEED
	
	if not goblin.chase_area.body_exited.is_connected(on_chase_area_body_exited):
		goblin.chase_area.body_exited.connect(on_chase_area_body_exited)
	if not goblin.attack_trigger_area.body_entered.is_connected(on_attack_trigger_area_entered):
		goblin.attack_trigger_area.body_entered.connect(on_attack_trigger_area_entered)
	
func exit() -> void:
	if goblin.chase_area.body_exited.is_connected(on_chase_area_body_exited):
		goblin.chase_area.body_exited.disconnect(on_chase_area_body_exited)
	if goblin.attack_trigger_area.body_entered.is_connected(on_attack_trigger_area_entered):
		goblin.attack_trigger_area.body_entered.disconnect(on_attack_trigger_area_entered)
		
func physics_update(_delta: float) -> void:
	if is_instance_valid(target):
		var current_player_pos: Vector2 = target.global_position
		var diff_x = current_player_pos.x - goblin.global_position.x
		var dir_x = sign(diff_x)
		goblin.flip_body(dir_x < 0)
		
		goblin.velocity.y += goblin.GRAVITY * _delta
		goblin.velocity.x = move_toward(goblin.velocity.x, goblin.direction * goblin.speed, _delta * goblin.FRICTION)
		goblin.move_and_slide()
		
	else:
		emit_finished(PATROL, {})
	
func on_chase_area_body_exited(_body: Node2D) -> void:
	emit_finished(IDLE, {})

func on_attack_trigger_area_entered(_body: Node2D) -> void:
	emit_finished(ATTACK1, {})
