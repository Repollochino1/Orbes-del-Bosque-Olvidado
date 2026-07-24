extends Area2D

func _ready() -> void:
	# Conexión automática y segura de la colisión física en Godot 4
	if body_entered.is_connected(_on_body_entered):
		body_entered.disconnect(_on_body_entered)
	body_entered.connect(_on_body_entered)
	
	print("Portal de escape listo y esperando al jugador...")

# Esta función se ejecuta sola cuando el jugador toca el área del portal
func _on_body_entered(body: Node2D) -> void:
	# Verificamos si el cuerpo que entró se llama exactamente "Player"
	if body.name == "Player":
		print("¡El jugador entró al portal!")
		
		# Buscamos la escena raíz del mapa (Main) para activar la pantalla de fin/victoria
		var mapa_main = get_tree().current_scene
		if mapa_main and mapa_main.has_method("victoria"):
			mapa_main.victoria()
		else:
			print("Error: No se encontró la función 'victoria' en el script principal del mapa.")
