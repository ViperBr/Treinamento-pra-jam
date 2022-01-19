extends KinematicBody2D

var hp = 50
var damage = 15

const GRV = 25
const SPD = 100

var direction = -1
var initialpos = self.position
var pos = Vector2(0,position.y);

onready var player = get_node("/root/Main/Player");

func attack():
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
	
	if player and player.position.x - self.position.x < 500 and player.position.x - self.position.x > 70: 
		direction = 1;
		$AnimatedSprite.flip_h = false;
		$AnimatedSprite.play('walk')		
	elif player and player.position.x - self.position.x >-500 and player.position.x - self.position.x < -70:
		direction = -1;
		$AnimatedSprite.flip_h = true;
		$AnimatedSprite.play('walk')
	elif player.position.x - self.position.x <-500 or player.position.x - self.position.x > 500:
		direction = 0;
		$AnimatedSprite.play('idle');
	else:
		attack();
	
	pos.y += GRV  #gravidade agindo no inimigo.
	pos = move_and_slide(pos,Vector2.UP) #movendo o inimigo
	pos.x = SPD * direction #indicando a posição do inimigo
	
	
	
	pass
