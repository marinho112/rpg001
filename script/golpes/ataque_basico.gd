extends Node2D

var lista=[]
var listaHits=[]
var estaNaLista=false
var numHits = 1
var deleta = false


func _ready():
	pass # Replace with function body.

func golpeia(area):
	estaNaLista=false
	for i in lista:
		if(i==area):
			estaNaLista=true
	if(!estaNaLista):
		lista.append(area)
		listaHits.append(0)
		
		#$timerHit.play()
		



func _on_ataque_simples_area_entered(area):
	
	
	if(is_in_group(Constantes.GRUPO_ALIADOS)):
		if(area.is_in_group(Constantes.GRUPO_INIMIGO)):
			if(area.bloqueado<=0):
				golpeia(area)
				
	elif(is_in_group(Constantes.GRUPO_INIMIGO)):
		if(area.is_in_group(Constantes.GRUPO_ALIADOS)):
			if(area.bloqueado<=0):
				golpeia((area))
				
	pass # Replace with function body.


func _on_timer_timeout():
	deleta = true
	for i in len(lista):
		
		if((listaHits[i]<numHits)):
			get_parent().calculaAcerto(lista[i])
			listaHits[i]+=1
			deleta=false
			
	
	if(deleta and (!is_visible())):
		
		queue_free()
	
	deleta=false
	pass # Replace with function body.
