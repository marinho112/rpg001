extends Node2D

var posicaoX= 1
var posicaoY= 1
var posicaoXOld=1
var posicaoYOld=1
var andando=false
var contador=0

var velocidade= 80.0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	pass # Replace with function body.

func _process(delta):
	contador+=delta
	
	if(contador>=0.1):
		contador=0
		controlarAndar(delta)
	
	desenhaPosicao(delta)
	
func controlarAndar(delsta):
	posicaoXOld=posicaoX
	posicaoYOld=posicaoY
	posicaoX= 1
	posicaoY= 1
	
	
	if Input.is_action_pressed("ui_down"):
		posicaoY=2
	if Input.is_action_pressed("ui_up"):
		posicaoY=0
	if Input.is_action_pressed("ui_left"):
		posicaoX=0
	if Input.is_action_pressed("ui_right"):
		posicaoX=2
	
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
		set_position(Vector2(position.x+((posicaoX-1)*velocidade*delta),position.y+((posicaoY-1)*velocidade*delta)))
	elif(andando):
		andando=false
		$AnimatedSprite.set_flip_h(false)
		$AnimationPlayer.stop()
		$AnimatedSprite.set_animation("parado")
		print(posicaoYOld)
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

		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
