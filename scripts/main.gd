extends Node

@export var mob_scene: PackedScene
var score

func adjust_mob_path():
	# Obtiene el tamaño del área visible del juego.
	var viewport_size = get_viewport().get_visible_rect().size
	var mob_path = $MobPath as Path2D
	var curve = mob_path.curve as Curve2D

	# Limpiar y redefinir los puntos
	curve.clear_points()

	var w = viewport_size.x
	var h = viewport_size.y

	# Definir los 5 puntos para un cuadrado/rectángulo que rodea la pantalla
	curve.add_point(Vector2(0, 0))     # Esquina superior izquierda
	curve.add_point(Vector2(w, 0))     # Esquina superior derecha
	curve.add_point(Vector2(w, h))     # Esquina inferior derecha
	curve.add_point(Vector2(0, h))     # Esquina inferior izquierda
	curve.add_point(Vector2(0, 0))     # Volver a la inicial para cerrar el loop

func _ready():
	$Joystick.hide()
	adjust_mob_path()


func delete_mobs():
	get_tree().call_group('mobs', 'queue_free')


func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Joystick.hide()
	$Music.stop()
	$DeathSound.play()
	delete_mobs()


func new_game():
	var os_name = OS.get_name()
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	delete_mobs()
	$Music.play()
	if os_name == "Android" or os_name == "iOS":
		$Joystick.show()


func _on_mob_timer_timeout() -> void:
	# Crear instancia de Mob Scene
	var mob = mob_scene.instantiate()

	# Elegir localización aleatoria en Path2D
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Setear la posición del enemigo aleatoriamente
	mob.position = mob_spawn_location.position

	# Setear la dirección del enemigo perpendicular a la dirección del Path
	var direction = mob_spawn_location.rotation + PI / 2

	# Añadir aleatoriedad a la dirección
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Elegir la velocidad del enemigo
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Crear el enemigo añadiendolo a la escena principal
	add_child(mob)


func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)


func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
