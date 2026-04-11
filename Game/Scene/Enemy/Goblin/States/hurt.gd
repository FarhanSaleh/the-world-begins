extends GoblinState

func enter(_previous_state_path: String, _data := {}) -> void:
	goblin.animation_player.play("Hurt")
	# Knockback sudah diberikan di fungsi apply_knockback sebelum pindah ke sini
func exit() -> void:
	goblin.sprite_2d.self_modulate = Color(1, 1, 1)

func physics_update(_delta: float) -> void:
	# Tetap berikan gravitasi agar dia jatuh setelah terpental
	goblin.velocity.y += goblin.GRAVITY * _delta
	
	# Berikan friction yang lebih sedikit agar pentalan terasa jauh
	goblin.velocity.x = move_toward(goblin.velocity.x, 0, goblin.FRICTION * _delta)
	
	goblin.move_and_slide()
	
	# Kembali ke Idle jika sudah berhenti dan di lantai
	if goblin.is_on_floor() and is_equal_approx(goblin.velocity.x, 0):
		emit_finished(IDLE, {})
