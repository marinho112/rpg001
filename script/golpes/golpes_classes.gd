extends Node


func getAtaquePorId(id,personagem):
	
	match(id):
		Constantes.ATAQUE_BASICO_FISICO_CORPO_A_CORPO:
			return Ataque_Basico_Fisico_Corpo_a_Corpo.new(personagem)
		Constantes.ATAQUE_BASICO_FISICO_DISTANCIA:
			return Ataque_Basico_Fisico_Distancia.new(personagem)
		Constantes.ATAQUE_BASICO_MAGICO_CORPO_A_CORPO:
			return null
		Constantes.ATAQUE_BASICO_MAGICO_DISTANCIA:
			return null
	return null

class Ataque:
	
	#Caracteristicas ataque]
	var idAtaque
	var nome = ""
	var custoMP = 0
	var ataquesRealizados =0 
	var golpesRealizados = 0 
	var golpesPorAtaque=1 #Numero animações de ataque
	var intervaloHits=0.01
	var hitsPorGolpeRaiz=1 # efeitos de golpe por animação de ataque
	var hitsPorGolpe=0
	var hitsSecundariosPorGolpe=1 # hits por efeitos de golpe
	var distanciaDeSurgimentoDoGolpe = 5
	
	
	# 0-1 | Seleciona Inimigo - Seleciona Aliado 
	# 0-2 | Não pode mudar de lado | Pode mudar de lado
	# 0-4 | So pode selecionar cada alvo uma vez | Seleção de alvos repetidos
	# 8 | Seleciona todos os inimigos
	# 9 | Seleciona todos os aliados
	# 10 | Seleciona Todos 
	
	var tipoSelecao = 0
	var numSelecao = 1
	# 0 == Ataque
	var tipoAcao = 0
	var esperarAtaque =false
	
	var nodeGolpe = "res://nodes/golpes/ataque_simples.tscn"
	#Caracteristicas Danos
	
	var golpeBloqueavel = true
	var golpeEsquivavel = true
	var golpeDistancia= false
	var golpeMagico = false
	var golpeElemento= Constantes.PROPRIEDADE_DO_ATAQUE_NEUTRO
	var golpeTipoDano= Constantes.TIPO_DE_DANO_CONTUSIVO
	
	#Bonus
	var skillRatio = 100
	var bonusDanoAtaque = 0
	var bonusAcertoAtaque = 0
	var bonusEsferaAcerto = 0
	
	
	#Penalidade
	var penalDefRatio = 0
	var penalDefesaAtaque = 0
	var penalEsquivaAtaque = 0
	var penalBloqueioAtaque = 0
	var penalEsferaDefesa = 0
	var penalEsferaEsquiva = 0
	
	
	var animation
	var nodeAtaque
	
	var listaStatus=[]
	var listaChanceStatus = []
	
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

class Ataque_Basico_Fisico_Distancia extends Ataque:
	
	func _init(personagem):
		esperarAtaque=true
		idAtaque=Constantes.ATAQUE_BASICO_FISICO_DISTANCIA
		nodeGolpe="res://nodes/golpes/ataque_simples_Distancia.tscn"
		distanciaDeSurgimentoDoGolpe = 10
		golpeDistancia= true
