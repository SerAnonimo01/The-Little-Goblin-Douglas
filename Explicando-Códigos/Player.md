# Código do Player 🔥

<p align="center">
  <img align="center" src="https://github.com/user-attachments/assets/47353cb9-6999-4edd-9a7d-7ed24915a38c" alt="Imagem">
</p>

```
class_name Player
extends CharacterBody2D
```
> Objetivo principal: Definir a classe `Player` que herda de `CharacterBody2D`

- `class_name Player`: Define o nome da classe como `Player`, permitindo que seja utilizada como um tipo global no Godot.

- `extends CharacterBody2D`: Indica que a classe `Player` herda as funcionalidades de um nó `CharacterBody2D`.

---

```
@export var speed: float = 3
@export var torch_damage: int = 6
@export var health: int = 80
@export var max_health: int = 80
@export var death_prefab: PackedScene
```
> Objetivo principal: Declarar variáveis exportáveis que podem ser configuradas no editor

-`@export var`: Permite que as variáveis sejam editáveis no editor do Godot.

-`speed`, `torch_damage`, `health`, `max_health`, `death_prefab`: Variáveis que definem a velocidade, dano da tocha, saúde atual, saúde máxima e a cena de morte do jogador.

---

```
@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var torch_area = $TorchArea
@onready var health_progress_bar = $HealthProgressBar
```
> Objetivo principal: Inicializar variáveis que referenciam nós específicos da cena

`@onready var`: Inicializa as variáveis quando a cena estiver pronta.

---

```
var input_vector: Vector2
var is_running: bool = false
var was_running: bool = false
var is_attacking: bool = false
var attack_cooldown: float = 0.0

signal meat_collected(value: int)
```
> Objetivo principal: Declarar variáveis e sinais utilizados no script

`input_vector`: Armazena a direção do movimento do jogador.

`is_running`, `was_running`, `is_attacking`: Variáveis booleanas para controlar o estado do jogador.

`attack_cooldown`: Temporizador para controlar o tempo entre ataques.

`signal meat_collected(value: int)`: Declara um sinal que será emitido quando carne for coletada.

---

```
func _ready():
    add_to_group("player")
    print("Player added to group 'player'")
    
    GameManager.player = self
    meat_collected.connect(func(value: int):
        GameManager.meat_counter += 1)
```
> Objetivo principal: Inicializar o jogador quando a cena estiver pronta

`_ready()`: Função chamada quando o nó está pronto.

`add_to_group("player")`: Adiciona o jogador ao grupo "player".

`GameManager.player = self`: Define o jogador atual no GameManager.

`meat_collected.connect(func(value: int): GameManager.meat_counter += 1)`: Conecta o sinal `meat_collected` a uma função anônima que incrementa o contador de carne no GameManager.

---

```
func _process(delta: float) -> void:
    GameManager.player_position = position
    
    read_input()
    update_attack_cooldown(delta)
    if Input.is_action_just_pressed("attack"):
        attack()
    
    play_run_idle_animation()
    if not is_attacking:
        rotate_sprite()
        
    health_progress_bar.max_value = max_health
    health_progress_bar.value = health
```
> Objetivo principal: Processar o input do jogador, atualizar o cooldown do ataque, animações e a barra de saúde

`_process(delta: float) -> void`: Função chamada a cada frame.

`GameManager.player_position = position`: Atualiza a posição do jogador no GameManager.

`read_input()`: Função que lê o input do jogador.

`update_attack_cooldown(delta)`: Atualiza o temporizador do ataque.

`Input.is_action_just_pressed("attack")`: Verifica se a ação de ataque foi pressionada.

`attack()`: Executa a função de ataque.

`play_run_idle_animation()`: Controla as animações de corrida e idle (Player parado).

`rotate_sprite()`: Rotaciona o sprite do jogador.

`health_progress_bar.max_value = max_health`, `health_progress_bar.value = health`: Atualiza os valores da barra de saúde.

---

```
func _physics_process(delta: float) -> void:
    var target_velocity = input_vector * speed * 100.0
    if is_attacking:
        target_velocity *= 0.25
    velocity = lerp(velocity, target_velocity, 0.1)
    move_and_slide()
```
> Objetivo principal: Processar a física do movimento do jogador

`_physics_process(delta: float) -> void`: Função chamada a cada frame de física.

