class_name Player
extends CharacterBody2D

@export var speed: float = 3
@export var torch_damage: int = 6
@export var health: int = 80
@export var max_health: int = 80
@export var death_prefab: PackedScene

@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var torch_area = $TorchArea
@onready var health_progress_bar = $HealthProgressBar

var input_vector: Vector2
var is_running: bool = false
var was_running: bool = false
var is_attacking: bool = false
var attack_cooldown: float = 0.0

signal meat_collected(value: int)


func _ready():
	add_to_group("player")
	print("Player added to group 'player'")
	
	GameManager.player = self
	meat_collected.connect(func(value: int):
		GameManager.meat_counter += 1
	)


func _process(delta: float) -> void:
	# Posição do Player
	GameManager.player_position = position
	
	# Ler input
	read_input()

	# Processar ataque
	update_attack_cooldown(delta)
	if Input.is_action_just_pressed("attack"):
		attack()
	
	# Processar animação e rotação de sprite
	play_run_idle_animation()
	if not is_attacking:
		rotate_sprite()
		
	# Atualizar Health bar
	health_progress_bar.max_value = max_health
	health_progress_bar.value = health

func _physics_process(delta: float) -> void:
	# Modificar a velocidade
	var target_velocity = input_vector * speed * 100.0
	if is_attacking:
		target_velocity *= 0.25
	velocity = lerp(velocity, target_velocity, 0.1)
	move_and_slide()


func update_attack_cooldown(delta: float) -> void:
	# Atualizar temporizador do ataque
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0.0:
			is_attacking = false
			is_running = false
			animation_player.play("idle")


func read_input() -> void:
	# Obter o input vector
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Atualizar o is_running
	was_running = is_running
	is_running = not input_vector.is_zero_approx()


func play_run_idle_animation() -> void:
	# Tocar animação
	if not is_attacking:
		if was_running != is_running:
			if is_running:
				animation_player.play("run")
			else:
				animation_player.play("idle")


func rotate_sprite() -> void:
	# Girar sprite
	if input_vector.x > 0:
		sprite_2d.flip_h = false
	elif input_vector.x < 0:
		sprite_2d.flip_h = true


func attack() -> void:
	if is_attacking:
		return
	if input_vector.y > 0:
		animation_player.play("attack_down")
	elif input_vector.y < 0:
		animation_player.play("attack_up")
	else:
		animation_player.play("attack_side")
	
	
	# Configurar temporizador
	attack_cooldown = 0.6
	
	# Marcar ataque
	is_attacking = true


func deal_damage_to_enemies() -> void:
	var bodies = torch_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			
			var direction_to_enemy = (enemy.position - position).normalized()
			var attack_direction: Vector2

			# Detectando a direção do ataque
			if input_vector.y < 0:
				attack_direction = Vector2.UP
			elif input_vector.y > 0:
				attack_direction = Vector2.DOWN
			elif sprite_2d.flip_h:
				attack_direction = Vector2.LEFT
			else:
				attack_direction = Vector2.RIGHT
			
			var dot_product = direction_to_enemy.dot(attack_direction)

			# Verificando se o inimigo está na direção do ataque
			if attack_direction == Vector2.LEFT:
				if direction_to_enemy.x <= -0.7:
					enemy.damage(torch_damage)
			elif attack_direction == Vector2.RIGHT:
				if direction_to_enemy.x >= 0.7:
					enemy.damage(torch_damage)
			elif attack_direction == Vector2.UP:
				if direction_to_enemy.y <= -0.9:
					enemy.damage(torch_damage)
			elif attack_direction == Vector2.DOWN:
				if direction_to_enemy.y >= 0.9:
					enemy.damage(torch_damage)


func damage(amount: int) -> void:
	if health <= 0: return
	health -= amount
	print("Player recebeu dano de ", amount, ". A vida total é de ", health)

# Piscar node
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)

# Processar morte
	if health <= 0:
		die()
	

func die() -> void:
	GameManager.end_game()
	
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	
	queue_free()


func heal(amount: int) -> int:
	health += amount
	if health > max_health:
		health = max_health
	print("Player recebeu cura de ", amount, ". A vida total é de ", health, "/", max_health)
	return health
