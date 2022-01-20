extends KinematicBody2D

#Definindo variáveis principais e atributos
var hp = 100
var damage = 30
var stamina = 100
var movement:Vector2
var inertia:float = 0.9
var dead := false
var can_attack:bool=true
var attack_delay = 0.3

var direction = 1
var flip_h:bool=false


var stamina_to_increase = 5
var perda_de_stamina = 20

var inimigo = []

var alvo_flecha = null


const SPEED = 50
const MAX_SPEED = 200
const JUMP = 400
const GRAVITY = 10

##Referenciando nós
onready var interface = $CanvasLayer/Interface

##Criando nós
onready var timer = Timer.new()
onready var stamina_timer = Timer.new()

##Chamado quando o jogador pressiona tecla de atacar
func attack():
	if stamina - perda_de_stamina <= 0:
		return
	else:
		print("atacou")
		stamina -= perda_de_stamina
		if inimigo:
			for enemy in inimigo:
				enemy.receive_damage(damage)
		
		if alvo_flecha:
			alvo_flecha.flecha_acertada()
			
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
	
	##Define a direção do jogador
	if movement.x > 0:
		direction = 1
	else:
		direction = -1
		
	##Vai flipar o colisionshape de acordo com a direção	
	if direction > 0:
		if flip_h:
			get_node("distancia_de_hit/CollisionShape2D").position.x *=-1
		flip_h = false
	if direction < 0:
		if not flip_h:
			get_node("distancia_de_hit/CollisionShape2D").position.x *=-1
		flip_h = true
	
func conectar_HUD():
	interface.conectar_stamina(stamina)
	interface.conectar_vida(hp)

func timer_completo():
	can_attack = true
	
func timer_stamina():
	if stamina + stamina_to_increase > 100:
		stamina = 100
	else:
		stamina += stamina_to_increase

func _ready():
	timer.set_one_shot(true)
	timer.set_wait_time(attack_delay)
	timer.connect("timeout",self,"timer_completo")
	add_child(timer)
	
	stamina_timer.set_autostart(true)
	stamina_timer.set_one_shot(false)
	stamina_timer.set_wait_time(1)
	stamina_timer.connect("timeout",self,"timer_stamina")
	add_child(stamina_timer)

func _physics_process(delta):
	#Processa os movimentos e calcula a gravidade
	input()
	conectar_HUD()
	
##Se o inimigo entrou na área, seu alvo agora é esse
func _on_distancia_de_hit_body_entered(body):
	if body.is_in_group("enemy"):
		inimigo.append(body)
	
	
	#if body.is_in_group("flecha"):
	#	print("encontrou flecha")
	#	alvo_flecha = body
	

##Se o inimigo entrou na área mas saiu, seu alvo não é mais esse
func _on_distancia_de_hit_body_exited(body):
	if inimigo.has(body):
		inimigo.erase(body)
	if alvo_flecha == body:
		alvo_flecha = null

func _on_distancia_de_hit_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area.is_in_group("flecha"):
		alvo_flecha = area


func _on_distancia_de_hit_area_exited(area):
	if area == alvo_flecha:
		alvo_flecha = null
