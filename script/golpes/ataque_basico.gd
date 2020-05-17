extends Node2D

var lista=[]
var listaHits=[]
var listaAcerto=[]
var estaNaLista=false
var numHits = 1
var deleta = false
var hitContado = false


func _ready():
	set_process(true)
	pass # Replace with function body.

func _process(delta):
	if(get_parent()!=null):
		if(not hitContado):
			hitContado=true
			get_parent().diminuiEsperaAtaque()

func golpeia(area):
	estaNaLista=false
	for i in lista:
		if(i==area):
			estaNaLista=true
	if(!estaNaLista):
		lista.append(area)
		listaHits.append(0)
		listaAcerto.append(get_parent().calculaAcerto(area))
		
		#$timerHit.play()
		

func virar(virado):
	$AnimatedSprite.set_flip_h(!virado)
	$AnimationPlayer.play("golpe")

func _on_ataque_simples_area_entered(area):
	
	
	if(is_in_group(Constantes.GRUPO_ALIADOS)and !(area.is_in_group(Constantes.GRUPO_ATAQUE))):
		if(area.is_in_group(Constantes.GRUPO_INIMIGO)):
			if((area.bloqueado<=0)and (!get_parent().voltando)and (!area.taMorto)):
				golpeia(area)
				
	elif(is_in_group(Constantes.GRUPO_INIMIGO)and !(area.is_in_group(Constantes.GRUPO_ATAQUE))):
		if(area.is_in_group(Constantes.GRUPO_ALIADOS)):
			if((area.bloqueado<=0)and (!get_parent().voltando)and (!area.taMorto)):
				golpeia((area))
				
	pass # Replace with function body.


func _on_timer_timeout():
	deleta = true
	for i in len(lista):
		
		if((listaHits[i]<numHits)):
			get_parent().encaminhaAcerto(listaAcerto[i],lista[i])
			listaHits[i]+=1
			if(listaAcerto[i]==0):
				listaHits[i] = numHits
			deleta=false
			
	
	if(deleta and (!is_visible())):
		
		queue_free()
	
	deleta=false
	pass # Replace with function body.
