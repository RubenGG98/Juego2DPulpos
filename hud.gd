# Este nodo se usa para elementos de UI que se mantienen encima de todo
extends CanvasLayer
# Señal personalizada que emite cuando el jugador presiona el botón de empezar
signal start_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Esta función muestra un mensaje temporal en pantalla
func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

# Muestra el mensaje "Game Over" y después el texto de inicio con el botón
func show_game_over():
	show_message("Game Over")# Muestra mensaje de fin
	await $MessageTimer.timeout# Espera a que el temporizador termine

	$Message.text = "Dodge the Creeps!"# Texto de inicio
	$Message.show()# Lo muestra de nuevo
	
	await get_tree().create_timer(1.0).timeout # Espera 1 segundo
	$StartButton.show() # Muestra el botón para volver a jugar

# Actualiza el puntaje en el label de la esquina
func update_score(score):
	$ScoreLabel.text = str(score)

# Cuando se presiona el botón de inicio, lo oculta y emite la señal "start_game"
func _on_start_button_pressed() -> void:
	$StartButton.hide()
	start_game.emit()

# Oculta el mensaje cuando se agota el tiempo del temporizador
func _on_message_timer_timeout() -> void:
	$Message.hide()
