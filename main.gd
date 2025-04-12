extends Node

@export var mob_scene: PackedScene# Aquí se guarda la escena del enemigo (mob.tscn)
var score # Puntuación del jugador

func _ready() -> void:
	#new_game()
	pass

func _process(delta: float) -> void:
	pass

# Se llama cuando el juego termina
func game_over() -> void:
	$ScoreTimer.stop()# Detiene el temporizador de puntaje
	$MobTimer.stop()# Detiene el temporizador que genera enemigos
	$HUD.show_game_over()# Muestra el mensaje de "Game Over" en pantalla
	$Music.stop() # Detiene la música de fondo
	$DeathSound.play() # Reproduce el sonido de muerte
	
# Esta función reinicia el juego desde cero	
func new_game():
	score = 0 # Reinicia el puntaje
	$Player.start($StartPosition.position) # Coloca al jugador en la posición inicial
	$StartTimer.start()# Inicia el temporizador de inicio (antes de que empiecen a aparecer enemigos)
	$HUD.update_score(score) # Muestra el puntaje actual (0 al empezar)
	$HUD.show_message("Get Ready")# Mensaje en pantalla para avisar que está por empezar
	get_tree().call_group("mobs", "queue_free")# Elimina todos los enemigos que haya en escena
	$Music.play()# Comienza la música de fondo

# Esta función se llama cada vez que el temporizador de enemigos (MobTimer) hace "timeout"
func _on_mob_timer_timeout() -> void:
	# Crea una nueva instancia del enemigo
	var mob = mob_scene.instantiate()

	# Elige una posición aleatoria sobre el Path2D
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Pone al enemigo en esa posición
	mob.position = mob_spawn_location.position

	# Le da una dirección al enemigo, girando respecto al camino
	var direction = mob_spawn_location.rotation + PI / 2

	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Le da una velocidad al enemigo en esa dirección
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

# Esta función se llama cada vez que el temporizador de score hace "timeout"
func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)

# Esta se llama cuando termina el temporizador de inicio (StartTimer)
func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
