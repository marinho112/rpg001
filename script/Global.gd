extends Node

class personagem:
	var lv =1
	var classe =0
	var esferas=5
	var posicaoCombate
		
	var hpMaximo
	var hpAtual
	var mpMaximo
	var mpAtual
	
	var forca = 1
	var agilidade =1
	var destreza =1
	var vitalidade =1 
	var inteligencia=1
	var will=1
	
	var dano
	var danoMagico
	var defesa
	var defesamagica
	var acerto
	var esquiva
	var bloqueio
	var acertoMagico
	var esquivaMagica
	var bloqueioMagico
	
	
	var esferasAtaque = 1
	var esferasDefesa = 1
	var esferasEsquiva = 1
	var esferasAcerto = 1
	
	
	var habilidadesOfensivas=[]
	var habilidadesPassivas=[]
	
	
	func _init(lv=1,classe=0,forca=1,agi=1,des=1,vit=1,inte=1,will=1):
		
		self.lv=lv
		self.classe=classe
		self.forca=forca
		self.agilidade=agi
		self.destreza=des
		self.vitalidade=vit
		self.inteligencia=inte
		self.will=will
		
		self.dano = self.forca + (self.forca*self.destreza/50)
		self.danoMagico = self.inteligencia + (self.inteligencia*self.will/50)
		self.defesa = self.vitalidade + (self.vitalidade*self.agilidade/50)
		self.defesamagica = self.will + (self.vitalidade*self.will/50)
		self.acerto=self.destreza + (self.destreza+self.agilidade/50)
		self.acertoMagico=self.destreza + (self.destreza+self.inteligencia/50)
		self.esquiva=self.agilidade + (self.destreza+self.agilidade/50)
		self.esquivaMagica=self.agilidade + (self.inteligencia+self.agilidade/50)
		self.bloqueio=self.destreza+ (self.destreza + self.forca/50)
		self.bloqueioMagico=self.destreza+ (self.destreza + self.will/50)

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

	var Inteligencia
	var caracteristicas = []
	
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


