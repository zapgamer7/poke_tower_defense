extends Node2D

var walk_speed = 4.0
const TILE_SIZE = 16
var initial_position = Vector2(0,0)
var input_direction = Vector2(0,0)
var is_moving = false
var percent_move_to_next_tile = 0.0
var input_up_blocked : bool = false
var input_down_blocked : bool = false
var input_left_blocked : bool = false
var input_right_blocked : bool = false

@onready var animation = $AnimatedSprite2D

func _ready() -> void:
	initial_position = position

func _physics_process(delta: float) -> void:
	if input_direction != Vector2.ZERO:
		move(delta)
	else:
		is_moving = false
		
	if not is_moving:
		process_player_input()

func process_player_input():
	if input_direction.y == 0:
		input_direction.x = Input.get_axis("ui_left", "ui_right")

		if input_left_blocked and input_direction.x == -1:
			input_direction.x = 0
		if input_right_blocked and input_direction.x == 1:
			input_direction.x = 0

		if input_direction.x == 1:
			animation.flip_h = false
			animation.play("walk_side")
		elif input_direction.x == -1:
			animation.flip_h = true
			animation.play("walk_side")
		else:
			animation.stop()

	if input_direction.x == 0:
		input_direction.y = Input.get_axis("ui_up", "ui_down")

		if input_up_blocked and input_direction.y == -1:
			input_direction.y = 0
		if input_down_blocked and input_direction.y == 1:
			input_direction.y = 0

		if input_direction.y == 1:
			animation.play("walk_down")
		elif input_direction.y == -1:
			animation.play("walk_up")

	if input_direction != Vector2.ZERO:
		initial_position = position
		is_moving = true


func move(delta):
	percent_move_to_next_tile += walk_speed * delta
	if percent_move_to_next_tile >= 1.0:
		position = initial_position + (TILE_SIZE * input_direction)
		percent_move_to_next_tile = 0.0
		is_moving = false
	else:
		position = initial_position + (TILE_SIZE * input_direction * percent_move_to_next_tile)


func _on_area_2d_up_body_entered(body: Node2D) -> void:
	input_up_blocked = true



func _on_area_2d_up_body_exited(body: Node2D) -> void:
	input_up_blocked = false

func _on_area_2d_down_body_entered(body: Node2D) -> void:
	input_down_blocked = true


func _on_area_2d_down_body_exited(body: Node2D) -> void:
	input_down_blocked = false


func _on_area_2d_left_body_entered(body: Node2D) -> void:
	input_left_blocked = true


func _on_area_2d_left_body_exited(body: Node2D) -> void:
	input_left_blocked = false


func _on_area_2d_right_body_entered(body: Node2D) -> void:
	input_right_blocked = true


func _on_area_2d_right_body_exited(body: Node2D) -> void:
	input_right_blocked = false
