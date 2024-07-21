# Código do Difficulty System 🌊
Esse sistema de dificuldade é formado por "ondas" constante e crescentes, ou seja, terá momentos no jogo que serão de aperto para a sobrevivência do player, após isso um "descanso" ao mesmo a fim de recompor a vida, e gradativamente a dificuldade vai aumentando de acordo com a evolução do jogador, mas sempre nessa constante onda:

```
extends Node

@export var mob_spawner: MobSpawner
@export var initial_spawn_rate: float = 30.0
@export var spawn_rate_per_minute: float = 30.0
@export var wave_duration: float = 20.0
@export var break_intensity: float = 0.5

var time: float = 0.0
```

> **Objetivo principal**: Definir variáveis exportadas e locais que serão usadas para controlar o comportamento do spawner de mobs

`@export var initial_spawn_rate: float = 30.0`: Exporta uma variável que define a taxa inicial de spawn de mobs por minuto. 

`@export var spawn_rate_per_minute: float = 30.0`: Define a taxa de aumento do spawn de mobs por minuto. 

`@export var wave_duration: float = 20.0`: Define a duração de uma onda em segundos. 

`@export var break_intensity: float = 0.5`: Define a intensidade da pausa (intervalo de baixa atividade).

`var time: float = 0.0`: Define uma variável local que rastreia o tempo total decorrido desde o início do jogo.

---


```
func _process(delta: float) -> void:
	# Ignorar GameOver
	if GameManager.is_game_over: return
```

> **Objetivo principal**: Ignorar a execução do código se o jogo estiver em estado de GameOver

`func _process(delta: float) -> void`: Declara a função `_process` que é chamada a cada frame.

`if GameManager.is_game_over: return`: Verifica se o jogo está em estado de GameOver, se estiver, a função retorna imediatamente, impedindo qualquer atualização do spawner de mobs.

---

```
	# Incrementar temporizador
	time += delta
```

> **Objetivo principal**: Atualizar o tempo total decorrido desde o início do jogo

`time += delta`: Incrementa a variável `time` pelo tempo decorrido (`delta`) desde o último frame, isso mantém o controle do tempo total de jogo.

Exemplo: Se `delta` é 0.016 (aproximadamente 1/60 de segundo), após 1 segundo (60 frames), `time` será incrementado em 1.0.

---


```
	# Dificuldade linear (Linha verde)
	var spawn_rate = initial_spawn_rate + spawn_rate_per_minute * (time / 60.0)
```

> **Objetivo principal**: Calcular a taxa de spawn de mobs com base em uma dificuldade linear crescente

`var spawn_rate = initial_spawn_rate + spawn_rate_per_minute * (time / 60.0)`: Calcula a taxa de spawn atual de mobs. A taxa inicial (`initial_spawn_rate`) é incrementada por uma quantidade proporcional ao tempo decorrido (`time / 60.0`) multiplicada pela taxa de aumento de spawn (`spawn_rate_per_minute`).

Exemplo: Se `initial_spawn_rate` é 30, `spawn_rate_per_minute` é 30 e `time` é 120 segundos (2 minutos), `spawn_rate` será 30 + 30 * (120 / 60) = 30 + 60 = 90 mobs por minuto.

---

```
# Sistema de ondas (Linha rosa)
var sin_wave = sin((time * TAU) / wave_duration)
var wave_factor = remap(sin_wave, -1.0, 1.0, break_intensity, 1)
spawn_rate *= wave_factor
```

> **Objetivo principal**: Ajustar a taxa de spawn com base em um sistema de ondas usando uma função seno.

### Explicação Passo a Passo

#### 1. Onda Senoide (`sin_wave`)

```
var sin_wave = sin((time * TAU) / wave_duration)
```

- **Objetivo**: Calcular a onda senoide com base no tempo decorrido (`time`) e na duração da onda (`wave_duration`).
- **Constante `TAU`**: `TAU` é uma constante que representa 2 * PI (uma volta completa em radianos).

##### Como funciona:

- **Função senoide**: A função `sin` (seno) faz uma curva que sobe e desce como uma montanha-russa.
- **Cálculo**: Multiplicamos o tempo (`time`) por `TAU` e dividimos pela duração da onda (`wave_duration`).

##### Exemplo Simples:

- Imagine que `time` é 10 segundos e `wave_duration` é 20 segundos:
  ```
  sin_wave = sin((10 * TAU) / 20)
  ```
- Isso se transforma em `sin(TAU / 2)`:
  ```gdscript
  sin(PI)
  ```
- O valor de `sin(PI)` é 0.

**Como imaginar isso**: Pense em um balanço que vai para frente e para trás. Quando está no meio, está em 0.

#### 2. Fator da Onda (`wave_factor`)

```
var wave_factor = remap(sin_wave, -1.0, 1.0, break_intensity, 1)
```

- **Objetivo**: Ajustar a intensidade da onda, mapeando o valor da onda senoide (`sin_wave`) do intervalo [-1.0, 1.0] para um novo intervalo [`break_intensity`, 1].

##### Como funciona:

- **Função `remap`**: Mapeia o valor de uma faixa para outra, como ajustar o volume do som.
- **Intervalos**:
  - Valor da onda senoide (`sin_wave`) varia de -1 a 1.
  - Novo intervalo varia de `break_intensity` a 1.

##### Exemplo Simples:

- Se `sin_wave` é 0 e `break_intensity` é 0.5:
  ```
  wave_factor = remap(0, -1.0, 1.0, 0.5, 1)
  ```
- Isso resulta em 0.75, porque o valor 0 está exatamente no meio entre -1 e 1, e assim mapeado para o meio entre 0.5 e 1.

**Como imaginar isso**: Pense em um botão de volume que você gira para aumentar ou diminuir o som. Aqui estamos ajustando o volume da "dificuldade" dos inimigos.

#### 3. Ajuste da Taxa de Spawn (`spawn_rate`)

```
spawn_rate *= wave_factor
```

- **Objetivo**: Ajustar a taxa de spawn multiplicando pela `wave_factor`. Isso aplica a variação da onda senoide à taxa de spawn, criando um efeito de ondas de dificuldade.

##### Exemplo Simples:

- Se `spawn_rate` é 90 (mobs por minuto) e `wave_factor` é 0.75:
  ```
  spawn_rate *= 0.75
  ```
- A nova `spawn_rate` será:
  ```
  90 * 0.75 = 67.5 mobs por minuto
  ```

**Como imaginar isso**: Imagine que você está jogando um jogo e, às vezes, muitos inimigos aparecem de uma vez e, às vezes, poucos aparecem. Isso faz com que o jogo seja mais interessante porque não é sempre igual.

---

```
	# Aplicar dificuldade
	mob_spawner.mobs_per_minute = spawn_rate
```

> **Objetivo principal**: Atualizar a taxa de spawn do `MobSpawner` com a taxa calculada.

`mob_spawner.mobs_per_minute = spawn_rate`: Define a taxa de spawn do `MobSpawner` para a taxa calculada (`spawn_rate`). Isso ajusta a frequência com que os mobs são criados com base na dificuldade linear e nas ondas senoides.

Exemplo: Se `spawn_rate` foi calculada como 67.5 mobs por minuto, `mob_spawner.mobs_per_minute` será atualizado para 67.5.

---
