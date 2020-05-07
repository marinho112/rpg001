extends Node

class personagem:
	
	#salvar no DB
	var ID 
	var nome
	var lv =1
	var classe =0
	var esferas=5
	var experiencia
	
	var hpMaximo
	var mpMaximo
	
	var forca = 10
	var agilidade =10
	var destreza =10
	var vitalidade =10 
	var inteligencia=10
	var will=10
	
	var forcaBonus 
	var agilidadeBonus 
	var destrezaBonus 
	var vitalidadeBonus 
	var inteligenciaBonus
	var willBonus
	
	var raca
	var raca_secundaria
	var propriedade
	
	# Salvar no save
	var posicaoCombate
	var hpAtual
	var mpAtual
		
	var esferasAtaque  = 1
	var esferasDefesa  = 1
	var esferasEsquiva  = 1
	var esferasAcerto  = 1
	
	var status = []
	var habilidadesOfensivas=[]
	var habilidadesPassivas=[]
	
	#Apenas Calculado
	var dano
	var danoMagico
	var danoDistancia
	var defesa
	var defesamagica
	var acerto
	var esquiva
	var bloqueio
	var acertoMagico
	var esquivaMagica
	var bloqueioMagico
	
	var danoBonus
	var danoMagicoBonus
	var danoDistanciaBonus
	var defesaBonus
	var defesamagicaBonus
	var acertoBonus
	var esquivaBonus
	var bloqueioBonus
	var acertoMagicoBonus
	var esquivaMagicaBonus
	var bloqueioMagicoBonus
	
	
	func zerarBonus():
		
		forcaBonus = 0
		agilidadeBonus =0
		destrezaBonus =0
		vitalidadeBonus =0 
		inteligenciaBonus=0
		willBonus=0
		
		danoBonus=0
		danoMagicoBonus=0
		danoDistanciaBonus=0
		defesaBonus=0
		defesamagicaBonus=0
		acertoBonus=0
		esquivaBonus=0
		bloqueioBonus=0
		acertoMagicoBonus=0
		esquivaMagicaBonus=0
		bloqueioMagicoBonus=0
		
	func _init(lv=1,classe=0,forca=10,agi=10,des=10,vit=10,inte=10,will=10):
		
		forca += (randi()%100)
		des += (randi()%100)
		agi += (randi()%100)
		vit += (randi()%100)
		#Atributos variam de 1 ~100
		
		zerarBonus()
		
		self.lv=lv
		self.classe=classe
		self.forca=forca
		self.agilidade=agi
		self.destreza=des
		self.vitalidade=vit
		self.inteligencia=inte
		self.will=will
		
		calculaAtributos()
		
		#Atributos secundarios variam de 1~300 + 0~200 nos itens 
	func calculaAtributos():
		
		var divisor = 5000.0
		
		dano = int(((forca+forcaBonus)/10.0) + ((forca+forcaBonus)*(destreza+destrezaBonus)/divisor))
		danoMagico = int(((inteligencia+inteligenciaBonus)/10.0) + ((inteligencia+inteligenciaBonus)*(will+willBonus)/divisor))
		danoDistancia = int(((destreza+destrezaBonus)/10.0) + ((destreza+destrezaBonus)*(forca+forcaBonus)/divisor))
		defesa = int(((vitalidade+vitalidadeBonus)/10.0) + ((vitalidade+vitalidadeBonus)*(agilidade+agilidadeBonus)/divisor))
		defesamagica = int(((will+willBonus)/10.0) + ((vitalidade+vitalidadeBonus)*(will+willBonus)/divisor))
		acerto=int(((destreza+destrezaBonus)/10.0) + ((destreza+destrezaBonus)*(agilidade+agilidadeBonus)/divisor))
		acertoMagico=int(((destreza+destrezaBonus)/10.0) + ((destreza+destrezaBonus)*(inteligencia+inteligenciaBonus)/divisor))
		esquiva=int(((agilidade+agilidadeBonus)/10.0) + ((destreza+destrezaBonus)*(agilidade+agilidadeBonus)/divisor))
		esquivaMagica=int(((agilidade+agilidadeBonus)/10.0) + ((inteligencia+inteligenciaBonus)*(agilidade+agilidadeBonus)/divisor))
		bloqueio=int(((destreza+destrezaBonus)/10.0)+ ((destreza+destrezaBonus) * (forca+forcaBonus)/divisor))
		bloqueioMagico=int(((destreza+destrezaBonus)/10)+ ((destreza+destrezaBonus) * (will+willBonus)/divisor))
		
					
class personagemParty extends personagem:
	
	var menu=[]
	
	var equipeCabeca
	var equipeCorpo
	var equipeDireita
	var equipeEsquerda
	var equipeSapato
	var equipeAcessorio1
	var equipeAcessorio2
	var equipeAcessorio3
	var equipeAcessorio4
	
	var SextaEsferaDesbloqueada=false
	
class personagemMob extends personagem:
	
	var caracteristicas = []
	
	#Salvar no DB 
	var ai
	var node
	var tamanho 
	
	func calculaAtributos():
		.calculaAtributos()
		if(tamanho != null):
			bloqueio = int(bloqueio/(5.0 - tamanho))
			esquiva = int(esquiva/(tamanho + 1.0))
	
class elementoMenu:
	var texto
	var tipo
	var proximo
	var extra
	
	
	func _init(texto,tipo,proximo=null,extra=null):
		self.texto=texto
		self.tipo=tipo
		set_proximo(proximo)
		set_extra(extra)
	func set_proximo(proximo):
		self.proximo=proximo
	
	func set_extra(extra):
		self.extra=extra


