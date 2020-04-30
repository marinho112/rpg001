extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var ativado=false
var personagem


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	pass # Replace with function body.


func _process(delta):
	
	if(ativado):
		if Input.is_action_pressed("a"):
			$AnimatedSprite.set_animation("batendo")
			$AnimationPlayer.play("atacando")
			
		if Input.is_action_pressed("s"):
			$AnimatedSprite.set_animation("morto")
			$AnimationPlayer.play("parado")
		
		if Input.is_action_pressed("d"):
			$AnimatedSprite.set_animation("apanhando")
			$AnimationPlayer.play("atacando")
			
	
func ativa(num):
	match num:
		0:
			ativado=false
		_:
			ativado=true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
