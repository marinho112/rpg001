extends Node



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func carregaInfoPersonagemMob(id):
	
	var arquivo = File.new()
	#var erro = arquivo.open("res://dados/teste.data",File.WRITE)
	var erro = arquivo.open("res://dados/mob.data",File.READ)
	var conteudo
	#var dados = {"Dado1" : "Valor","Dado2" : 3}
	if not erro:
	#	
		while(!arquivo.eof_reached()):
			conteudo = arquivo.get_line()
			if(conteudo.length( ) >2):
				if((conteudo[0]!="/")and(conteudo[1]!="/")):
					var dividido = conteudo.split(",")
					if(dividido[0] == str(id)):
						var mob=converteStringInMob(dividido)
						return mob
	else:
		print("ERRO!!")
	arquivo.close()

func converteStringInMob(dividido):
	
	var mob = Global.personagemMob.new()
	mob.ID = int(dividido[0])
	mob.nome = dividido[1]
	mob.lv = int(dividido[2])
	mob.classe = int(dividido[3])
	mob.esferas=int(dividido[4])
	mob.experiencia=int(dividido[5])
	mob.hpMaximo=int(dividido[6])
	mob.mpMaximo=int(dividido[7])
	mob.forca=int(dividido[8])
	mob.agilidade=int(dividido[9])
	mob.destreza=int(dividido[10])
	mob.vitalidade=int(dividido[11])
	mob.inteligencia=int(dividido[12])
	mob.will=int(dividido[13])
	mob.raca=int(dividido[14])
	mob.raca_secundaria=int(dividido[15])
	mob.propriedade=int(dividido[16])
	mob.ai=dividido[17]
	mob.node=dividido[18]
	mob.tamanho=int(dividido[19])
	return mob

func carregaInfoInicialPersonagemGrupo(id):
	
	var arquivo = File.new()
	#var erro = arquivo.open("res://dados/teste.data",File.WRITE)
	var erro = arquivo.open("res://dados/personagens_iniciais.data",File.READ)
	var conteudo
	#var dados = {"Dado1" : "Valor","Dado2" : 3}
	if not erro:
	#	
		while(!arquivo.eof_reached()):
			conteudo = arquivo.get_line()
			if(conteudo.length( ) >2):
				if((conteudo[0]!="/")and(conteudo[1]!="/")):
					var dividido = conteudo.split(",")
					if(dividido[0] == str(id)):
						var personagem=converteStringInPersonagem(dividido)
						return personagem
	else:
		print("ERRO!!")
	arquivo.close()

func converteStringInPersonagem(dividido):
	
	var per = Global.personagemGrupo.new()
	per.listaItensComuns = []
	per.listaItensUtilizaveis = []
	per.listaItensEquipamentos = []
	per.habilidadesPassivas = []
	
	per.ID = int(dividido[0])
	per.nome = dividido[1]
	per.lv = int(dividido[2])
	per.classe = int(dividido[3])
	per.baseHp = int(dividido[4])
	per.baseMp = int(dividido[5])
	per.forca=int(dividido[6])
	per.agilidade=int(dividido[7])
	per.destreza=int(dividido[8])
	per.vitalidade=int(dividido[9])
	per.inteligencia=int(dividido[10])
	per.will=int(dividido[11])
	per.node= dividido[12]
	per.raca_secundaria=int(dividido[13])
	per.propriedade=int(dividido[14])
	per.habilidadesOfensivas= []
	var menus = dividido[16].split("/")
	per.menu= carregaMenuCombate(menus,per)
	per.equipeCabeca = carregaEquipamento(int(dividido[17]))
	per.equipeCorpo =carregaEquipamento( int(dividido[18]))
	per.equipeMaos = carregaEquipamento(int(dividido[19]))
	per.equipeDireita = carregaEquipamento(int(dividido[20]))
	per.equipeEsquerda = carregaEquipamento(int(dividido[21]))
	per.equipePes = carregaEquipamento(int(dividido[22]))
	per.equipeAcessorio1 = carregaEquipamento(int(dividido[23]))
	per.equipeAcessorio2 = carregaEquipamento(int(dividido[24]))
	per.equipeAcessorio3 = carregaEquipamento(int(dividido[25]))
	per.equipeAcessorio4 = carregaEquipamento(int(dividido[26]))
		
	per.calculaAtributos()
	return per

func carregaEquipamento(id):
	if(id == 0 ):
		return null
	else:
		return id

func carregaInfoElementoMenu(id,personagem):

	var arquivo = File.new()
	#var erro = arquivo.open("res://dados/teste.data",File.WRITE)
	var erro = arquivo.open("res://dados/elementoMenuCombate.data",File.READ)
	var conteudo
	#var dados = {"Dado1" : "Valor","Dado2" : 3}
	if not erro:
		while(!arquivo.eof_reached()):
			conteudo = arquivo.get_line()
			if(conteudo.length( ) >2):
				if((conteudo[0]!="/")and(conteudo[1]!="/")):
					var dividido = conteudo.split(",")
					if(dividido[0] == str(id)):
						var elementoMenu = Global.elementoMenu.new(int(dividido[1]),dividido[2],int(dividido[3]),int(dividido[4]))
						return elementoMenu
	else:
		print("ERRO!!")
	arquivo.close()
	
func carregaMenuCombate(listaItens,personagem):
	var lista = []
	var item
	for i in len(listaItens):
		item = listaItens[i]
		var elementoMenu = carregaInfoElementoMenu(item,personagem)
		if(elementoMenu!=null):
			if(elementoMenu.tipo == Constantes.TIPO_ELEMENTO_MENU_LISTA_ITENS):
				var utilizaveis=[]
				for utilizavel in personagem.listaItensUtilizaveis:
					if(utilizavel.emBatalha):
						var novoElemento = Global.elementoMenu.new(Constantes.TIPO_ELEMENTO_MENU_ITEM,utilizavel.nome,0,utilizavel)
						utilizaveis.append(utilizavel)
				var voltar = Global.elementoMenu.new(Constantes.TIPO_ELEMENTO_MENU_LISTA,"Voltar",lista,0)
				utilizaveis.append(voltar)
				elementoMenu.proximo=utilizaveis
			elif(elementoMenu.tipo == Constantes.TIPO_ELEMENTO_MENU_LISTA_HABILIDADES):
				var habilidades=[]
				for habilidade in personagem.habilidadesOfensivas:
					if(not habilidade.golpeMagico):
						var novoElemento = Global.elementoMenu.new(Constantes.TIPO_ELEMENTO_MENU_ATAQUE,habilidade.nome,0,habilidade)
						habilidades.append(habilidade)
				var voltar = Global.elementoMenu.new(Constantes.TIPO_ELEMENTO_MENU_LISTA,"Voltar",lista,0)
				habilidades.append(voltar)
				elementoMenu.proximo=habilidades
			elif(elementoMenu.tipo == Constantes.TIPO_ELEMENTO_MENU_LISTA_MAGIAS):
				var habilidades=[]
				for habilidade in personagem.habilidadesOfensivas:
					if(habilidade.golpeMagico):
						var novoElemento = Global.elementoMenu.new(Constantes.TIPO_ELEMENTO_MENU_ATAQUE,habilidade.nome,0,habilidade)
						habilidades.append(habilidade)
				var voltar = Global.elementoMenu.new(Constantes.TIPO_ELEMENTO_MENU_LISTA,"Voltar",lista,0)
				habilidades.append(voltar)
				elementoMenu.proximo=habilidades
			lista.append(elementoMenu)
	
	return lista
