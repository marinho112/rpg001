extends Node

class personagem:
	var lv =1
	var classe =0
	var esferas=5
		
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
	var bloquioMagico
	
	
	var esferasAtaque = 1
	var esferasDefesa = 2
	var esferasEsquiva = 1
	var esferasAcerto = 1
	
	func _init(lv,classe,forca,agi,des,vit,inte,will):
		
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
	
	var equipeCabeca
	var equipeCorpo
	var equipeDireita
	var equipeEsquerda
	var equipeSapato
	var equipeAcessorio1
	var equipeAcessorio2
	var equipeAcessorio3
	var equipeAcessorio4
	
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
