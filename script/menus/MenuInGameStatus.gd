extends Node2D


var selecionado
var ativado = true
var listaAreas = []
var listaValoresAreas = []
var posicao = 0
var vibraCursor = 0
var movientoCursor = 50
var gastoProvisorio = 0


func _ready():
	defineListaAreas()
	set_process(true)

func _process(delta):
	
	desenhaCursor(delta)
	
	if ativado:
		if Input.is_action_just_pressed("s"):
			voltar()
		elif Input.is_action_just_pressed("a"):
			ativaCursor()
		elif Input.is_action_just_pressed("ui_up"):
			subirCursor()
		elif Input.is_action_just_pressed("ui_down"):
			descerCursor()
		elif Input.is_action_just_pressed("mouse_left"):
			if Funcoes.na_area($areaAtributos,$areaAtributos/CollisionShape2D):
				posicaoMouseCursor()
		elif Input.is_action_just_pressed("ui_right"):
			subirValorAtributo()
		elif Input.is_action_just_pressed("ui_left"):
			reduzirValorAtributo()

func voltar():
	var pai = get_parent() 
	pai.remove_child(self)
	pai.get_parent().selecionaPersonagem(self)
	

func zerarValorAtributo():
	gastoProvisorio = 0
	corrigeValorAtributo()

func corrigeValorAtributo():
	listaValoresAreas = [(selecionado.forca + selecionado.forcaBonus),(selecionado.destreza + selecionado.destrezaBonus),(selecionado.agilidade + selecionado.agilidadeBonus),(selecionado.vitalidade + selecionado.vitalidadeBonus),(selecionado.inteligencia + selecionado.inteligenciaBonus),(selecionado.will + selecionado.willBonus)]
	for i in len(listaValoresAreas):
		listaValoresAreas[i] = int(listaValoresAreas[i]/10)
	if(gastoProvisorio > 0):
		listaAreas[posicao].set("custom_colors/font_color",Color(0,240,0))
		$Pontos.set("custom_colors/font_color",Color(240,0,0))
	else:
		listaAreas[posicao].set("custom_colors/font_color",null)
		$Pontos.set("custom_colors/font_color",null)
	listaAreas[posicao].set_text(ControlaDados.receberTexto("menus",24+posicao)+": "+str(listaValoresAreas[posicao]+gastoProvisorio))
	$Pontos.set_text(ControlaDados.receberTexto("menus",22)+": "+str(selecionado.pontos - gastoProvisorio))
	
	
func subirValorAtributo():
	if(gastoProvisorio < selecionado.pontos):
		gastoProvisorio += 1
	corrigeValorAtributo()
	
func reduzirValorAtributo():
	if(gastoProvisorio > 0):
		gastoProvisorio -= 1
	corrigeValorAtributo()
	
func posicaoMouseCursor():
	var posicaoArea = $Forca.get_global_position()
	var posicaoMouse = get_global_mouse_position()
	posicaoMouse -= posicaoArea
	var posicao = int(posicaoMouse.y / 30)
	if(self.posicao == posicao):
		ativaCursor()
	else:	
		self.posicao = posicao
	
func subirCursor():
	zerarValorAtributo()
	if(posicao>0):
		posicao-=1
	else:
		posicao = len(listaAreas) - 1

func descerCursor():
	zerarValorAtributo()
	if(posicao<len(listaAreas)-1):
		posicao+=1
	else:
		posicao = 0

func ativaCursor():
	match posicao:
		0:
			selecionado.forca += (gastoProvisorio *10)
		1:
			selecionado.destreza += (gastoProvisorio *10)
		2:
			selecionado.agilidade += (gastoProvisorio *10)
		3:
			selecionado.vitalidade += (gastoProvisorio *10)
		4:
			selecionado.inteligencia += (gastoProvisorio *10)
		5:
			selecionado.will += (gastoProvisorio *10)
	
	selecionado.pontos -= gastoProvisorio
	zerarValorAtributo()

