extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var gravity: int = ProjectSettings.get("physics/2d/default_gravity")
@export var speed = 100

# Variable para indicar si vamos hacia delante (1) o atrás (-1)
var sentido = 1

func _ready() -> void:
	$ani_terrorista.play("idle") 
	
	
func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	if is_on_wall():
		sentido = -sentido

	if sentido ==1 && $detector_derecho.is_colliding():
		velocity.x = speed
		$ani_terrorista.flip_h = false
	else:
		sentido = -1
	
	if sentido == -1 && $detector_izquierdo.is_colliding():
		velocity.x = -speed
		$ani_terrorista.flip_h = true
	else:
		sentido = 1
	move_and_slide()



func _on_area_2d_body_entered(body: Node2D) -> void:
		if body.is_in_group("jugadores"):
			body.morir()
