extends Area2D

func _on_body_entered(body):
	print("Algo entró al agua: ", body.name) # Esto saldrá en la consola abajo
	if body.has_method("entrar_al_agua"):
		body.entrar_al_agua()

# Esta se activa al SALIR del agua (corregido el nombre)
func _on_body_exited(body):
	if body.name == "Player":
		body.salir_del_agua()


func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	pass # Replace with function body.


func _on_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	pass # Replace with function body.
