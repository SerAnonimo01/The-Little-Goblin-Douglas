# Código da Interface do GameOver

```
class_name GameOverUI
extends CanvasLayer

@onready var time_label: Label = %TimeLabel
@onready var monsters_label: Label = %DeathMonstersLabel

@export var restart_delay: float = 5.0
var restart_cooldown: float
```

> **Objetivo principal**: Definir a classe, variáveis exportadas e locais que serão usadas para controlar a interface de "GameOver".

`class_name GameOverUI`: Define o nome da classe como `GameOverUI` para que possa ser instanciada e usada em outros scripts.

`extends CanvasLayer`: Estende a classe `CanvasLayer`, que é usada para criar interfaces de usuário que são desenhadas acima do conteúdo do jogo.

`@onready` assegura que a variável será inicializada quando o nó estiver pronto.

`@export var restart_delay: float = 5.0`: Define o tempo de espera para reiniciar o jogo, com valor padrão de 5.0 segundos.

`var restart_cooldown: float`: Define uma variável `restart_cooldown` que será usada para controlar o tempo restante antes de reiniciar o jogo.

---

```
func _ready():
	time_label.text = GameManager.time_elapsed_string
	monsters_label.text = str(GameManager.monsters_defeated_counter)
	restart_cooldown = restart_delay
```

> **Objetivo principal**: Inicializar os valores e atualizar os Labels quando o nó estiver pronto.

`func _ready()`: Declara a função `_ready` que é chamada quando o nó e todos os seus filhos foram adicionados ao cenário.

`time_label.text = GameManager.time_elapsed_string`: Atualiza a propriedade `text` do `time_label` com a string que representa o tempo decorrido do `GameManager`.

`monsters_label.text = str(GameManager.monsters_defeated_counter)`: Atualiza a propriedade `text` do `monsters_label` com o número de monstros derrotados, convertido para string.

`restart_cooldown = restart_delay`: Inicializa `restart_cooldown` com o valor de `restart_delay`, definindo o tempo de espera antes de reiniciar o jogo.

Exemplo: Se o tempo decorrido for "10:23" e o número de monstros derrotados for 5, os Labels serão atualizados para "10:23" e "5" respectivamente.

---

```
func _process(delta):
	restart_cooldown -= delta
	if restart_cooldown <= 0.0:
		restart_game()
```

> **Objetivo principal**: Diminuir o valor de `restart_cooldown` a cada quadro e reiniciar o jogo quando chegar a zero.

`func _process(delta)`: Declara a função `_process`, que é chamada a cada frame.

`restart_cooldown -= delta`: Diminui `restart_cooldown` pelo valor de `delta`, fazendo uma contagem regressiva.

`if restart_cooldown <= 0.0`: Verifica se `restart_cooldown` é menor ou igual a zero.

`restart_game()`: Chama a função `restart_game` para reiniciar o jogo.

---

```
func restart_game():
	GameManager.reset()
	get_tree().reload_current_scene()
```

> **Objetivo principal**: Reiniciar o estado do jogo e recarregar a cena atual.

`func restart_game()`: Declara a função `restart_game`.

`GameManager.reset()`: Chama a função `reset` do `GameManager` para redefinir o estado do jogo.

`get_tree().reload_current_scene()`: Recarrega a cena atual, efetivamente reiniciando o jogo.

Exemplo: Quando a função `restart_game` é chamada, o jogo volta ao estado inicial, como se tivesse sido reiniciado manualmente.

---
