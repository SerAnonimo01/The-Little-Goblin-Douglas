# Códigos dos Enemies 💀
Existem dois tipos de inimigos, o Enemy e o Barrel, a diferença entre os dois é que o Enemy usa o Follow Player, e o Barrel não.


## Enemy 🕸️
```
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
```

> **Objetivo principal**: Definir propriedades e variáveis para o inimigo, como saúde, dano de ataque e itens que podem ser dropados.

- `@export var`: Declara variáveis exportadas que podem ser ajustadas no editor Godot.
- `@onready var`: Inicializa variáveis quando o nó está pronto e os nós filhos já foram carregados.
- `var`: Declara variáveis internas para uso no script.

---

```
func _ready():
	attack_area.connect("body_entered", Callable(self, "_on_attack_area_body_entered"))
	attack_area.connect("body_exited", Callable(self, "_on_attack_area_body_exited"))

	damage_digit_prefab = preload("res://UI/Damage/damage_digit.tscn")
```

> **Objetivo principal**: Configurar conexões de sinal e pré-carregar o prefab de dígito de dano.

- `_ready()`: Função chamada quando o nó está pronto e adicionado à cena.
- `connect`: Conecta sinais do `attack_area` a funções específicas para detectar quando o corpo entra ou sai da área de ataque.
- `preload`: Carrega o recurso de dígito de dano que está dentro do arquivo para ser instanciado posteriormente.

---

```
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
```

> **Objetivo principal**: Aplicar dano ao inimigo, mostrar visualmente o dano recebido e verificar se o inimigo deve morrer.

- `damage(amount: int) -> void`: Função que reduz a saúde do inimigo e processa a exibição do dano.
- `modulate = Color.RED`: Altera a cor do nó para vermelho para indicar que o inimigo foi ferido.
- `create_tween()`: Cria uma animação para suavizar a mudança de cor.
- `instantiate()`: Cria uma instância do prefab `damage_digit` para mostrar o valor do dano.
- `if health <= 0: die()`: Verifica se a saúde chegou a zero ou menos, se sim ele chama a função `die()`.

---

```
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
```

> **Objetivo principal**: Processar a morte do inimigo, instanciar um prefab de morte e, possivelmente, fazer o drop de itens.

- `die() -> void`: Função chamada quando o inimigo morre.
- `death_prefab.instantiate()`: Cria uma instância do prefab de morte, se definido.
- `randf() <= drop_chance`: Verifica se o inimigo deve dropar um item baseado na chance.
- `drop_item()`: Função chamada para dropar um item, se necessário.
- `queue_free()`: Remove o nó da cena.

OBS: `randf` é uma função que retorna um número aleatório de ponto flutuante (float) entre 0.0 e 1.0, é usada para gerar valores aleatórios dentro desse intervalo, sendo útil para situações onde você precisa de um número aleatório com casas decimais.

---

```
func drop_item() -> void:
	var drop = get_random_drop_item().instantiate()
	drop.position = position
	get_parent().add_child(drop)
```

> **Objetivo principal**: Instanciar e adicionar um item dropado à cena.

- `func drop_item() -> void`: Declaração da função `drop_item`, que não retorna nenhum valor (`void`). Esta função é responsável por criar e posicionar um item dropado na cena.

- `var drop = get_random_drop_item().instantiate()`: Chama a função `get_random_drop_item()` para obter um item aleatório, depois instancia (`instantiate()`) esse item, o resultado é armazenado na variável `drop`.

  **Exemplo**: Se `get_random_drop_item()` retorna um item chamado "Coração", `instantiate()` cria uma instância real desse "Coração" na memória do jogo.

- `drop.position = position`: Define a posição do item dropado (`drop.position`) para ser igual à posição atual do objeto que chamou esta função (`position`).

  **Exemplo**: Se o objeto está em (100, 200) no jogo, o item dropado também será colocado em (100, 200).

- `get_parent().add_child(drop)`: Adiciona o item dropado (`drop`) como um filho do nó pai (`get_parent()`) do objeto que chamou esta função. Isso coloca o item na cena do jogo.

  **Exemplo**: Se o objeto atual pertence à cena principal, o item dropado será adicionado à cena principal, tornando-o visível e interativo no jogo.

---

