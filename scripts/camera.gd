extends Camera2D

var max_strenght: float = 30.0
var time = 0.2

var rng = RandomNumberGenerator.new()

func apply_shake():
	$AnimationPlayer.play("shake")

func apply_small_shake():
	$AnimationPlayer.play("smol_shake")
