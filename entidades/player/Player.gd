extends KinematicBody2D

#Definindo variáveis principais e atributos
var hp = 2
var damage = 25
var stamina = 100
var movement:Vector2
var inertia:float = 0.9
var dead := false
var can_attack:bool=true

var attack_delay = 0.5

const SPEED = 50
const MAX_SPEED = 200
const JUMP = 400
const GRAVITY = 10

##Referenciando nós
onready var interface = $CanvasLayer/Interface

##Criando nós
onready var timer = Timer.new()

##Chamado quando o jogador pressiona tecla de atacar
func attack():
	print("ataque!")

##Chamado quando o jogador recebe dano por um terceiro
func receive_damage(damage):
	##Se o dano dado já passa de 0 então mate-o, caso contrário só subtraia
	if hp - damage <= 0:
		hp = 0
		dead()
	else:
		hp -= damage
		

##Chamado quando o jogador morre
func dead():
	dead = true

##Chamado quando o jogador encosta em um coletável de stamina
func stamina_increase(increase):
	if stamina + increase > 100:
		stamina = 100
	else:
		stamina += increase
	
##Chamada quando o player encosta em um coletável de vida
func life_increase(increase):
	# verifica se o hp suporta a incrementação da vida
	if hp + increase > 100:
		hp = 100;
	else:
		hp += increase;

##Tudo relacionado aos controles e movimentação do jogador
func input():
	
	#Movimentos de esquerda e direita no eixo x
	if not dead:
		if Input.is_action_pressed("left"):
			movement.x -= SPEED
		if Input.is_action_pressed("right"):
			movement.x += SPEED
		
	#Caso esteja no chão e pressione para cima, pule.
		if Input.is_action_just_pressed("up") and is_on_floor():
			movement.y = -JUMP
	
		if Input.is_action_just_released("up") and not is_on_floor():
			movement.y *= inertia - 0.1
			
		if Input.is_action_pressed("attack") and can_attack:
			attack()
			can_attack = false
			timer.start()
			
	##Gravidade:
	movement.y += GRAVITY
	
	##Limita a velocidade máxima do eixo X em ambos os lados
	movement.x = clamp(movement.x,-MAX_SPEED,MAX_SPEED)
	
	##Faz com que a própria velocidade seja multiplicada pela inercia (para deslizar)
	if is_on_floor():
		movement.x *= inertia
	else:
		movement.x *= 1.0
		
	##Aplica os movimentos do vetorial ao corpo do nó:
	movement = move_and_slide(movement, Vector2.UP)
	
func conectar_HUD():
	interface.conectar_stamina(stamina)
	interface.conectar_vida(hp)
	

func timer_completo():
	can_attack = true

func _ready():
	timer.set_one_shot(true)
	timer.set_wait_time(attack_delay)
	timer.connect("timeout",self,"timer_completo")
	add_child(timer)
	
func _physics_process(delta):
	#Processa os movimentos e calcula a gravidade
	input()
	conectar_HUD()
