class_name Barrel
extends CharacterBody2D


@export var health: int = 10
@export var explosion_damage: int = 15
@export var death_explosion: PackedScene

@onready var area_spy = $Area_Spy
@onready var area_explosion = $Area_Explosion
@onready var animation_barrel = $AnimationPlayer
@onready var sprite_2d = $Sprite2D
@onready var timer_explosion = $Timer_Explosion
@onready var timer_spy = $Timer_Spy
@onready var barrel_sprite = $Barrel_Sprite

func _ready():
	print("Barrel ready")
	area_explosion.connect("area_entered", Callable(self, "_on_area_explosion_area_entered"))
	print("timer ready")
	timer_explosion.connect("timeout", Callable(self, "_on_timer_timeout"))


func _on_area_spy_area_entered(area):
	print("Area entered:", area, "Group: ", area.get_groups())
	if area.is_in_group("player"):
		print("Player detected in area spy!")
		timer_spy.start()
		animation_barrel.play("spy")
	var player_position = GameManager.player_position
	
	if player_position.x < position.x:
			barrel_sprite.flip_h = true  # Virar para a esquerda
	else:
			barrel_sprite.flip_h = false  # Virar para a direita

func _on_area_explosion_area_entered(area):
	print("Area entered:", area, "Group: ", area.get_groups())
	if area.is_in_group("player"):
		print("Player detected!")
		animation_barrel.play("explosion")
		timer_explosion.start()
		health = 0
	
	
func _on_timer_explosion_timeout():
	print("Temporizador expirou!")
	die_explosion()
	
	
func die_explosion():
# Play explosion animation
	animation_barrel.play("explosion")
	if death_explosion:
		var death_object = death_explosion.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
		
	var bodies = area_explosion.get_overlapping_bodies()
	for body in bodies:
			if body.is_in_group("player"):
				var player = body as Player
				player.damage(explosion_damage)
	
	queue_free()
