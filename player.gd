extends Area2D
# Esta señal se va a emitir cuando el jugador reciba un golpe
signal hit
# Velocidad del jugador en píxeles por segundo
@export var speed = 400 

# Variable para guardar el tamaño de la ventana del juego
var screen_size 
# Se ejecuta cuando el nodo entra a la escena
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()

# Esta función corre cada frame del juego
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO #Vector que indica hacia dónde se moverá el jugador
	
	# Revisa si se están presionando teclas y ajusta el vector según eso
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	# Si el jugador se está moviendo, normaliza el vector y multiplica por la velocidad
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()# Reproduce la animación
	else:
		$AnimatedSprite2D.stop()# Si no se mueve, pausa la animación
	
	# Mueve al jugador según el tiempo transcurrido (delta)
	position += velocity * delta
	# Evita que el jugador se salga de la pantalla
	position = position.clamp(Vector2.ZERO, screen_size)
	
	# Cambia la animación y orientación según el movimiento
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
	
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0

# Esta función se llama cuando el jugador choca con un enemigo (o algo con colisión)
func _on_body_entered(body: Node2D) -> void:
	hide() #el jugador se desaparece despues de recibir golpe.
	hit.emit()
	# Desactiva la colisión (de forma diferida para que no cause errores de física)
	$CollisionShape2D.set_deferred("disabled", true)

# Esta función sirve para reiniciar al jugador
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
