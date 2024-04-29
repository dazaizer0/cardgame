extends Area2D


@onready var card = $".."
var id: int

func _ready():
	id = card.id
	print(id)

func setSlotPosition(pos: Vector2):
	card.setSlotPosition(pos)
