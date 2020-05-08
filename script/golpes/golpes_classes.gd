extends Node


class Ataque:
	
	#Caracteristicas ataque]
	var idAtaque
	var nome = ""
	var skillRatio = 100
	var custoMP = 0
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
	var golpeElemento= Constantes.PROPRIEDADE_DO_ATAQUE_NEUTRO
	var golpeTipoDano= Constantes.TIPO_DE_DANO_CONTUSIVO
	
	
	var animation
	var nodeAtaque
	
	#variaveis controle
	var atacados=[]
	var inimigoAtacado
	
	func _init(personagem=null):
		
		if(personagem!=null):
			if(personagem.equipeDireita != null):
				golpeTipoDano = personagem.equipeDireita.tipoDano
				golpeElemento = personagem.equipeDireita.elemento
	
class Ataque_Basico_Fisico_Corpo_a_Corpo extends Ataque:
	
	func _init(personagem):
		
		idAtaque=Constantes.ATAQUE_BASICO_FISICO_CORPO_A_CORPO
		distanciaDeSurgimentoDoGolpe = 50
