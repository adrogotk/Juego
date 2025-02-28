extends CharacterBody2D

@export var gravity_scale=2
@export var speed = 500
@export var acceleration = 600
@export var friction = 1500
@export var jump_force = -700
@export var air_acceleration = 2000
@export var air_friction = 700
@onready var ani_policia=$ani_policia
@onready var contador: Control = $CanvasLayer/Contador

func _ready() -> void:
	add_to_group("jugadores")
	contador.actualizar(0)
	
func apply_gravity(delta):
	if not is_on_floor():
		velocity+=get_gravity() * delta * gravity_scale

func handle_acceleration(input_axis, delta):
	if not is_on_floor(): return
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, speed*input_axis, acceleration*delta)

func apply_friction(input_axis, delta):
	if input_axis==0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, friction*delta)

func handle_jump():
	if is_on_floor():
		if Input.is_action_pressed("saltar"):
			velocity.y = jump_force

func handle_air_acceleration(input_axis, delta):
	if is_on_floor(): return
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, speed*input_axis, air_acceleration *delta)

func update_animation(input_axis):
	if input_axis !=0:
		ani_policia.speed_scale = velocity.length()/100
		ani_policia.flip_h = (input_axis<0)
		ani_policia.play("run")
	elif not is_on_floor():
		ani_policia.play("jump")
	else:
		ani_policia.speed_scale=1
		ani_policia.play("idle")

func _physics_process(delta: float) -> void:
	var input_axis = Input.get_axis("mover_izquierda","mover_derecha")
	apply_gravity(delta)
	handle_acceleration(input_axis, delta)
	apply_friction(input_axis, delta)
	handle_jump()
	handle_air_acceleration(input_axis, delta)
	update_animation(input_axis)
	move_and_slide()
	
func add_moneda():
	Global.contador+=1
	print(Global.contador)
	get_tree().reload_current_scene()
	

func morir():
	set_physics_process(false)
	$ani_policia.play("die")
	$tiempo.start()
	await $tiempo.timeout
	get_tree().change_scene_to_file("res://menu/menu.tscn")
