# Código da Carne 🍖
Esse código serve tanto para a carne dourada quanto para a normal:

```
extends Node2D

@export var regeneration_amount: int = 12

@onready var area_2d = $Area2D
@onready var meat = $"."


func _ready():
	area_2d.connect("body_entered", Callable(self, "_on_area_2d_body_entered"))
```

> **Objetivo principal**: Configurar variáveis e conectar sinais.

- `@export var regeneration_amount: int = 12`: Define uma variável exportada `regeneration_amount` que pode ser configurada no editor Godot, essa variável representa a quantidade de vida que será regenerada ao jogador.

- `@onready var area_2d = $Area2D`: Inicializa a variável `area_2d` com o nó `Area2D` quando o nó estiver pronto.

`@onready var meat = $"."`: Inicializa a variável `meat` com o nó `AnimatedSprite2D` quando o nó estiver pronto.

---

```
func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		var player: Player = body
		player.heal(regeneration_amount)
		player.meat_collected.emit(regeneration_amount)
		queue_free()
```

> **Objetivo principal**: Regenerar a vida do jogador ao entrar na área e liberar o nó após o evento.

- `_on_area_2d_body_entered(body)`: Função chamada quando um corpo entra na área `Area2D`.

- `if body.is_in_group("player")`: Verifica se o corpo que entrou na área é um jogador.

- `var player: Player = body`: Esta linha faz algo chamado "cast" ou "conversão de tipo" do objeto body para um tipo específico chamado Player (Classe do Player).

- `player.heal(regeneration_amount)`: Chama o método `heal` do jogador para aumentar a vida do jogador pela quantidade definida em `regeneration_amount`.

- `player.meat_collected.emit(regeneration_amount)`: Emite um sinal `meat_collected` do jogador, que provavelmente notifica sobre a coleta de carne ou um item de regeneração.

- `queue_free()`: Remove o nó da cena, pois a regeneração já foi aplicada e o item não é mais necessário.

---
