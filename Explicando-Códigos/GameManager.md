# Código do Game Manager 🐉

```
extends Node

signal game_over

var player: Player
var player_position: Vector2
var is_game_over: bool = false

var time_elapsed: float = 0.0
var time_elapsed_string: String
var meat_counter: int = 0
var monsters_defeated_counter: int = 0
```

> **Objetivo principal**: Definir a classe, declarar variáveis e um sinal para gerenciar o estado do jogo, incluindo o jogador, o temporizador e contadores.

`extends Node`: Estende a classe `Node`, base para todos os nós que possuem uma posição no espaço.

`signal game_over`: Declara um sinal chamado `game_over` que será emitido quando o jogo terminar.

`var player: Player`: Declara uma variável `player` que armazenará a instância do jogador.

`var player_position: Vector2`: Declara uma variável para armazenar a posição do jogador.

`var is_game_over: bool = false`: Declara uma variável booleana `is_game_over` para indicar se o jogo acabou.

`var time_elapsed: float = 0.0`: Declara uma variável `time_elapsed` para armazenar o tempo decorrido desde o início do jogo.

`var time_elapsed_string: String`: Declara uma variável `time_elapsed_string` para armazenar o tempo decorrido em formato de string.

OBS: Uma string é uma sequência de caracteres, como letras, números ou símbolos, que é usada para representar texto em programação.

`var meat_counter: int = 0`: Declara uma variável `meat_counter` para contar a quantidade de carne coletada.

`var monsters_defeated_counter: int = 0`: Declara uma variável `monsters_defeated_counter` para contar o número de monstros derrotados.

---


```
func _process(delta: float):
	# Update timer
	time_elapsed += delta
	var time_elapsed_in_seconds: int = floori(time_elapsed)
	var seconds: int = time_elapsed_in_seconds % 60
	var minutes: int = time_elapsed_in_seconds / 60
	time_elapsed_string = "%02d:%02d" % [minutes, seconds]
```

> **Objetivo principal**: Atualizar o temporizador do jogo a cada frame, convertendo o tempo decorrido em uma string formatada para exibição.

`func _process(delta: float)`: Declara a função `_process`, que é chamada a cada frame.

`time_elapsed += delta`: Incrementa `time_elapsed` pelo tempo decorrido desde o último frame.

`var time_elapsed_in_seconds: int = floori(time_elapsed)`: Converte `time_elapsed` para segundos inteiros.

OBS: A função `floori` é usada para arredondar um número decimal para baixo até o inteiro mais próximo. Por exemplo, `floori(3.7)` resulta em `3` e `floori(-2.5)` resulta em `-3`.


`var seconds: int = time_elapsed_in_seconds % 60`: Calcula os segundos.

`var minutes: int = time_elapsed_in_seconds / 60`: Calcula os minutos.

`time_elapsed_string = "%02d:%02d" % [minutes, seconds]`: Formata `minutes` e `seconds` como uma string no formato "MM:SS".

Exemplo: Se `time_elapsed` for `75.0`, `time_elapsed_in_seconds` será `75`, `minutes` será `1` e `seconds` será `15`. `time_elapsed_string` será "01:15".

---

```
func end_game():
	if is_game_over: return
	is_game_over = true
	game_over.emit()
```

> **Objetivo principal**: Finalizar o jogo e emitir o sinal `game_over`.

`if is_game_over: return`: Verifica se o jogo já acabou, se sim, retorna e não faz nada.

`is_game_over = true`: Define `is_game_over` como `true`.

`game_over.emit()`: Emite o sinal `game_over`.

---

```
func reset():
	player = null
	player_position = Vector2.ZERO
	is_game_over = false
	
	time_elapsed = 0.0
	time_elapsed_string = "00:00"
	meat_counter = 0
	monsters_defeated_counter = 0
	
	for connection in game_over.get_connections():
		game_over.disconnect(connection.callable)
```

> **Objetivo principal**: Resetar todas as variáveis e o estado do jogo para seus valores iniciais.

`player = null`: Define `player` como nulo.

`player_position = Vector2.ZERO`: Reseta a posição do jogador.

`is_game_over = false`: Define `is_game_over` como `false`.

`time_elapsed = 0.0`: Reseta o tempo decorrido.

`time_elapsed_string = "00:00"`: Reseta a string do tempo decorrido.

`meat_counter = 0`: Reseta o contador de carne coletada.

`monsters_defeated_counter = 0`: Reseta o contador de monstros derrotados.

`for connection in game_over.get_connections(): game_over.disconnect(connection.callable)`: Desconecta todos os sinais `game_over` conectados.

---
