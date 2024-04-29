extends Area2D

@onready var slot = $".."
var is_taken = false
var holded_card_id: int


func _on_area_entered(area):
	if area.is_in_group("card"):
		if is_taken == false:
			slot.getCard(area)
			is_taken = true
			holded_card_id = area.id
			# print("card |id|: ", holded_card_id, " occupied slot |state|: ", is_taken)

func _on_area_exited(area):
	if area.is_in_group("card"):
		if is_taken == true and area.id == holded_card_id:
			is_taken = false
			# print("card |id|: ", holded_card_id, " has left slot --> |area id|: ", area.id, " state: ", is_taken)
