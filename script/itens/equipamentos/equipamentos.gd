extends Node


class equipamento extends Bonus.bonus:
	
	var id
	var tipoEquipamento
	var ondeEquipa
	var subTipoEquipamento
	var defesa = 0
	var sprite
	var itemEquipamento
	
	func equipar(personagem):
		var equipado 
		
		match tipoEquipamento:
			Constantes.EQUIPAMENTO_TIPO_CABECA:
				 equipado = personagem.equipeCabeca
			Constantes.EQUIPAMENTO_TIPO_CORPO:
				 equipado = personagem.equipeCorpo
			Constantes.EQUIPAMENTO_TIPO_MAOS:
				 equipado = personagem.equipeMaos
			Constantes.EQUIPAMENTO_TIPO_ESCUDO:
				 equipado = personagem.equipeEsquerda
			Constantes.EQUIPAMENTO_TIPO_PES:
				 equipado = personagem.equipePes
		
		for i in len(personagem.listaItensEquipamentos):
			var item = personagem.listaItensEquipamentos[i]
			if(item.id == self.id):
				personagem.listaItensEquipamentos.remove(i)
				if(equipado!=null):
					personagem.listaItensEquipamentos.append(equipado)
				equipado=item
				return
		
	func desequipaCasoDuasMaos(personagem):
		var equipado = personagem.equipamentoDireita
		var equipado2 = personagem.equipamentoEsquerda
		if(equipado != null):
			if(equipado.duasMaos):
				if(equipado != equipado2):
					personagem.equipamentoDireita = null
		if(equipado2 != null):
			if(equipado2.duasMaos):
				if(equipado != equipado2):
					personagem.equipamentoEsquerda = null
		
	func efeitoPassivo(personagem):
		personagem.defesaBonus+=defesa
		
	func efeitoAoEquipar():
		return true
	
	func efeitoAoDesequipar():
		return true

class equipamento_arma extends equipamento:
	
	var duasMaos
	var elemento = Constantes.PROPRIEDADE_DO_ATAQUE_NEUTRO
	var tipoDano = Constantes.TIPO_DE_DANO_CONTUSIVO
	var dano = 0
	
	func _init():
		tipoEquipamento=Constantes.EQUIPAMENTO_TIPO_ARMA
	
	func equipar(personagem):
		var equipado = personagem.equipeDireita
		var equipado2 = personagem.equipeEsquerda
		
		for i in len(personagem.listaItensEquipamentos):
			var item = personagem.listaItensEquipamentos[i]
			if(item.id == self.id):
				personagem.listaItensEquipamentos.remove(i)
				if(equipado!=null):
					personagem.listaItensEquipamentos.append(equipado)
				personagem.equipeDireita=item
				if(duasMaos):
					if(equipado2!=null):
						personagem.listaItensEquipamentos.append(equipado2)
					personagem.equipeDireita=item
				desequipaCasoDuasMaos(personagem)
				return
	
	func efeitoPassivo(personagem):
		.efeitoPassivo(personagem)
		personagem.danoBonus+=dano
	
class equipamento_cabeca extends equipamento:
	
	
	func _init():
		tipoEquipamento=Constantes.EQUIPAMENTO_TIPO_CABECA
	

	
class equipamento_corpo extends equipamento:
	
	func _init():
		tipoEquipamento=Constantes.EQUIPAMENTO_TIPO_CORPO

class equipamento_maos extends equipamento:
	
	func _init():
		tipoEquipamento=Constantes.EQUIPAMENTO_TIPO_MAOS

class equipamento_escudo extends equipamento:
	
	func _init():
		tipoEquipamento=Constantes.EQUIPAMENTO_TIPO_ESCUDO

	func equipar(personagem):
		.equipar(personagem)
		desequipaCasoDuasMaos(personagem)
		
class equipamento_pes extends equipamento:
	
	func _init():
		tipoEquipamento=Constantes.EQUIPAMENTO_TIPO_PES
		
class equipamento_acessorio extends equipamento:
	
	func _init():
		tipoEquipamento=Constantes.EQUIPAMENTO_TIPO_ACESSORIO
