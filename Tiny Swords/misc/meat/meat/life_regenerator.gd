extends Node2D

@export var regeneration_amount: int = 12

@onready var area_2d = $Area2D
@onready var meat = $"."


func _ready():
	area_2d.connect("body_entered", Callable(self, "_on_area_2d_body_entered"))


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		var player: Player = body
		player.heal(regeneration_amount)
		player.meat_collected.emit(regeneration_amount)
		queue_free()
