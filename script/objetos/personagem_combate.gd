extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var ativado=false
var personagem
var moverAtaque=false
var speed = 200
var atacado 
var listaInimigos= []

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	pass # Replace with function body.


func _process(delta):
	
	if(ativado):
		if Input.is_action_pressed("a"):
			pass
			#$AnimatedSprite.set_animation("batendo")
			#$AnimationPlayer.play("atacando")
			
		if Input.is_action_pressed("s"):
			pass
		
		if Input.is_action_pressed("d"):
			pass
			
	moverAtaque(delta)
	
func ativa(num):
	match num:
		0:
			ativado=false
		_:
			ativado=true

func atacar(atacado):
	self.listaInimigos=get_parent().listaInimigosObjeto
	self.atacado=atacado
	moverAtaque=true
	
	pass

func moverAtaque(delta):
	if(moverAtaque):
		$AnimatedSprite.set_animation("movendo")
		var inimigoAtacado = listaInimigos[atacado]
		var posiAtacado=inimigoAtacado.get_position()
		var frames =inimigoAtacado.get_node("AnimatedSprite").get_sprite_frames()
		var anim = inimigoAtacado.get_node("AnimatedSprite").get_animation()
		var frame =inimigoAtacado.get_node("AnimatedSprite").get_frame()
		var atacadoTamanho=frames.get_frame(anim,frame).get_size()
		var position= get_position()
		var distanciaX= (atacadoTamanho.x + posiAtacado.x) - (position.x)
		var distanciaY= ((posiAtacado.y) - (position.y) )
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
			moverAtaque=false
			$AnimatedSprite.set_animation("default")
		
		print(get_position())
	pass
	
func animacaoAtaque():
	pass

func calculaDano():
	pass
	
func causaDano():
	pass
	
func sofreDano():
	pass
	
 
func animacaoApanhar():
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
