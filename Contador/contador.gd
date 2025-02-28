extends Control


func _ready():
	call_deferred("actualizar", Global.contador)

func actualizar(monedas:int):
	$HBox/lbl_contador.text = str(monedas)
