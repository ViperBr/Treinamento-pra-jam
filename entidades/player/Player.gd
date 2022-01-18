extends KinematicBody2D

#Definindo variáveis principais e atributos
var hp = 100
var damage = 25
var movement:Vector2
var inertia:float = 0.7
const SPEED = 50
const MAX_SPEED = 400
const JUMP = 500
const GRAVITY = 10

##Chamado quando o jogador pressiona tecla de atacar
func attack():
	pass

##Chamado quando o jogador recebe dano por um terceiro
func receive_damage():
	pass

##Chamado quando o jogador morre
func dead():
	pass

##Tudo relacionado aos controles e movimentação do jogador
func input():
	
	#Movimentos de esquerda e direita no eixo x
	if Input.is_action_pressed("left"):
		movement.x -= SPEED
	if Input.is_action_pressed("right"):
		movement.x += SPEED
		
	#Caso esteja no chão e pressione para cima, pule.
	if Input.is_action_just_pressed("up") and is_on_floor():
		movement.y = -JUMP
		
	#Se ele estiver no chão apenas multiplique movimentação com a inercia sem alteração
	#Caso contrário multiplique por 1
	if is_on_floor():
		movement.x *= inertia
	else:
		movement.x *= 1.0
	
	##Gravidade:
	movement.y += GRAVITY
	
	##Limita a velocidade máxima do eixo X em ambos os lados
	movement.x = clamp(movement.x,-MAX_SPEED,MAX_SPEED)
	
	##Faz com que a própria velocidade seja multiplicada pela inercia (para deslizar)
	
	#Se ele estiver no chão apenas multiplique movimentação com a inercia sem alteração
	#Caso contrário multiplique por 1
	if is_on_floor():
		movement.x *= inertia
	else:
		movement.x *= 1.0
	##Aplica os movimentos do vetorial ao corpo do nó:
	movement = move_and_slide(movement, Vector2.UP)
	
func _ready():
	pass

func _physics_process(delta):
	#Processa os movimentos e calcula a gravidade
	input()
