extends KinematicBody2D

var hp = 70
var damage = 20

const GRV = 25
const SPD = 100

var direction = -1
var initialpos = self.position
var pos = Vector2(0,position.y);

onready var player = get_node("/root/Main/Player");

func attack():
	direction = 0
	$AnimatedSprite.speed_scale = 1;
	$AnimatedSprite.play("attack")
	pass
	
func receive_damage():
	pass

func dead():
	pass

func _ready():
	direction = 0;
	$AnimatedSprite.flip_h = !$AnimatedSprite.flip_h;
	pass

func _process(delta):
	if player and player.position.x - self.position.x < -12 and player.position.x - self.position.x > -100:
		$AnimatedSprite.flip_h = true;
	if player and player.position.x - self.position.x > 12 and player.position.x - self.position.x < 100:
		$AnimatedSprite.flip_h = false;
		
	if player and player.position.x - self.position.x < 1200 and player.position.x - self.position.x > 500: 
		direction = 1;
		$AnimatedSprite.flip_h = false;
		$AnimatedSprite.speed_scale = 2;
		$AnimatedSprite.play('walk')
	elif player and player.position.x - self.position.x > -1200 and player.position.x - self.position.x < -500:
		direction = -1;
		$AnimatedSprite.flip_h = true;
		$AnimatedSprite.speed_scale = 2;
		$AnimatedSprite.play('walk')
	elif player and (player.position.x - self.position.x < -1200 or player.position.x - self.position.x > 1200):
		direction = 0;
		$AnimatedSprite.speed_scale = 2;
		$AnimatedSprite.play('idle');
	else:
		attack();
	
	pos.y += GRV  #gravidade agindo no inimigo.
	pos = move_and_slide(pos,Vector2.UP) #movendo o inimigo
	pos.x = SPD * direction #indicando a posição do inimigo
	
	
	
	pass