func desenhaCursor(delta):
	
	var posicaoNova = listaAreas[posicao].get_position()
	posicaoNova.x -= 30 + vibraCursor
	posicaoNova.y += 12
	
	$cursor.set_position(posicaoNova)
	
	vibraCursor += delta * movientoCursor
	if(vibraCursor > 5):
		movientoCursor = -50
	elif (vibraCursor< -5):
		movientoCursor = 50
	
func defineListaAreas():
	listaAreas = [$Forca,$Destreza,$Agilidade,$Vitalidade,$Inteligencia,$Vontade]
	
func defineSelecionado(para):
	selecionado = para
	atualizaValores()

func atualizaValores():
	var texto
	$Nome.set_text(selecionado.nome)
	$Esferas.set_text(ControlaDados.receberTexto("menus",2)+": "+str(selecionado.esferas))
	$Pontos.set_text(ControlaDados.receberTexto("menus",22)+": "+str(selecionado.pontos))
	texto = ControlaDados.receberTexto("menus",15) + ": "+str(selecionado.experiencia)+" / "+str(selecionado.calculaXpProximoLv())
	$Experiencia.set_text(texto)
	$Lv.set_text(ControlaDados.receberTexto("menus",23)+": "+str(selecionado.lv))
	texto = ControlaDados.receberTexto("menus",13)+": "+str(selecionado.hpAtual)+" / "+str(selecionado.hpMaximo)
	$Hp.set_text(texto)
	texto = ControlaDados.receberTexto("menus",14)+": "+str(selecionado.mpAtual)+" / "+str(selecionado.mpMaximo)
	$Mp.set_text(texto)
	$Forca.set_text(ControlaDados.receberTexto("menus",24)+": "+str((selecionado.forca+selecionado.forcaBonus)/10))
	$Destreza.set_text(ControlaDados.receberTexto("menus",25)+": "+str((selecionado.destreza+selecionado.destrezaBonus)/10))
	$Agilidade.set_text(ControlaDados.receberTexto("menus",26)+": "+str((selecionado.agilidade+selecionado.agilidadeBonus)/10))
	$Vitalidade.set_text(ControlaDados.receberTexto("menus",27)+": "+str((selecionado.vitalidade+selecionado.vitalidadeBonus)/10))
	$Inteligencia.set_text(ControlaDados.receberTexto("menus",28)+": "+str((selecionado.inteligencia+selecionado.inteligenciaBonus)/10))
	$Vontade.set_text(ControlaDados.receberTexto("menus",29)+": "+str((selecionado.will+selecionado.willBonus)/10))
	
	$Ataque.set_text(ControlaDados.receberTexto("menus",30)+": "+str(selecionado.dano + selecionado.danoBonus))
	$Defesa.set_text(ControlaDados.receberTexto("menus",31)+": "+str(selecionado.defesa + selecionado.defesaBonus))
	$AtaqueMagico.set_text(ControlaDados.receberTexto("menus",32)+": "+str(selecionado.danoMagico + selecionado.danoMagicoBonus))
	$DefesaMagica.set_text(ControlaDados.receberTexto("menus",33)+": "+str(selecionado.defesaMagica + selecionado.defesaMagicaBonus))
	$Acerto.set_text(ControlaDados.receberTexto("menus",34)+": "+str(selecionado.acerto + selecionado.acertoBonus))
	$Esquiva.set_text(ControlaDados.receberTexto("menus",35)+": "+str(selecionado.esquiva + selecionado.esquivaBonus))
	$Bloqueio.set_text(ControlaDados.receberTexto("menus",36)+": "+str(selecionado.bloqueio + selecionado.bloqueioBonus))
	$AcertoMagico.set_text(ControlaDados.receberTexto("menus",37)+": "+str(selecionado.acertoMagico + selecionado.acertoMagicoBonus))
	$EsquivaMagica.set_text(ControlaDados.receberTexto("menus",38)+": "+str(selecionado.esquivaMagica + selecionado.esquivaMagicaBonus))
	$BloqueioMagico.set_text(ControlaDados.receberTexto("menus",39)+": "+str(selecionado.bloqueioMagico + selecionado.bloqueioMagicoBonus))
	
	
