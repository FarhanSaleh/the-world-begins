class_name Enemy
extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var attack_area: Area2D = $AttackArea
@onready var state_machine: StateMachine = $StateMachine

func apply_knockback(source_position: Vector2, strength: float):
	var push_direction = (global_position - source_position).normalized()
	push_direction.y += -0.5
	velocity = push_direction * strength
	state_machine._transition_to_next_state(GoblinState.HURT)
