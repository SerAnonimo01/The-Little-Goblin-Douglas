## Código do Comportamento Follow Player 🕸️
Esse comportamento fará os inimigos seguirem o Player de acordo com as posições do Player:

```
extends Node

@export var speed: float = 0.5

var enemy: Enemy
var sprite: AnimatedSprite2D
```
> **Objetivo principal:** Configurar variáveis e exportar propriedades para o editor.

- `extends Node`: Indica que a classe está estendendo a classe base `Node` do Godot. 
- `@export var speed: float = 0.5`: Declara uma variável `speed` que pode ser ajustada no editor Godot.
- `var enemy: Enemy`: Declara uma variável `enemy` que será usada para armazenar uma referência ao nó inimigo, presumivelmente uma classe tipo `Enemy`.
- `var sprite: AnimatedSprite2D`: Declara uma variável `sprite` para armazenar a referência ao nó `AnimatedSprite2D` do inimigo, que será usado para animação.

---

```
func _ready():
    enemy = get_parent()
    sprite = enemy.get_node("AnimatedSprite2D")
```
> **Objetivo principal:** Inicializar variáveis quando o nó estiver pronto.

- `func _ready()`: Esta função é chamada quando o nó é adicionado à cena e está pronto para funcionar.
- `enemy = get_parent()`: Atribui o nó pai do script à variável `enemy`, presume-se que o nó pai é do tipo `Enemy`.
- `sprite = enemy.get_node("AnimatedSprite2D")`: Obtém o nó `AnimatedSprite2D` dentro do nó `enemy` e o atribui à variável `sprite`, isso permite controlar as animações do inimigo.

---

```
func _physics_process(delta: float) -> void:
    # Ignorar GameOver
    if GameManager.is_game_over: return
    
    # Calcular direção
    var player_position = GameManager.player_position
    var difference = player_position - enemy.position
    var input_vector = difference.normalized()
    
    # Movimento
    enemy.velocity = input_vector * speed * 100.0
    enemy.move_and_slide()

    # Girar sprite
    if input_vector.x > 0:
        sprite.flip_h = false
    elif input_vector.x < 0:
        sprite.flip_h = true
```
> **Objetivo principal:** Atualizar o movimento do inimigo e a orientação do sprite com base na posição do jogador.

- `func _physics_process(delta: float) -> void:`: Esta função é chamada em cada frame físico, o que é ideal para atualizar a física e o movimento dos nós.
- `if GameManager.is_game_over: return`: Verifica se o jogo acabou (`GameManager.is_game_over`), e se for verdade, retorna da função, ignorando o restante do código. 

**Calcular Direção:**
  ```
  var player_position = GameManager.player_position
  var difference = player_position - enemy.position
  var input_vector = difference.normalized()
  ```
  - `var player_position = GameManager.player_position`: Obtém a posição do jogador armazenada no `GameManager`.
  - `var difference = player_position - enemy.position`: Calcula a diferença entre a posição do jogador e a posição do inimigo.
  - `var input_vector = difference.normalized()`: Normaliza o vetor `difference` para obter um vetor unitário que aponta na direção do jogador, normalizar o vetor garante que a direção seja preservada, mas a magnitude seja igual a 1.

**Movimento:**
  ```
  enemy.velocity = input_vector * speed * 100.0
  enemy.move_and_slide()
  ```
  - `enemy.velocity = input_vector * speed * 100.0`: Define a velocidade do inimigo como a direção normalizada multiplicada pela `speed` e um fator de escala (100.0). Isso ajusta a velocidade do inimigo com base na direção calculada.
  - `enemy.move_and_slide()`: Move o inimigo de acordo com a sua velocidade e lida com a colisão com outros corpos de maneira que deslize ao longo das superfícies.

**Girar o Sprite:**
  ```
  if input_vector.x > 0:
      sprite.flip_h = false
  elif input_vector.x < 0:
      sprite.flip_h = true
  ```
  - `if input_vector.x > 0:`: Se o vetor de entrada indica que o inimigo está se movendo para a direita (`input_vector.x` é positivo), o sprite não deve ser virado horizontalmente (`flip_h = false`).
  - `elif input_vector.x < 0:`: Se o vetor de entrada indica que o inimigo está se movendo para a esquerda (`input_vector.x` é negativo), o sprite deve ser virado horizontalmente (`flip_h = true`).
  
  ---