```
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
```

> **Objetivo principal**: Determinar qual item deve ser dropado com base nas chances definidas.

### Explicação Passo a Passo

1. **Função Principal**:
   ```
   func get_random_drop_item() -> PackedScene:
   ```
   - Esta função vai escolher um item para ser dropado (solto) quando um inimigo for derrotado. Ela devolve um `PackedScene`, que é o tipo de item.

2. **Verificar se há apenas um item**:
   ```
   if drop_items.size() == 1:
       return drop_items[0]
   ```
   - Se só houver um item na lista de itens que podem ser dropados, a função simplesmente retorna esse item, porque não há necessidade de escolher entre vários.

3. **Calcular a chance máxima**:
   ```
   var max_chance: float = 0.0
   for drop_chance in drop_chances:
       max_chance += drop_chance
   ```
   - Aqui, somamos todas as chances de drop possíveis para obter um valor total, nos dá a chance máxima que podemos usar para nossa "roleta".

4. **Jogar o dado**:
   ```
   var random_value = randf() * max_chance
   ```
   - Usamos `randf()`, que gera um número aleatório entre 0.0 e 1.0. Multiplicamos esse número pela chance máxima (`max_chance`) para obter um valor aleatório dentro do intervalo total das chances.


5. **Girar a roleta**:
   ```
   var needle: float = 0.0
   for i in drop_items.size():
       var drop_item = drop_items[i]
       var drop_chance = drop_chances[i] if i < drop_chances.size() else 1
       if random_value <= drop_chance + needle:
           return drop_item
       needle += drop_chance
   ```

   - `var needle: float = 0.0`: Cria uma variável chamada `needle` e define seu valor inicial como 0.0. Pense nela como um ponteiro que se move ao longo das chances de drop dos itens.

   - `for i in drop_items.size()`: Um loop que percorre todos os itens na lista `drop_items`.

   - `var drop_item = drop_items[i]`: Obtém o item atual na lista `drop_items` com base no índice `i`.

   - `var drop_chance = drop_chances[i] if i < drop_chances.size() else 1`: Define a chance de drop do item atual. Se `i` estiver dentro do tamanho da lista `drop_chances`, usamos `drop_chances[i]`, caso contrário, usamos 1 como chance padrão.

   - `if random_value <= drop_chance + needle`: Verifica se o valor aleatório (`random_value`) está dentro do intervalo da chance de drop do item atual. Este intervalo vai de `needle` até `needle + drop_chance`.

   - `return drop_item`: Se `random_value` estiver dentro do intervalo, retorna o item atual como o drop selecionado.

   - `needle += drop_chance`: Atualiza `needle` ao somar a chance do item atual a ele, isso move o ponteiro para o próximo intervalo de chance de drop.

**Exemplo**:
   - Imagine que `drop_items` tenha 3 itens: [Espada, Poção, Escudo].
   - As chances de drop (`drop_chances`) são [0.5, 0.3, 0.2].
   - Se `random_value` for 0.6:
     - Inicialmente, `needle` é 0.0.
     - Para o primeiro item (Espada), o intervalo é [0.0, 0.5]. `random_value` (0.6) não está neste intervalo, então `needle` é atualizado para 0.5.
     - Para o segundo item (Poção), o intervalo é [0.5, 0.8]. `random_value` (0.6) está neste intervalo, então o item Poção é retornado.

---

6. **Retornar o primeiro item por padrão**:
   ```
   return drop_items[0]
   ```
   - Como medida de segurança, se nenhum item foi selecionado (o que não deveria acontecer), retornamos o primeiro item da lista.

---

```
func _on_attack_area_body_entered(body):
	if body.is_in_group("player"):
		is_attacking = true

func _on_attack_area_body_exited(body):
	if body.is_in_group("player"):
		animated_sprite_2d.play("run")
		is_attacking = false
```

> **Objetivo principal**: Detectar quando o jogador entra ou sai da área de ataque do inimigo.

- `_on_attack_area_body_entered(body)`: Função chamada quando um corpo entra na área de ataque. Define `is_attacking` como `true` se o corpo for do jogador.
- `_on_attack_area_body_exited(body)`: Função chamada quando um corpo sai da área de ataque. Define `is_attacking` como `false` e toca a animação de "run".

