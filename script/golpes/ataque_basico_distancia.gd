extends Node2D

var lista=[]
var listaHits=[]
var listaAcerto=[]
var estaNaLista=false
var numHits = 1
var deleta = false
var alvo
var rotacionar = true 
var speed = 1000
var EsbarraFrente = true

func _ready():
	set_process(true)
	pass # Replace with function body.

func _process(delta):
	if(alvo != null):
		var alvo_position=alvo.get_global_position()
		var self_position= get_global_position()
		var angulo = Vector2(0,0)
		var catetoX = alvo_position.x - self_position.x
		var catetoY = alvo_position.y - self_position.y
		var hipotenusa = (catetoX*catetoX) + (catetoY+catetoY)
		hipotenusa = sqrt(hipotenusa) 
		var s = catetoY / hipotenusa
		var c = catetoX / hipotenusa
		if(rotacionar):
			if(get_parent().is_in_group(Constantes.GRUPO_INIMIGO)):
				set_rotation(s)
			else:
				set_rotation(-s)
			
			
			rotacionar=false
		
		
		if(self_position.x > alvo_position.x):
			self_position.x -= (delta* speed * -c)
		else:
			self_position.x += (delta* speed * c)
			
		if(self_position.y > alvo_position.y):
			self_position.y -= (delta* speed * -s)
		else:
			self_position.y += (delta* speed * s)
		
		set_global_position(self_position)
	else:
		alvo= get_parent().ataque.inimigoAtacado
		
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
	$Sprite.set_flip_h(virado)

func _on_ataque_simples_area_entered(area):
	
	
	if(is_in_group(Constantes.GRUPO_ALIADOS) and !(area.is_in_group(Constantes.GRUPO_ATAQUE))):
		if(area.is_in_group(Constantes.GRUPO_INIMIGO)):
			if(EsbarraFrente or (area == alvo)):
				if(area.bloqueado<=0):
					golpeia(area)
					set_visible(false)
					speed=0
				
	elif(is_in_group(Constantes.GRUPO_INIMIGO)and !(area.is_in_group(Constantes.GRUPO_ATAQUE))):
		if(area.is_in_group(Constantes.GRUPO_ALIADOS)):
			if(EsbarraFrente or (area == alvo)):
				if(area.bloqueado<=0):
					golpeia((area))
					set_visible(false)
					speed=0
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
		get_parent().diminuiEsperaAtaque()
		queue_free()
	
	deleta=false
	pass # Replace with function body.
