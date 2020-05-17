extends StaticBody2D


func _ready():
	add_to_group(Constantes.GRUPO_SOLIDO)
	set_process(true)


func _process(delta):
	pass

func interacao(personagem):
	
	aoInteragir(personagem)
	aoTerminarInteracao(personagem)
	
func aoInteragir(personagem):
	print("FOI")
	pass
	
func aoTerminarInteracao(personagem):
	pass
	
func aoPassarAoLado():
	pass
	
func aoPassarEmFrente():
	pass
	
func aoPassarAtraz():
	pass
