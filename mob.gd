# Este enemigo está basado en física (puede chocar, moverse solo, etc.)
extends RigidBody2D


# Esta función se ejecuta cuando el nodo entra por primera vez en la escena
func _ready() -> void:
	# Obtiene una lista con todos los nombres de animaciones del sprite (por ejemplo: "fly", "swim", etc.)
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	# Elige una animación al azar de esa lista y la asigna
	$AnimatedSprite2D.animation = mob_types.pick_random()
	# Inicia la animación para que se vea el movimiento
	$AnimatedSprite2D.play()


func _process(delta: float) -> void:
	pass

# Esta función se activa cuando el enemigo sale de la pantalla (gracias al nodo VisibleOnScreenNotifier2D)
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()# Elimina el enemigo para no dejarlo ocupando memoria innecesariamente