---

```
func _physics_process(delta):
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0.0:
			attack_cooldown = attack_cooldown_time
			_attack()
```

> **Objetivo principal**: Gerenciar o cooldown entre ataques e chamar a função de ataque quando apropriado.

- `_physics_process(delta)`: Função chamada a cada frame de física. Diminui o `attack_cooldown` e chama `_attack()` quando o cooldown é zero.

---

```
func _attack():
	for body in attack_area.get_overlapping_bodies():
		if body.is_in_group("player"):
			var player = body as Player
			player.damage(attack_damage)
			animated_sprite_2d.play("attack_side")
			break
```

> **Objetivo principal**: Atacar o jogador se ele estiver na área de ataque.

- `_attack()`: Função que percorre todos os corpos na área de ataque e aplica dano ao jogador, se encontrado.


## Barrel 🧨
```
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
```

> **Objetivo principal**: Definir propriedades e variáveis para o barril, como saúde, dano de explosão, e referências a nós da cena.

- `@export var`: Declara variáveis exportadas para que possam ser configuradas no editor Godot.
- `@onready var`: Inicializa variáveis quando o nó está pronto e os nós filhos já foram carregados.
- `var`: Declara variáveis internas.

---

```
func _ready():
	print("Barrel ready")
	area_explosion.connect("area_entered", Callable(self, "_on_area_explosion_area_entered"))
	print("timer ready")
	timer_explosion.connect("timeout", Callable(self, "_on_timer_timeout"))
```

> **Objetivo principal**: Configurar conexões de sinal para o área de explosão e o temporizador.

- `_ready()`: Função chamada quando o nó está pronto e adicionado à cena.
- `connect`: Conecta sinais dos nós a funções específicas. Aqui, conecta o sinal `area_entered` do `area_explosion` e o sinal `timeout` do `timer_explosion` às funções correspondentes.

---

```
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
```

> **Objetivo principal**: Detectar se o jogador entrou na área de detecção e ajustar a direção do sprite do barril.

- `_on_area_spy_area_entered(area)`: Função chamada quando um corpo entra na área de detecção (`area_spy`).
- `timer_spy.start()`: Inicia o temporizador que pode estar relacionado a um comportamento futuro.
- `animation_barrel.play("spy")`: Toca a animação de "spy" para o barril.
- `barrel_sprite.flip_h`: Ajusta a direção do sprite com base na posição do jogador em relação ao barril.

---

```
func _on_area_explosion_area_entered(area):
	print("Area entered:", area, "Group: ", area.get_groups())
	if area.is_in_group("player"):
		print("Player detected!")
		animation_barrel.play("explosion")
		timer_explosion.start()
		health = 0
```

> **Objetivo principal**: Detectar se o jogador entrou na área de explosão, iniciar a animação de explosão, e definir a saúde do barril para zero.

- `_on_area_explosion_area_entered(area)`: Função chamada quando um corpo entra na área de explosão (`area_explosion`).
- `animation_barrel.play("explosion")`: Toca a animação de "explosion" para o barril.
- `timer_explosion.start()`: Inicia o temporizador que pode ser usado para fazer a explosão após um breve atraso.
- `health = 0`: Define a saúde do barril para zero, preparando-o para a morte e explosão.

---

```
func _on_timer_explosion_timeout():
	print("Temporizador expirou!")
	die_explosion()
```

> **Objetivo principal**: Processar o timeout do temporizador de explosão e chamar a função para executar a explosão.

- `_on_timer_explosion_timeout()`: Função chamada quando o temporizador de explosão expira.
- `die_explosion()`: Chama a função para processar a explosão e a morte do barril.

---

```
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
```

> **Objetivo principal**: Executar a animação de explosão, criar um objeto de explosão, aplicar dano aos jogadores próximos e remover o barril da cena.

- `animation_barrel.play("explosion")`: Toca a animação de "explosion".
- `death_explosion.instantiate()`: Cria uma instância do prefab de explosão e o adiciona à cena.
- `area_explosion.get_overlapping_bodies()`: Obtém todos os corpos que estão sobrepostos à área de explosão.
- `player.damage(explosion_damage)`: Aplica dano ao jogador.
- `queue_free()`: Remove o barril da cena.

---