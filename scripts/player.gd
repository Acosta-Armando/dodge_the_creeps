extends Area2D
signal hit # Esto define una señal personalizada llamada "hit" que nuestro player emitirá (enviará) cuando colisione con un enemigo.

# Utilizar la palabra clave export en la primera variable speed nos permite asignar su valor desde el Inspector.
@export var speed = 400
var screen_size
@export var acceleration = 10
var current_velocity = Vector2.ZERO

#La función _ready() se llama cuando un nodo entra en la escena, este es un buen momento para averiguar el tamaño de la ventana de juego:
func _ready():
	screen_size = get_viewport_rect().size
	hide() # Ocultar

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

# _process() se llama en cada frame, así que la usaremos para actualizar elementos del juego que esperamos que cambien a menudo. Para el jugador haremos lo siguiente:
# -Comprobar entradas.
# -Moverse en la dirección dada.
# -Reproducir la animación apropiada.
func _process(delta):
	var target_velocity = Vector2.ZERO # La velocidad que queremos alcanzar (basada en la entrada del usuario)
	
	# === 1. Determinar la Velocidad Deseada (Target) ===
	if Input.is_action_pressed('move_left'):
		target_velocity.x -= 1
	if Input.is_action_pressed('move_right'):
		target_velocity.x += 1
	if Input.is_action_pressed('move_up'):
		target_velocity.y -= 1
	if Input.is_action_pressed('move_down'):
		target_velocity.y += 1
	
	# Normaliza si es necesario y aplica la velocidad máxima
	if target_velocity.length() > 0:
		target_velocity = target_velocity.normalized() * speed
		
		# === 2. INTERPOLACIÓN LINEAL (LERP) para suavizar el movimiento ===
		# current_velocity se moverá suavemente hacia target_velocity
		current_velocity = current_velocity.lerp(target_velocity, acceleration * delta)
		
		$AnimatedSprite2D.play()
	else:
		# Si no hay entrada, interpola la velocidad actual hacia Vector2.ZERO (frenado suave)
		current_velocity = current_velocity.lerp(Vector2.ZERO, acceleration * delta)
		$AnimatedSprite2D.stop()

	# === 3. Aplicar Movimiento y Clamping ===
	
	# Usar la current_velocity interpolada para el movimiento
	position += current_velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	# === 4. Lógica de Animación (basada en la velocidad interpolada) ===
	
	# Para la animación, verifica si hay movimiento significativo
	if current_velocity.length() > 5: # Usamos un valor pequeño para evitar la animación cuando la velocidad es casi cero
		if current_velocity.x != 0:
			$AnimatedSprite2D.animation = 'walk'
			$AnimatedSprite2D.flip_v = false
			# La dirección de flip basada en la current_velocity
			$AnimatedSprite2D.flip_h = current_velocity.x < 0
		else:
			$AnimatedSprite2D.animation = 'up'
			# La dirección de flip basada en la current_velocity
			$AnimatedSprite2D.flip_v = current_velocity.y > 0
	else:
		# Asegura que la animación se detenga completamente cuando el personaje esté quieto
		$AnimatedSprite2D.stop()


func _on_body_entered(body: Node2D) -> void:
	hit.emit()
	hide()
	$CollisionShape2D.set_deferred('disabled', true)
