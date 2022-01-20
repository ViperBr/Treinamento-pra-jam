extends KinematicBody2D

var hp = 60
var damage = 20

const GRV = 25
const SPD = 100

var direction = -1
var initialpos = self.position
var pos = Vector2(0,position.y);

onready var player
onready var timer = 0
onready var dead: = false
onready var timer_pra_sumir

func attack():
	direction = 0;
	timer += 1 * get_physics_process_delta_time()
	if timer >= 1:
		$AnimatedSprite.play("attack")
		player.receive_damage(damage)
		timer = 0
	
func receive_damage(damage):
	if hp - damage <= 0:
		dead()
	else:
		hp -= damage

func dead():
	dead = true
	$AnimatedSprite.play("dead")
	$CollisionShape2D.disabled = true
	timer_pra_sumir.start()

func _ready():
	direction = 0;
	$AnimatedSprite.flip_h = !$AnimatedSprite.flip_h;
	for p in get_tree().get_nodes_in_group("player"):
		player = p
	timer_pra_sumir = Timer.new()
	timer_pra_sumir.set_one_shot(true)
	timer_pra_sumir.set_wait_time(1)
	timer_pra_sumir.connect("timeout",self,"sumir")
	add_child(timer_pra_sumir)
	
func sumir():
	print("dei queue_free()")
	queue_free()


func _process(delta):
	
	if not dead:
		if player and player.position.x - self.position.x < 500 and player.position.x - self.position.x > 100: 
			direction = 1;
			$AnimatedSprite.flip_h = false;
			$AnimatedSprite.play('walk')
		elif player and player.position.x - self.position.x >-500 and player.position.x - self.position.x < -100:
			direction = -1;
			$AnimatedSprite.flip_h = true;
			$AnimatedSprite.play('walk')
		elif player and (player.position.x - self.position.x <-500 or player.position.x - self.position.x > 500):
			direction = 0;
			$AnimatedSprite.play('idle');
		else:
			attack();
	
	pos.y += GRV  #gravidade agindo no inimigo.
	pos = move_and_slide(pos,Vector2.UP) #movendo o inimigo
	pos.x = SPD * direction #indicando a posição do inimigo
	pass


	