`target_velocity = input_vector * speed * 100.0`: Calcula a velocidade alvo com base no input do jogador.

`is_attacking`: Reduz a velocidade se o jogador estiver atacando.

`lerp(velocity, target_velocity, 0.1)`: Suaviza a transição da velocidade.

`move_and_slide()`: Move o jogador com a nova velocidade.

---

```
func update_attack_cooldown(delta: float) -> void:
    if is_attacking:
        attack_cooldown -= delta
        if attack_cooldown <= 0.0:
            is_attacking = false
            is_running = false
            animation_player.play("idle")
```
> Objetivo principal: Atualizar o temporizador do ataque

`update_attack_cooldown(delta: float) -> void`: Função que atualiza o cooldown do ataque.

`attack_cooldown -= delta`: Diminui o cooldown com base no tempo passado.

`attack_cooldown <= 0.0`: Reseta o estado de ataque quando o cooldown chega a zero.

---

```
func read_input() -> void:
    input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    was_running = is_running
    is_running = not input_vector.is_zero_approx()
```
> Objetivo principal: Ler o input do jogador e atualizar o estado de movimento

`read_input() -> void`: Função que lê o input do jogador.

`input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")`: Obtém o vetor de movimento com base no input.

`was_running = is_running`, `is_running = not input_vector.is_zero_approx()`: Atualiza o estado de movimento do jogador.

---

```
func play_run_idle_animation() -> void:
    if not is_attacking:
        if was_running != is_running:
            if is_running:
                animation_player.play("run")
            else:
                animation_player.play("idle")
```
> Objetivo principal: Tocar as animações de corrida e idle (Player parado)

`play_run_idle_animation() -> void`: Função que controla as animações de corrida e idle.

`was_running != is_running`: Verifica se o estado de movimento mudou.

---

```
func rotate_sprite() -> void:
    if input_vector.x > 0:
        sprite_2d.flip_h = false
    elif input_vector.x < 0:
        sprite_2d.flip_h = true
```
> Objetivo principal: Rotacionar o sprite do jogador

`rotate_sprite() -> void`: Função que rotaciona o sprite com base no input horizontal.

`sprite_2d.flip_h = false/true`: Inverte o sprite horizontalmente.

---

```
func attack() -> void:
    if is_attacking:
        return
    if input_vector.y > 0:
        animation_player.play("attack_down")
    elif input_vector.y < 0:
        animation_player.play("attack_up")
    else:
        animation_player.play("attack_side")
    
    attack_cooldown = 0.6
    is_attacking = true
```
> Objetivo principal: Executar o ataque do jogador

`attack() -> void`: Função que executa o ataque do jogador.

`animation_player.play("attack_*")`: Toca a animação de ataque baseada na direção do input.

`attack_cooldown = 0.6`, `is_attacking = true`: Configura o cooldown e marca o estado de ataque.

---

```
func deal_damage_to_enemies() -> void:
    # Obtém todos os corpos que estão sobrepondo a área da tocha
    var bodies = torch_area.get_overlapping_bodies()
    
    # Itera sobre cada corpo detectado
    for body in bodies:
        # Verifica se o corpo pertence ao grupo "enemies"
        if body.is_in_group("enemies"):
            var enemy: Enemy = body
            
            # Calcula a direção do inimigo em relação ao jogador
            var direction_to_enemy = (enemy.position - position).normalized()
            var attack_direction: Vector2

            # Define a direção do ataque com base no input do jogador
            if input_vector.y < 0:
                attack_direction = Vector2.UP
            elif input_vector.y > 0:
                attack_direction = Vector2.DOWN
            elif sprite_2d.flip_h:
                attack_direction = Vector2.LEFT
            else:
                attack_direction = Vector2.RIGHT
            
            # Calcula o produto escalar entre a direção do ataque e a direção para o inimigo
            var dot_product = direction_to_enemy.dot(attack_direction)

            # Verifica se o inimigo está na direção correta para receber o dano
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
```

### Explicação Passo a Passo 

1. **Obtenção dos Corpos na Área da Tocha:**
   ```
   var bodies = torch_area.get_overlapping_bodies()
   ```
   - `torch_area.get_overlapping_bodies()`: Obtém uma lista de todos os corpos que estão atualmente sobrepondo a área da tocha (`TorchArea`), que é um nó de área em Godot.

2. **Iteração Sobre os Corpos:**
   ```
   for body in bodies:
   ```
   - O loop `for` percorre cada corpo detectado na área da tocha.

