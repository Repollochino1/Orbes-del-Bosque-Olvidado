extends Area2D

# Señal personalizada que escuchará el script principal (main.gd)
signal recolectado

# Referencia al nodo de sprites animados
@onready var animacion = $AnimatedSprite2D

func _ready():
	# Verificamos que el nodo exista y reproducimos la animación "orbe"
	if animacion:
		animacion.play("orbe")
	else:
		print("Error: No se encontró el nodo AnimatedSprite2D. Revisa si se llama diferente.")

func _on_body_entered(body: Node2D) -> void:
	# Verificamos si lo que entró en el área es el jugador
	if body.name == "Player" or body.has_method("entrar_al_agua"):
		# Emitimos la señal para que main.gd sepa que recogimos uno
		emit_signal("recolectado")
		
		# Hacemos que el orbe desaparezca inmediatamente del mapa
		queue_free()
