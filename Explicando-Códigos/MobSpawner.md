# Código do MobSpawner ☠️
Mobspawner é uma automação de criação de monstros, nesse jogo era de extrema importância, pois seria impossível carregar a cena de infinitos monstros a medida que o player fosse sobrevivendo: 

```
func _process(delta: float):
	# Ignorar GameOver
	if GameManager.is_game_over: return
```

> **Objetivo principal**: Gerenciar a criação de mobs a cada frame, ignorando se o jogo estiver em estado de Game Over.

- `func _process(delta: float)`: Declara a função `_process` que é chamada a cada frame.

Exemplo: Se `delta` é 0.016 (aproximadamente 1/60 de segundo), e o `cooldown` é 1.0, então após 60 frames (ou 1 segundo), o `cooldown` será reduzido para zero.

- `if GameManager.is_game_over: return`: Verifica se o jogo está em estado de GameOver, se estiver, a função retorna imediatamente, impedindo a criação de novos mobs.

---

```
	# Temporizador
	cooldown -= delta
	if cooldown > 0: return
```

> **Objetivo principal**: Atualizar e verificar o temporizador para a criação de mobs.

- `cooldown -= delta`: Diminui o valor do `cooldown` pelo tempo decorrido (`delta`) desde o último frame, diminui o temporizador de spawn.

- `if cooldown > 0: return`: Se o cooldown ainda não chegou a zero, a função retorna sem criar um novo mob, afirmando que o spawner só vai criar mobs após um intervalo de tempo especifico.

---

```
	# Frequência
	var interval = 60.0 / mobs_per_minute
	cooldown = interval
```

> **Objetivo principal**: Calcular e definir o intervalo entre as criações de mobs com base na frequência desejada.

- `var interval = 60.0 / mobs_per_minute`: Calcula o intervalo de tempo entre a criação de mobs, convertendo a taxa de mobs por minuto para um intervalo em segundos.

Exemplo: Se `mobs_per_minute` é 30, `interval` será 60.0 / 30 = 2.0 segundos. Isso significa que um mob será criado a cada 2 segundos.

- `cooldown = interval`: Define o cooldown para o intervalo calculado, reiniciando o temporizador para o próximo spawn.

---

```
	# Checar se o ponto é válido
	var point = get_point()
	var world_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = point
	parameters.collision_mask = 0b1001
	var result: Array = world_state.intersect_point(parameters, 1)
	if not result.is_empty(): return
```

> **Objetivo principal**: Verificar se o ponto de spawn é válido antes de criar um mob.

- `var point = get_point()`: Obtém um ponto de spawn usando a função `get_point()`.

- `var world_state = get_world_2d().direct_space_state`: Obtém o estado do espaço 2D atual, usado para realizar consultas de física no mundo do jogo.

- `var parameters = PhysicsPointQueryParameters2D.new()`: Cria um novo conjunto de parâmetros para uma consulta de ponto de física.

- `parameters.position = point`: Define a posição para a consulta de ponto como o ponto de spawn obtido.

- `parameters.collision_mask = 0b1001`: Define a máscara de colisão para a consulta, especificando quais camadas de colisão devem ser consideradas, certificando que o ponto não está em uma área ocupada por uma parede.

- `var result: Array = world_state.intersect_point(parameters, 1)`: Realiza a consulta de ponto no espaço 2D com os parâmetros definidos, retornando uma lista de corpos que estão no ponto especificado.

- `if not result.is_empty(): return`: Se o ponto de spawn estiver ocupado (ou seja, se a lista de resultados não estiver vazia), a função retorna sem criar um novo mob.

---

```
	# Instanciar uma criatura aleatória
	var index = randi_range(0, creatures.size() - 1)
	var creature_scene = creatures[index]
	var creature = creature_scene.instantiate()
	creature.global_position = point
	get_parent().add_child(creature)
```

> **Objetivo principal**: Instanciar e posicionar uma criatura aleatória no ponto de spawn válido.

- `var index = randi_range(0, creatures.size() - 1)`: Seleciona aleatoriamente um índice da lista de criaturas (`creatures`).

Exemplo: Se `creatures` contém 3 elementos, `randi_range(0, 2)` pode retornar 0, 1 ou 2.

- `var creature_scene = creatures[index]`: Obtém a cena da criatura selecionada a partir da lista de criaturas.

- `var creature = creature_scene.instantiate()`: Instancia (cria) a cena da criatura selecionada, criando um novo objeto da criatura.

- `creature.global_position = point`: Define a posição global da nova criatura para o ponto de spawn obtido anteriormente.

- `get_parent().add_child(creature)`: Adiciona a nova criatura como filho do nó pai do spawner, integrando-a na cena.

---

```
func get_point() -> Vector2:
	path_follow_2d.progress_ratio = randf()
	return path_follow_2d.global_position
```

> **Objetivo principal**: Determinar o ponto de spawn usando o `PathFollow2D`.

- `func get_point() -> Vector2`: Esta função determina aleatoriamente um ponto ao longo de um caminho (`Path2D`) para criar o mob.

- `path_follow_2d.progress_ratio = randf()`: Define um progresso aleatório ao longo do caminho `Path2D` usando `randf()`, que retorna um número aleatório entre 0 e 1.

- `return path_follow_2d.global_position`: Retorna a posição global do `PathFollow2D` no caminho. Este é o ponto onde o mob será criado.

Exemplo: Se o caminho é um círculo, `path_follow_2d.progress_ratio = randf()` move o `PathFollow2D` para um ponto aleatório ao longo do círculo, garantindo que os mobs sejam criados em posições variadas.

---
