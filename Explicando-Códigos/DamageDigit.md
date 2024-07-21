# Código do Damage Digit 🔢
Esse código é referente aos pequenos números que aparecem nos inimigos após tomarem dano, indicando a perda de vida que tiveram após o ataque:

```
extends Node2D

@export var value: int = 0
@onready var label = %Label
```

> **Objetivo principal**: Definir variáveis exportadas e locais que serão usadas para controlar o comportamento do `Node2D`

`@export var value: int = 0`: Exporta uma variável inteira chamada `value`, permitindo que seja configurada no editor.

`@onready` assegura que a variável será inicializada quando o nó estiver pronto, ou seja, após ele e todos os seus filhos serem adicionados ao cenário.

---

```
func _ready():
	%Label.text = str(value)
```

> **Objetivo principal**: Atualizar o texto do `%Label` quando o nó estiver pronto

`func _ready()`: Esta função é usada para inicializações que dependem da estrutura da cena estar completamente carregada.

`%Label.text = str(value)`: Atualiza a propriedade `text` do `Label` com o valor da variável `value` convertido para string. Isso exibe o valor de `value` no `Label` na interface do usuário.

Exemplo: Se `value` for 10, o texto do `Label` será atualizado para "10".

---
