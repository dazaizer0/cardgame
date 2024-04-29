extends Node2D


@export var cam: Camera2D

@export var type: int 
# 1 - , 2 - , 3 - , 4 - 

@export var value: int
# 1...5

@export var id: int
@export var scale_: int

@onready var central = $"."
@onready var anim_manager = $AnimationPlayer
@onready var area = $Area2D
@onready var texture = $Sprite2D
@onready var back_texture = $Sprite2D/CardBack

var settled_pos = Vector2(0, 0)
var mouse_offset = Vector2(0, 0)
var start_pos = Vector2(0, 0)
var start_scale = Vector2(0, 0)
var check_card_pos = Vector2(0, 0)

var selected = false

var settled_down = false
var goind_back = false
var done = false
var player_temp = false
var going_back_from_checking = false
var check_shake = false

var start_rotation = 0

func _ready():
	start_pos = position
	start_rotation = rotation
	start_scale = scale
	check_card_pos = Vector2(position.x, position.y - 35)
	
	position = Vector2(position.x + 500, position.y)
	goind_back = true
	$select_sound.play()
	
	back_texture.visible = false

func _process(delta):
	if selected:
		texture.z_index = 1
	else:
		if settled_down or done:
			texture.z_index = -1
		if settled_down:
			texture.z_index = 0
		
		
	if position.distance_to(get_global_mouse_position()) < start_scale.x * 50 and !selected and !settled_down:
		if position != check_card_pos:
			global_transform.origin = lerp(global_transform.origin, check_card_pos, 10 * delta)
			if !check_shake:
				cam.apply_small_shake()
				check_shake = true
		else:
			check_shake = false
	else:
		going_back_from_checking = true
		check_shake = false
	
	if selected and !settled_down:
		followMouse()
		
	if Input.is_action_just_released("left_mouse"):
		goind_back = true
		selected = false
	
	if goind_back and !settled_down  and !selected:
		global_transform.origin = lerp(global_transform.origin, start_pos, 6 * delta)
		rotation = lerp(rotation, start_rotation, 12 * delta)
		if position == start_pos:
			goind_back = false
	
	if going_back_from_checking and !settled_down and !selected:
		global_transform.origin = lerp(global_transform.origin, start_pos, 6 * delta)
		rotation = lerp(rotation, start_rotation, 12 * delta)
		if position == start_pos:
			going_back_from_checking = false
	
	if settled_down and !done:
		central.position = settled_pos
		scale = Vector2(start_scale.x + (start_scale.x / scale_), start_scale.y + (start_scale.y / scale_))
		done = true
	
	if done or selected:
		rotation = lerp(rotation, 0.0, 10 * delta)
	else:
		rotation = start_rotation
		
	if done and !player_temp:
		anim_manager.play("put_card")
		$put_sound.play()
		cam.apply_shake()
		player_temp = true
	elif !done:
		player_temp = false


func followMouse():
	position = get_global_mouse_position() + mouse_offset

func setSlotPosition(pos: Vector2):
	settled_down = true
	settled_pos = pos

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			mouse_offset = position - get_global_mouse_position()
			selected = true
		else:
			selected = false
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.pressed:
			if done:
				$back_sound.play()
			mouse_offset = 0
			scale = start_scale
			goind_back = true
			settled_down = false
			selected = false
			done = false
		else:
			pass
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_MIDDLE:
		if event.pressed:
			back_texture.visible = !back_texture.visible

