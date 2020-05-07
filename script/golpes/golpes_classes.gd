extends Node


class Ataque:
	
	#Caracteristicas ataque]
	var idAtaque
	var atacados=[]
	var inimigoAtacado
	var ataquesRealizados =0 # Numero de movimentos para ataque
	var golpesRealizados = 0 
	var golpesPorAtaque=1 #Numero animações de ataque
	var intervaloHits=0.01
	var hitsPorGolpeRaiz=1 # efeitos de golpe por animação de ataque
	var hitsPorGolpe=0
	var hitsSecundariosPorGolpe=1 # hits por efeitos de golpe
	var distanciaDeSurgimentoDoGolpe = 5
	
	#Caracteristicas Danos
	
	var golpeBloqueavel = true
	var golpeEsquivavel = true
	var golpeDistancia= false
	var golpeMagico = false
	var golpeElemento=0
	var golpeTipoDano=0
	
class Ataque_Basico_Fisico_Corpo_a_Corpo extends Ataque:
	
	func _init():
		idAtaque=10000
		distanciaDeSurgimentoDoGolpe = 50
