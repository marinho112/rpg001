extends KinematicBody2D

var posicaoX= 1
var posicaoY= 1
var posicaoXOld=1
var posicaoYOld=1
var andando=false
var contador=0
var velocidadeAngularX 
var velocidadeAngularY
	
var velocidade= 200.0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	
func _process(delta):
	
	controlarAndar(delta)
	
	desenhaPosicao(delta)
	
func controlarAndar(delsta):
	posicaoXOld=posicaoX
	posicaoYOld=posicaoY
	posicaoX= 1
	posicaoY= 1
	velocidadeAngularX = 0
	velocidadeAngularY=0
	
	
	if Input.is_action_pressed("ui_down"):
		posicaoY=2
		velocidadeAngularY = 0.5
	if Input.is_action_pressed("ui_up"):
		posicaoY=0
		velocidadeAngularY = 0.5
	if Input.is_action_pressed("ui_left"):
		posicaoX=0
		velocidadeAngularX = 0.5
	if Input.is_action_pressed("ui_right"):
		posicaoX=2
		velocidadeAngularX = 0.5
		
	
	var controle = velocidadeAngularX
	velocidadeAngularX = velocidadeAngularX + (0.25-velocidadeAngularY/2.0)
	velocidadeAngularY = velocidadeAngularY + (0.25-controle/2.0)
	
	
	
func desenhaPosicao(delta):
	if ((posicaoX != 1) or (posicaoY != 1)):
		$AnimatedSprite.set_flip_h(false)
		andando=true
		match posicaoY:
			0:
				match posicaoX :
					0:
						$AnimatedSprite.set_animation("andar_cima_esquerda")
					1:
						$AnimatedSprite.set_animation("andar_cima")
					2:
						$AnimatedSprite.set_flip_h(true)
						$AnimatedSprite.set_animation("andar_cima_esquerda")
			1:
				match posicaoX :
					0:
						$AnimatedSprite.set_animation("andar_esquerda")
					2:
						$AnimatedSprite.set_flip_h(true)
						$AnimatedSprite.set_animation("andar_esquerda")
			2:
				match posicaoX :
					0:
						$AnimatedSprite.set_animation("andar_baixo_esquerda")
					1:
						$AnimatedSprite.set_animation("andar_baixo")
					2:
						$AnimatedSprite.set_flip_h(true)
						$AnimatedSprite.set_animation("andar_baixo_esquerda")
				
						
		$AnimationPlayer.play("andar")
		var position =get_position()
		move_and_slide(Vector2(((posicaoX-1)*velocidade*velocidadeAngularX),((posicaoY-1)*velocidade*velocidadeAngularY)))
	elif(andando):
		andando=false
		$AnimatedSprite.set_flip_h(false)
		$AnimationPlayer.stop()
		$AnimatedSprite.set_animation("parado")
		match posicaoYOld:
			0:
				match posicaoXOld :
					0:
						$AnimatedSprite.set_frame(3)
					1:
						$AnimatedSprite.set_frame(4)
						
					2:
						$AnimatedSprite.set_frame(3)
						$AnimatedSprite.set_flip_h(true)
			1:
				match posicaoXOld :
					0:
						$AnimatedSprite.set_frame(2)
					2:
						$AnimatedSprite.set_frame(2)
						$AnimatedSprite.set_flip_h(true)
			2:
				match posicaoXOld :
					0:
						$AnimatedSprite.set_frame(1)
					1:
						$AnimatedSprite.set_frame(0)
					2:
						$AnimatedSprite.set_frame(1)
						$AnimatedSprite.set_flip_h(true)

		


		
	
	
	
