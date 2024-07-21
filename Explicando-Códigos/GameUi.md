# Código da GameUi

```
extends CanvasLayer

@onready var timer_label: Label = %TimerLabel
@onready var meat_label: Label = %MeatLabel
```

> **Objetivo principal**: Definir a classe, estender a classe `CanvasLayer` e inicializar as variáveis que serão usadas para atualizar os Labels na interface.

`extends CanvasLayer`: Estende a classe `CanvasLayer`, que é usada para criar interfaces de usuário que são desenhadas acima do conteúdo do jogo.

`@onready`: assegura que a variável será inicializada quando o nó estiver pronto.

---

```
func _process(delta: float):
	# Update labels
	timer_label.text = GameManager.time_elapsed_string
	meat_label.text = str(GameManager.meat_counter)
```

> **Objetivo principal**: Atualizar os textos dos Labels a cada frame com o tempo decorrido do jogo e a contagem de carne coletada.

`func _process(delta: float)`: Declara a função `_process`, que é chamada a cada frame.

`timer_label.text = GameManager.time_elapsed_string`: Atualiza a propriedade `text` do `timer_label` com a string que representa o tempo decorrido do `GameManager`.

`meat_label.text = str(GameManager.meat_counter)`: Atualiza a propriedade `text` do `meat_label` com o número de carnes coletadas, convertido para string.

---

