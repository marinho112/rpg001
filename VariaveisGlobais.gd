extends Node

var pausado = false

var dinheiro = 0

var microTempo = 0
var segundos = 0
var minutos = 0
var horas = 0
var dias = 0

func _ready():
	set_process(true)
	
func _process(delta):
	controlaRelogio(delta)
	
	
func controlaRelogio(delta):
	if(!pausado):
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
