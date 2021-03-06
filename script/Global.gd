extends Node

func _init():
	randomize()

func xpNecessariaLv(lv):
	return (30*lv) + (5*lv*lv)

class personagem:
	
	#salvar no DB
	var ID 
	var nome
	var lv =1
	var classe =0
	var esferas=5
	var maxValorEsferas = 3
	var experiencia = 0
	
	var hpMaximo
	var mpMaximo
	
	var forca = 10
	var agilidade =10
	var destreza =10
	var vitalidade =10 
	var inteligencia=10
	var will=10
	
	var defeseRate = 100
	
	var forcaBonus 
	var agilidadeBonus 
	var destrezaBonus 
	var vitalidadeBonus 
	var inteligenciaBonus
	var willBonus
	
	
	var node
	var raca = Constantes.RACA_HUMANOIDE
	var raca_secundaria = Constantes.RACA_SECUNDARIA_HUMANO
	var propriedade = Constantes.PROPRIEDADE_DO_ATAQUE_NEUTRO
	
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
	var listaItensUtilizaveis=[]
	
	#Apenas Calculado
	var dano
	var danoMagico
	var danoDistancia
	var defesa
	var defesaMagica
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
	var defesaMagicaBonus
	var acertoBonus
	var esquivaBonus
	var bloqueioBonus
	var acertoMagicoBonus
	var esquivaMagicaBonus
	var bloqueioMagicoBonus
	
	var esferasAtaqueBonus
	var esferasDefesaBonus
	var esferasEsquivaBonus
	var esferasAcertoBonus
	
	func retornaHpRate():
		return hpAtual*100/hpMaximo
		
	func retornaMpRate():
		return mpAtual*100/mpMaximo
		
	func retornarEquipamentosEquipados():
		return []
	
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
		defesaMagicaBonus=0
		acertoBonus=0
		esquivaBonus=0
		bloqueioBonus=0
		acertoMagicoBonus=0
		esquivaMagicaBonus=0
		bloqueioMagicoBonus=0
		
	func _init(lv=1,classe=0,forca=10,agi=10,des=10,vit=10,inte=10,will=10):
		
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
		
		
		#calculaAtributos()
		
	func calculoDosAtributos():
		var divisor = 5000.0
		
		dano = int(((forca+forcaBonus)/10.0) + ((forca+forcaBonus)*(destreza+destrezaBonus)/divisor))
		danoMagico = int(((inteligencia+inteligenciaBonus)/10.0) + ((inteligencia+inteligenciaBonus)*(will+willBonus)/divisor))
		danoDistancia = int(((destreza+destrezaBonus)/10.0) + ((destreza+destrezaBonus)*(inteligencia+inteligenciaBonus)/divisor))
		defesa = int(((vitalidade+vitalidadeBonus)/10.0) + ((vitalidade+vitalidadeBonus)*(agilidade+agilidadeBonus)/divisor))
		defesaMagica = int(((will+willBonus)/10.0) + ((vitalidade+vitalidadeBonus)*(will+willBonus)/divisor))
		acerto=int(((destreza+destrezaBonus)/10.0) + ((destreza+destrezaBonus)*(agilidade+agilidadeBonus)/divisor))
		acertoMagico=int(((destreza+destrezaBonus)/10.0) + ((destreza+destrezaBonus)*(inteligencia+inteligenciaBonus)/divisor))
		esquiva=int(((agilidade+agilidadeBonus)/10.0) + ((destreza+destrezaBonus)*(agilidade+agilidadeBonus)/divisor))
		esquivaMagica=int(((agilidade+agilidadeBonus)/10.0) + ((inteligencia+inteligenciaBonus)*(agilidade+agilidadeBonus)/divisor))
		bloqueio=int(((destreza+destrezaBonus)/10.0)+ ((destreza+destrezaBonus) * (forca+forcaBonus)/divisor))/3
		bloqueioMagico=int(((destreza+destrezaBonus)/10)+ ((destreza+destrezaBonus) * (will+willBonus)/divisor))/3	
	
		#Atributos secundarios variam de 1~300 + 0~200 nos itens 
	func calculaAtributos():
		
		zerarBonus()
		defeseRate = 100
		
		calculoDosAtributos()
		
		for item in habilidadesPassivas:
			ativaEfeitoPassivoCampo(item)
		
		calculoDosAtributos()
		
		
		zerarBonus()
		defeseRate = 100
		
		for item in habilidadesPassivas:
			ativaEfeitoPassivoCampo(item)
	
	func ativaEfeitoPassivoCampo(item):
		if((item!=null)):
			item.efeitoPassivo(self)
			
	func recebeDano(val):
		hpAtual -= val
		if(hpAtual < 0):
			hpAtual=0
			
	func cura(val):
		hpAtual += val
		if(hpAtual > hpMaximo):
			hpAtual=hpMaximo
			
	func recuperaMp(val):
		mpAtual += val
		if(mpAtual > mpMaximo):
			mpAtual=mpMaximo
	
	func recuperaTudo(num):
		match num:
			0:
				hpAtual=hpMaximo
			1:
				mpAtual=mpMaximo
			_: 
				hpAtual=hpMaximo
				mpAtual=mpMaximo
			
	
