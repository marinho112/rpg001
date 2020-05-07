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
	
	
	
	func _init(lv=1,classe=0,forca=10,agi=10,des=10,vit=10,inte=10,will=10):
		
		forca = (randi()%100)
		des = (randi()%100)
		agi = (randi()%100)
		vit = (randi()%100)
		#Atributos variam de 1 ~100
		
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
		
		self.dano = int((self.forca/10.0) + (self.forca*self.destreza/divisor))
		self.danoMagico = int((self.inteligencia/10.0) + (self.inteligencia*self.will/divisor))
		self.danoDistancia = int((self.destreza/10.0) + (self.destreza*self.forca/divisor))
		self.defesa = int((self.vitalidade/10.0) + (self.vitalidade*self.agilidade/divisor))
		self.defesamagica = int((self.will/10.0) + (self.vitalidade*self.will/divisor))
		self.acerto=int((self.destreza/10.0) + (self.destreza*self.agilidade/divisor))
		self.acertoMagico=int((self.destreza/10.0) + (self.destreza*self.inteligencia/divisor))
		self.esquiva=int((self.agilidade/10.0) + (self.destreza*self.agilidade/divisor))
		self.esquivaMagica=int((self.agilidade/10.0) + (self.inteligencia*self.agilidade/divisor))
		self.bloqueio=int((self.destreza/10.0)+ (self.destreza * self.forca/divisor))
		self.bloqueioMagico=int((self.destreza/10)+ (self.destreza * self.will/divisor))
		
			
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
	var sprite
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


