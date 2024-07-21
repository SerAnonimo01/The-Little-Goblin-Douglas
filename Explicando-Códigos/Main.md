# Código do Main 🎥
Esse é o Script da cena Principal do jogo:

```
extends Node

@export var game_ui: CanvasLayer
@export var game_over_ui_template: PackedScene
```

> **Objetivo principal**: Definir a classe, declarar variáveis exportadas que referenciam a interface do usuário do jogo (`game_ui`) e o template da interface de game over (`game_over_ui_template`).

`extends Node`: Estende a classe `Node`, base para todos os nós que possuem uma posição no espaço.

`@export var game_ui: CanvasLayer`: Declara uma variável exportada `game_ui` do tipo `CanvasLayer`, que armazenará a interface do usuário do jogo.

`@export var game_over_ui_template: PackedScene`: Declara uma variável exportada `game_over_ui_template` do tipo `PackedScene`, que armazenará o template da interface de gameover.

Exemplo: No editor, você pode definir `game_ui` e `game_over_ui_template` arrastando e soltando os nós correspondentes nas propriedades exportadas.

---


```
func _ready():
	GameManager.game_over.connect(trigger_game_over)
```

> **Objetivo principal**: Conectar o sinal `game_over` do `GameManager` à função `trigger_game_over` para que ela seja chamada quando o jogo terminar.

`func _ready()`: Declara a função `_ready`, que é chamada quando o nó e seus filhos estão prontos.

`GameManager.game_over.connect(trigger_game_over)`: Conecta o sinal `game_over` do `GameManager` à função `trigger_game_over`.

Exemplo: Quando o jogo termina, o sinal `game_over` é emitido e a função `trigger_game_over` é chamada para exibir a interface de gameover.

---


```
func trigger_game_over():
	# Deletar GameUI
	if game_ui:
		game_ui.queue_free()
		game_ui = null
	
	# Criar GameOverUI
	var game_over_ui: GameOverUI = game_over_ui_template.instantiate()
	add_child(game_over_ui)
```

> **Objetivo principal**: Gerenciar a transição da interface do usuário do jogo para a interface de game over, deletando a `game_ui` e instanciando a `game_over_ui`.

```
# Deletar GameUI
if game_ui:
	game_ui.queue_free()
	game_ui = null
```
> **Objetivo**: Remover a interface do usuário do jogo da cena.

`if game_ui`: Verifica se `game_ui` existe.

`game_ui.queue_free()`: Remove `game_ui` da cena e a coloca na fila para ser deletada.

`game_ui = null`: Define `game_ui` como nulo para evitar referências inválidas.

```
# Criar GameOverUI
var game_over_ui: GameOverUI = game_over_ui_template.instantiate()
add_child(game_over_ui)
```
> **Objetivo**: Instanciar e adicionar a interface de game over à cena.

`var game_over_ui: GameOverUI = game_over_ui_template.instantiate()`: Instancia a interface de game over a partir do template `game_over_ui_template`.

`add_child(game_over_ui)`: Adiciona a instância da interface de game over à cena.

---