class personagemGrupo extends personagem:
	
	var baseHp =1
	var baseMp = 1
	var pontos = 0
	
	var menu=[]
	var listaItensComuns=[]
	var listaItensEquipamentos=[]
	var equipaveis = []
	
	var equipeCabeca
	var equipeCorpo
	var equipeMaos
	var equipeDireita
	var equipeEsquerda
	var equipePes
	var equipeAcessorio1
	var equipeAcessorio2
	var equipeAcessorio3
	var equipeAcessorio4
	
	var SextaEsferaDesbloqueada=false
	
	func retornarEquipamentosEquipados():
		var lista = []
		lista.append(equipeCabeca)
		lista.append(equipeCorpo)
		lista.append(equipeMaos)
		lista.append(equipeDireita)
		lista.append(equipeEsquerda)
		lista.append(equipePes)
		lista.append(equipeAcessorio1)
		lista.append(equipeAcessorio2)
		lista.append(equipeAcessorio3)
		lista.append(equipeAcessorio4)
		
		return lista
	
	func calculaXpProximoLv():
		return Global.xpNecessariaLv(lv)
	
	func calculaAtributos():
		hpMaximo = baseHp * (lv+5) /2
		hpMaximo += hpMaximo * vitalidade / 10
		mpMaximo = baseMp * (lv+5) / 2
		mpMaximo += mpMaximo * will /10 
		.calculaAtributos()
		
		
		ativaEfeitoPassivoCampo(equipeCabeca)
		ativaEfeitoPassivoCampo(equipeCorpo)
		ativaEfeitoPassivoCampo(equipeMaos)
		ativaEfeitoPassivoCampo(equipeDireita)
		ativaEfeitoPassivoCampo(equipeEsquerda)
		ativaEfeitoPassivoCampo(equipePes)
		ativaEfeitoPassivoCampo(equipeAcessorio1)
		ativaEfeitoPassivoCampo(equipeAcessorio2)
		ativaEfeitoPassivoCampo(equipeAcessorio3)
		ativaEfeitoPassivoCampo(equipeAcessorio4)

	
class personagemMob extends personagem:
	
	#Salvar no DB 
	var ai
	var tamanho 
	var golpeBasico
	
	func calculaAtributos():
		.calculaAtributos()
		if(tamanho != null):
			bloqueio = int(bloqueio/(5.0 - tamanho))
			esquiva = int(esquiva/(tamanho + 1.0))
	
class elementoMenu:
	var tipo
	var texto
	var proximo
	var extra
	
	
	func _init(tipo,texto,proximo=null,extra=null):
		self.texto=texto
		self.tipo=tipo
		set_proximo(proximo)
		set_extra(extra)
	func set_proximo(proximo):
		self.proximo=proximo
	
	func set_extra(extra):
		self.extra=extra

func verificaCursorNoLocal(area):
	var areas = area.get_overlapping_areas()
	var cursorNoLocal = false 
	for i in areas:
		if(i.is_in_group(Constantes.GRUPO_CURSOR_MOUSE)):
			cursorNoLocal=true
	return cursorNoLocal
