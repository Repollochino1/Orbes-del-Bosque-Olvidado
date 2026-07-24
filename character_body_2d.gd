extends CharacterBody2D

@export var speed_normal = 200.0
@export var speed_nado = 90.0

var velocidad_actual = 200.0
var esta_nadando = false

@onready var animated_sprite = $AnimatedSprite2D
# Buscamos la Linterna de forma segura cuando arranca el juego
@onready var linterna = get_node_or_null("Linterna")

func _ready():
	velocidad_actual = speed_normal

func _physics_process(_delta):
	# 1. Obtener el vector de movimiento de las 4 direcciones
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Aplicar velocidad
	if direction != Vector2.ZERO:
		velocity = direction * velocidad_actual
		# Controlar animaciones en movimiento y rotación de linterna
		actualizar_animacion(direction)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, velocidad_actual)
		# Volver a animación quieto (Idle) si no se mueve
		poner_animacion_quieto()

	move_and_slide()

# Decide la animación y gira la linterna de forma segura si existe
func actualizar_animacion(dir: Vector2):
	# Priorizar el movimiento horizontal si se mueve en diagonal
	if abs(dir.x) >= abs(dir.y):
		if dir.x > 0:
			animated_sprite.play("walk_right")
			if linterna: linterna.rotation_degrees = 0 # Apunta a la derecha
		else:
			animated_sprite.play("walk_left")
			if linterna: linterna.rotation_degrees = 180 # Apunta a la izquierda
	else:
		if dir.y > 0:
			animated_sprite.play("walk_down")
			if linterna: linterna.rotation_degrees = 90 # Apunta hacia abajo
		else:
			animated_sprite.play("walk_up")
			if linterna: linterna.rotation_degrees = 270 # Apunta hacia arriba

# Función para cuando el jugador se detiene
func poner_animacion_quieto():
	# Si se detiene, se queda en el primer frame de la última animación que usó
	animated_sprite.stop()
	animated_sprite.frame = 0

# Funciones que llamará el área de agua (ZonaAgua)
func entrar_al_agua():
	esta_nadando = true
	velocidad_actual = speed_nado
	# Cambiar el color del sprite para simular que está sumergido
	animated_sprite.modulate = Color(0.6, 0.8, 1.0, 1.0) # Tono azulado

func salir_del_agua():
	esta_nadando = false
	velocidad_actual = speed_normal
	# Restaurar color original del personaje al salir
	animated_sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
