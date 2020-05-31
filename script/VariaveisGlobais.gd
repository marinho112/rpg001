extends Node

var idioma = Constantes.IDIOMA_PORTUGUES_BR
var listaPersonagens = []
var listaItens=[]
var dinheiro = 0
var menuAberto = false

var microTempo = 0
var segundos = 0
var minutos = 0
var horas = 0
var dias = 0

func _ready():
	listaPersonagens.append(ControlaDados.carregaInfoInicialPersonagemGrupo(1001))
	listaPersonagens.append(ControlaDados.carregaInfoInicialPersonagemGrupo(1001))
	listaPersonagens.append(ControlaDados.carregaInfoInicialPersonagemGrupo(1001))
	listaPersonagens.append(ControlaDados.carregaInfoInicialPersonagemGrupo(1001))
	listaPersonagens.append(ControlaDados.carregaInfoInicialPersonagemGrupo(1001))
	listaPersonagens.append(ControlaDados.carregaInfoInicialPersonagemGrupo(1001))
	
	listaPersonagens[0].pontos = 10
	
	for i in 200:
		var item
		match randi()%3:
			0:
				item = Itens.itemUtilizavel.new()
			1:
				item = Itens.itemEquipamento.new()
				item.equipamento = Equipamentos.equipamento_acessorio.new()
				item.equipamento.subTipoEquipamento = Constantes.EQUIPAMENTO_SUBTIPO_ACESSORIO_ANEL
			2:
				item = Itens.item.new()
				
		item.descricao = str(randi())
		listaItens.append(item)
		item.nome = "Item numero "+str(i)
		
	set_process(true)
	
func _process(delta):
	controlaRelogio(delta)
	
	
func controlaRelogio(delta):
	microTempo += delta
	if(microTempo>=1):
		segundos+=1
		microTempo-=1
	if(segundos>=60):
		minutos+=1
		segundos-=60
	if(minutos>=60):
		horas+=1
		minutos-=60
	if(horas>=24):
		dias+=1
		horas-=24
