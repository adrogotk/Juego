extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$ani_moneda.play("giro")


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugadores"):
		body.add_moneda()
		queue_free()