3. **Verificação do Grupo "enemies":**
   ```
   if body.is_in_group("enemies"):
   ```
   - `body.is_in_group("enemies")`: Verifica se o corpo pertence ao grupo "enemies". Isso é feito para garantir que apenas inimigos recebam dano.

4. **Cálculo da Direção para o Inimigo:**
   ```
   var direction_to_enemy = (enemy.position - position).normalized()
   ```
   - `direction_to_enemy` é o vetor que aponta da posição do jogador para a posição do inimigo, normalizado para obter um vetor unitário (ou seja, com magnitude de 1).

5. **Definição da Direção do Ataque:**
   ```
   if input_vector.y < 0:
       attack_direction = Vector2.UP
   elif input_vector.y > 0:
       attack_direction = Vector2.DOWN
   elif sprite_2d.flip_h:
       attack_direction = Vector2.LEFT
   else:
       attack_direction = Vector2.RIGHT
   ```
   - Dependendo do input do jogador (`input_vector`), define a direção do ataque (`attack_direction`). Se o jogador estiver movendo para cima, o ataque é para cima; se estiver movendo para baixo, é para baixo; se o sprite está virado para a esquerda, o ataque é para a esquerda; caso contrário, é para a direita.

6. **Cálculo do Produto Escalar:**
   ```
   var dot_product = direction_to_enemy.dot(attack_direction)
   ```
   - O produto escalar entre `direction_to_enemy` e `attack_direction` ajuda a determinar o alinhamento entre a direção do ataque e a direção para o inimigo.

7. **Verificação da Direção do Ataque:**
   - O código compara a direção do ataque com a direção do inimigo para decidir se o inimigo está na direção correta para receber o dano.
   - Por exemplo, se a direção do ataque é para a esquerda (`Vector2.LEFT`), e o `direction_to_enemy.x` é menor ou igual a -0.7, isso indica que o inimigo está suficientemente à esquerda para ser atingido pelo ataque. Os valores de comparação são ajustados para considerar a precisão do alinhamento.

8. **Aplicação do Dano ao Inimigo:**
   ```
   enemy.damage(torch_damage)
   ```
   - Se o inimigo estiver na direção correta, a função `damage` do inimigo é chamada com o valor de `torch_damage` para aplicar o dano.

---

```
func damage(amount: int) -> void:
    if health <= 0: return
    health -= amount
    print("Player recebeu dano de ", amount, ". A vida total é de ", health)

    modulate = Color.RED
    var tween = create_tween()
    tween.set_ease(Tween.EASE_IN)
    tween.set_trans(Tween.TRANS_QUINT)
    tween.tween_property(self, "modulate", Color.WHITE, 0.3)

    if health <= 0:
        die()
```
> Objetivo principal: Aplicar dano ao jogador e processar a morte se necessário

`damage(amount: int) -> void`: Função que aplica dano ao jogador.

`health -= amount`: Reduz a saúde do jogador pelo valor do dano.

`print`: Exibe uma mensagem no console para o desenvolvedor saber se está funcionando a mecânica.

`modulate = Color.RED`, `tween.tween_property(self, "modulate", Color.WHITE, 0.3)`: Faz o jogador piscar em vermelho.

`die()`: Chama a função `die` se a saúde for zero ou menor.

---

```
func die() -> void:
    GameManager.end_game()
    
    if death_prefab:
        var death_object = death_prefab.instantiate()
        death_object.position = position
        get_parent().add_child(death_object)
    
    queue_free()
```
> Objetivo principal: Processar a morte do jogador

`die() -> void`: Função que processa a morte do jogador.

`GameManager.end_game()`: Chama a função de fim de jogo.

`death_prefab.instantiate()`: Cria a instância do objeto de morte.

`queue_free()`: Remove o jogador da cena.

---

```
func heal(amount: int) -> int:
    health += amount
    if health > max_health:
        health = max_health
    print("Player recebeu cura de ", amount, ". A vida total é de ", health, "/", max_health)
    return health
```
> Objetivo principal: Curar o jogador

`heal(amount: int) -> int`: Função que cura o jogador.

`health += amount`: Aumenta a saúde do jogador pelo valor da cura.

`if health > max_health: health = max_health`: Garante que a saúde não exceda o máximo.

`return health`: Retorna a saúde atual do jogador.

---