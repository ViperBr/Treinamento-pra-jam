extends KinematicBody2D

#Definindo variáveis principais e atributos
var hp = 100
var damage = 25
var movement:Vector2
var inertia:float = 0.5
const SPEED = 50
const MAX_SPEED = 100
const JUMP = 100
const GRAVITY = 10


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
	if Input.is_action_pressed("up") and is_on_floor():
		movement.y -= JUMP
	
	##Gravidade:
	movement.y += GRAVITY
	
	##Limita a velocidade máxima do eixo X em ambos os lados
	movement.x = clamp(movement.x,-MAX_SPEED,MAX_SPEED)
	
	##Faz com que a própria velocidade seja multiplicada pela inercia (para deslizar)
	movement.x *= inertia
	
	##Aplica os movimentos do vetorial ao corpo do nó:
	movement = move_and_slide(movement)
	
func _ready():
	pass

func _physics_process(delta):
	#Processa os movimentos e calcula a gravidade
	input()
