extends Node2D

var itens= []
var itens2=[]
var posicao=0
var primeiro=0
var tamanho=0
var lista = []
var linhas = []
var ativado = true
var personagemTurno

var contaTempo=0


func _ready():
	linhas = [get_node("linha 1"),get_node("linha 2"),get_node("linha 3"),get_node("linha 4"),get_node("linha 5"),get_node("linha 6"),get_node("linha 7"),get_node("linha 8")]
	itens.append(Global.elementoMenu.new("Item1",0,itens))
	itens.append(Global.elementoMenu.new("Item2",1))
	itens.append(Global.elementoMenu.new("Item3",0,itens2))
	
	itens2.append(Global.elementoMenu.new("Item4",0,itens2))
	itens2.append(Global.elementoMenu.new("Item5",1))
	itens2.append(Global.elementoMenu.new("Item6",0,itens))
	
	lista=itens
	desenhaMenu()
	set_process(true)
	pass # Replace with function body.

func _process(delta):
	if(ativado):
		if (Input.is_action_just_pressed("a")):
			ativaAcaoBtn(lista[posicao+primeiro])
			
		elif (Input.is_action_pressed("ui_up")):
			if((posicao>0)and(contaTempo==0)):
				posicao-=1
			elif(contaTempo==0):
				if(primeiro>0):
					primeiro-=1
					desenhaMenu()
			contaTempo+=delta
		elif Input.is_action_pressed("ui_down"):
			if((posicao<tamanho-1)and(contaTempo==0)):
				posicao+=1
			elif(contaTempo==0):
				if(primeiro<len(lista)-tamanho):
					primeiro+=1
					desenhaMenu()
			contaTempo+=delta
		else:
			contaTempo=0
		if(contaTempo>=0.25):
			contaTempo=0
		atualizaPosicao()
	pass
	

func ativaAcaoBtn(botao):
	match botao.tipo:
		0:
			lista=botao.proximo
			desenhaMenu()
		1: 
			ativado=false
			get_parent().seleciona(2,0,0,personagemTurno)
		_:
			print(botao.texto)
	
func atualizaPosicao():
	var lugar=linhas[posicao].get_position()
	lugar.x+=74
	lugar.y+=10
	$cursor.set_position(lugar)
	
func desenhaMenu():
	zerarLinhas()
	
	if(len(lista)<8):
		tamanho = len(lista)
	else:
		tamanho=8
	
	for i in tamanho:
		linhas[i].set_text(lista[i+primeiro].texto)
		pass
	
	atualizaPosicao()


func zerarLinhas():
	for i in 8:
		linhas[i].set_text("")
