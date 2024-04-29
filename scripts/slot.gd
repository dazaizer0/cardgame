extends Node2D


@onready var slot_area = $Area2D

func _process(delta):
	pass

func getCard(area: Area2D):
	area.setSlotPosition(position)
