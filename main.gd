extends Node2D

@export var orbe_escena: PackedScene = preload("res://orbes.tscn")
@export var enemigo_escena: PackedScene = preload("res://enemigo.tscn")
@export var portal_escena: PackedScene = preload("res://portal.tscn")

var orbes_totales = 4
var orbes_recolectados = 0
var juego_terminado = false

@onready var texto_contador = $InterfazUI/ContadorOrbes
@onready var menu_game_over = $InterfazUI/MenuGameOver
@onready var menu_victoria = $InterfazUI/MenuVictoria
@onready var screamer = $InterfazUI/Screamer
@onready var sonido_screamer = $SonidoScreamer

var puntos_libres_restantes = []

func _ready():
	randomize()
	juego_terminado = false
	get_tree().paused = false
	
	if menu_game_over:
		menu_game_over.visible = false
	if menu_victoria:
		menu_victoria.visible = false
	if screamer:
		screamer.visible = false
		
	actualizar_interfaz()
	generar_orbes_aleatorios()

func generar_orbes_aleatorios():
	var puntos_disponibles = $PuntosAparicion.get_children()
	if puntos_disponibles.size() < orbes_totales:
		print("Error: Necesitas poner más Marker2D en PuntosAparicion.")
		return
		
	for i in range(orbes_totales):
		var indice_al_azar = randi() % puntos_disponibles.size()
		var punto_elegido = puntos_disponibles[indice_al_azar]
		puntos_disponibles.remove_at(indice_al_azar)
		
		var nuevo_orbe = orbe_escena.instantiate()
		nuevo_orbe.global_position = punto_elegido.global_position
		nuevo_orbe.recolectado.connect(_on_orbe_recolectado)
		add_child(nuevo_orbe)
	
	puntos_libres_restantes = puntos_disponibles

func _on_orbe_recolectado():
	orbes_recolectados += 1
	actualizar_interfaz()
	if orbes_recolectados >= orbes_totales:
		invocar_enemigo_final()

func actualizar_interfaz():
	if texto_contador:
		texto_contador.text = "Orbes: " + str(orbes_recolectados) + " / " + str(orbes_totales)

func invocar_enemigo_final():
	if texto_contador:
		texto_contador.text = "¡ALGO SE DESPERTÓ... BUSCA EL PORTAL!"
	
	print("¡Todos los orbes recolectados!")
	
	var nuevo_enemigo = enemigo_escena.instantiate()
	nuevo_enemigo.global_position = Vector2(960, 540)
	add_child.call_deferred(nuevo_enemigo)
	
	if portal_escena and puntos_libres_restantes.size() > 0:
		var nuevo_portal = portal_escena.instantiate()
		var indice_portal = randi() % puntos_libres_restantes.size()
		var punto_portal = puntos_libres_restantes[indice_portal]
		nuevo_portal.global_position = punto_portal.global_position
		add_child.call_deferred(nuevo_portal)
		print("Portal generado en: ", punto_portal.global_position)

# --- LÓGICA DE DERROTA ---
func game_over():
	if juego_terminado: return
	juego_terminado = true
	
	print("¡El jugador fue atrapado!")
	if screamer:
		screamer.visible = true
	if sonido_screamer:
		sonido_screamer.play()
		
	await get_tree().create_timer(1.5).timeout
	
	if screamer:
		screamer.visible = false
		
	if menu_game_over:
		menu_game_over.visible = true
	
	get_tree().paused = true

# --- LÓGICA DE VICTORIA ---
func victoria():
	if juego_terminado: return
	juego_terminado = true
	
	print("¡Victoria registrada!")
	if texto_contador:
		texto_contador.text = "¡HAS ESCAPADO CON ÉXITO!"
		
	if menu_victoria:
		menu_victoria.visible = true
	
	get_tree().paused = true

# --- BOTÓN DE REINICIAR (PANTALLA GAME OVER) ---
func _on_boton_reiniciar_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

# --- BOTÓN DE VOLVER A JUGAR (PANTALLA VICTORIA) ---
func _on_boton_victoria_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
