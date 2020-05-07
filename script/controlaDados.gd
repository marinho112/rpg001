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
						var mob=converteMobInString(dividido)
						return mob
	else:
		print("ERRO!!")
	arquivo.close()

func converteMobInString(dividido):
	
				var mob = Global.personagemMob.new()
				for i in 20:
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
					mob.sprite=dividido[18]
					mob.tamanho=int(dividido[19])
				return mob
				
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
