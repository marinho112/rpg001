extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var personagem
var moverAtaque=true
var animacaoAtaque = true
var controlaAtaque = false
var voltando = true
var speed = 200
var atacados=[]
var listaInimigos= []
var posicaoInicial
var ataquesRealizados=0
var golpesRealizados = 0
var golpesPorAtaque=2

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	pass # Replace with function body.


func _process(delta):
	
	controlaAtaque(delta)
	

func alteraPosicaoPermanente(posicao):
	set_position(posicao)
	posicaoInicial=posicao

func atacar(atacados,tipoAtaque):
	self.listaInimigos=get_parent().listaInimigosObjeto
	self.atacados=atacados
	ataquesRealizados=0
	controlaAtaque=true
	pass

func controlaAtaque(delta):
	if(controlaAtaque):
		if(ataquesRealizados<len(atacados)):
			moverAtaque(delta)
			animacaoAtaque(delta)
			
			
		else:
			animacaoVoltar(delta)
			if(!voltando):
				$AnimatedSprite.set_animation("default")
				$AnimationPlayer.stop()
				controlaAtaque=false
				get_parent().terminaTurno()
			

func moverAtaque(delta):
	if(moverAtaque):
		$AnimatedSprite.set_animation("movendo")
		$AnimatedSprite.set_flip_h(true)
		var inimigoAtacado = atacados[ataquesRealizados]
		var posiAtacado=inimigoAtacado.get_position()
		var frames =inimigoAtacado.get_node("AnimatedSprite").get_sprite_frames()
		var anim = inimigoAtacado.get_node("AnimatedSprite").get_animation()
		var frame =inimigoAtacado.get_node("AnimatedSprite").get_frame()
		var atacadoTamanho=frames.get_frame(anim,frame).get_size()
		var position= get_position()
		var distanciaX= (atacadoTamanho.x + posiAtacado.x) - (position.x)
		var distanciaY= ((posiAtacado.y) - (position.y) )
		
		
		
		if(mover(distanciaX,distanciaY,delta)):
			moverAtaque=false
			$AnimatedSprite.set_flip_h(false)
			
		
	pass
	
func animacaoAtaque(delta):
	
	if(golpesRealizados>=golpesPorAtaque):
		moverAtaque=true
		ataquesRealizados+=1
		golpesRealizados=0
	
	if(!moverAtaque and animacaoAtaque):
		$AnimatedSprite.set_animation("batendo")
		$AnimationPlayer.play("atacando")
		
	pass

func calculaDano():
	pass
	
func causaDano():
	pass
	
func sofreDano():
	pass
	
 
func animacaoApanhar():
	pass
	

func animacaoVoltar(delta):
	if(voltando):
		$AnimatedSprite.set_animation("movendo")
		$AnimatedSprite.set_flip_h(false)
		var position= get_position()
		var distanciaX= (posicaoInicial.x) - (position.x)
		var distanciaY= ((posicaoInicial.y) - (position.y) )
	
		if(mover(distanciaX,distanciaY,delta)):
			voltando=false

func mover(distanciaX,distanciaY,delta):
	
	var moduloX=0
	var moduloY=0
	var moveX=0
	var moveY=0
	
	if(distanciaX>=0):
			moduloX=distanciaX
	else:
		moduloX=-distanciaX
		
	if(distanciaY>=0):
		moduloY=distanciaY
	else:
		moduloY=-distanciaY
	
	if((moduloX>=10)or(moduloY >=10)):
		if(moduloY<=1):
			moduloY=1
		if(moduloX<=1):
			moduloX=1
		if(moduloX>moduloY):
			moveX= distanciaX/moduloX
			moveY= distanciaY/moduloX
		else:
			moveX = distanciaX/moduloY
			moveY= distanciaY/moduloY
		
		set_position(Vector2(position.x+(moveX*delta*(speed+moduloX)),position.y+(moveY*delta*(speed+moduloY))))
	else:
		return true
	return false

func _on_AnimationPlayer_animation_finished(anim_name):
	if(anim_name=="atacando"):
		golpesRealizados+=1
		
	
	pass 
