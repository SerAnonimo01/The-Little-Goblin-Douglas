class_name Enemy
extends Node2D

@export var health: int = 20
@export var death_prefab: PackedScene
@export var attack_damage: int = 7
@export var attack_cooldown_time: float = 1.0  # Tempo de cooldown entre ataques
@export var drop_chance: float = 0.1
@export var drop_items: Array[PackedScene]
@export var drop_chances: Array[float]

@onready var attack_area = $AttackArea
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var damage_digit_marker = $DamageDigitMarker

var attack_cooldown: float = 0.0
var is_attacking = false
var enemy = Enemy
var damage_digit_prefab: PackedScene

func _ready():
	attack_area.connect("body_entered", Callable(self, "_on_attack_area_body_entered"))
	attack_area.connect("body_exited", Callable(self, "_on_attack_area_body_exited"))

	damage_digit_prefab = preload("res://UI/Damage/damage_digit.tscn")

func damage(amount: int) -> void:
	health -= amount
	print("Inimigo recebeu dano de ", amount, ". A vida total é de ", health)

	# Piscar node
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)

	# Criar DamageDigit
	var damage_digit = damage_digit_prefab.instantiate()
	damage_digit.value = amount
	if damage_digit_marker:
		damage_digit.global_position = damage_digit_marker.global_position
	else:
		damage_digit.global_position = global_position
	get_parent().add_child(damage_digit)

	# Processar morte
	if health <= 0:
		die()

func die() -> void:
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	
	# Drop
	if randf() <= drop_chance:
		drop_item()
	
	# Incrementar contador
	GameManager.monsters_defeated_counter += 1
		
	queue_free()
	
func drop_item() -> void:
	var drop = get_random_drop_item().instantiate()
	drop.position = position
	get_parent().add_child(drop)


func get_random_drop_item() -> PackedScene:
	# Listas com 1 item
	if drop_items.size() == 1:
		return drop_items[0]

	# Calcular chance máxima
	var max_chance: float = 0.0
	for drop_chance in drop_chances:
		max_chance += drop_chance
	
	# Jogar dado
	var random_value = randf() * max_chance
	
	# Girar a roleta
	var needle: float = 0.0
	for i in drop_items.size():
		var drop_item = drop_items[i]
		var drop_chance = drop_chances[i] if i < drop_chances.size() else 1
		if random_value <= drop_chance + needle:
			return drop_item
		needle += drop_chance
	
	return drop_items[0]
	
	
func _on_attack_area_body_entered(body):
	if body.is_in_group("player"):
		is_attacking = true

func _on_attack_area_body_exited(body):
	if body.is_in_group("player"):
		animated_sprite_2d.play("run")
		is_attacking = false

func _physics_process(delta):
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0.0:
			attack_cooldown = attack_cooldown_time
			_attack()
	

func _attack():
	for body in attack_area.get_overlapping_bodies():
		if body.is_in_group("player"):
			var player = body as Player
			player.damage(attack_damage)
			animated_sprite_2d.play("attack_side")
			break
