extends Node2D

@export var value: int = 0
@onready var label = %Label

func _ready():
	%Label.text = str(value)
