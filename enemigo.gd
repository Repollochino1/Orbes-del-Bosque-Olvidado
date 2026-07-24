extends CharacterBody2D

@export var velocidad_persecucion = 120.0
@export var velocidad_patrulla = 40.0

@onready var raycast_vista = $Vista
@onready var sprite_animado = $AnimatedSprite2D
@onready var area_damage = $AreaDamage # <-- El nuevo nodo Area2D

var player: CharacterBody2D = null
var jugador_avistado = false
var esta_apareciendo = true 

# Variables para el patrullaje aleatorio
var direccion_patrulla = Vector2.ZERO
var tiempo_cambio_direction = 0.0

func _ready():
	player = get_tree().current_scene.get_node_or_null("Player")
	
	# Conexión automática y segura de la colisión por código
	if area_damage:
		if area_damage.body_entered.is_connected(_on_area_damage_body_entered):
			area_damage.body_entered.disconnect(_on_area_damage_body_entered)
		area_damage.body_entered.connect(_on_area_damage_body_entered)
	else:
		print("Error: No se encontró el nodo 'AreaDamage' en el enemigo.")
		
	ejecutar_introduccion_enemigo()

func ejecutar_introduccion_enemigo():
	if sprite_animado:
		sprite_animado.play("summon Appear")
		await get_tree().create_timer(1.0).timeout
		
		sprite_animado.play("summon")
		await get_tree().create_timer(1.0).timeout
		
		sprite_animado.play("summon Idle")
		esta_apareciendo = false
		elegir_nueva_direccion_patrulla()

func _physics_process(delta):
	if esta_apareciendo or player == null or raycast_vista == null:
		return

	raycast_vista.target_position = raycast_vista.to_local(player.global_position)
	comprobar_vision()

	if jugador_avistado:
		# --- COMPORTAMIENTO: PERSECUCIÓN ---
		var direccion = (player.global_position - global_position).normalized()
		velocity = direccion * velocidad_persecucion
		voltear_sprite(direccion.x)
		
		if sprite_animado.animation != "attack" and global_position.distance_to(player.global_position) < 45:
			sprite_animado.play("attack")
		elif sprite_animado.animation != "attack":
			sprite_animado.play("summon Idle")
	else:
		# --- COMPORTAMIENTO: PATRULLA ALEATORIA ---
		if sprite_animado.animation != "attack":
			sprite_animado.play("summon Idle")
			
		tiempo_cambio_direction -= delta
		if tiempo_cambio_direction <= 0:
			elegir_nueva_direccion_patrulla()
			
		velocity = direccion_patrulla * velocidad_patrulla
		voltear_sprite(direccion_patrulla.x)
		
	move_and_slide()

func comprobar_vision():
	if raycast_vista and raycast_vista.is_colliding():
		var objeto_chocado = raycast_vista.get_collider()
		if objeto_chocado == player:
			jugador_avistado = true
			return
	jugador_avistado = false

func elegir_nueva_direccion_patrulla():
	var angulo_al_azar = randf_range(0, 2 * PI)
	direccion_patrulla = Vector2(cos(angulo_al_azar), sin(angulo_al_azar)).normalized()
	tiempo_cambio_direction = randf_range(1.5, 3.0)

func voltear_sprite(dir_x):
	if dir_x < 0:
		sprite_animado.flip_h = true
	elif dir_x > 0:
		sprite_animado.flip_h = false

# ¡ESTA ES LA SEÑAL CLAVE! Se activa en el instante exacto del impacto físico
func _on_area_damage_body_entered(body: Node2D) -> void:
	# Si lo que entró al área es el jugador, mandamos el Game Over de inmediato
	if body.name == "Player":
		print("¡Contacto físico detectado con el Player!")
		var mapa_main = get_tree().current_scene
		if mapa_main and mapa_main.has_method("game_over"):
			mapa_main.game_over()
