extends KinematicBody2D


##declarando variaveis
var max_hp = 500
var hp = 500
var damage = 5

const GRV = 25
const SPD = 100

var atts = 0;
var velatts = 1;
var intatts = 2;
var state =  ["idle","att"]
var direction = -1
var initialpos = self.position
var pos = Vector2(0,position.y);
var attacking = false;
var specialatt = false;
var reback = false;

onready var weapon = $AreaWeapon.get_child(0)
onready var player
onready var sprite = $AnimatedSprite
onready var interval = $Interval
onready var timer = $Timer
onready var dead: = false
var cycle = 0;
var rng = RandomNumberGenerator.new()


## função chamada no início da cena
func _ready():
	for p in get_tree().get_nodes_in_group("player"):
		player = p
	rng.randomize()
	timer.set_one_shot(true)
	timer.set_wait_time(4)
	timer.connect("timeout",self,"set_section_attacks",[state[0]])
	timer.start()
	pass 

func attack(attack):
	if not dead:
		if attack == 0:
			attacking = true;
			sprite.play("dash")
			timer.disconnect("timeout", self,"set_section_attacks")
			timer.connect("timeout",self,"set_section_attacks",[state[0]])
			timer.set_wait_time(1)
			timer.start()
			weapon.position.x = 25 * direction
			pos.x = 200 * direction * velatts
		elif attack == 1:
			specialatt = true;
			sprite.play("attack")
			weapon.get_child(0).play("att")
			timer.disconnect("timeout", self,"set_section_attacks")
			timer.connect("timeout",self,"set_vulnerability")
			timer.set_wait_time(2)
			timer.start()
			#print_debug("ataque especial")
	pass

func receive_damage(damage):
	if hp - damage >= 0:
		print_debug("recebi dano!")
		hp -= damage
		attacking = false;
		specialatt = false;
		reback = false;
		weapon.position.x = 0
		weapon.get_child(0).play("default")
		sprite.play("stun")
		timer.disconnect("timeout", self,"set_section_attacks")
		timer.connect("timeout",self,"set_section_attacks",[state[0]])
		timer.set_wait_time(intatts)
		timer.start()
		print_debug("hp")
	else:
		hp = 0;
		timer.disconnect("timeout", self,"set_section_attacks")
		timer.connect("timeout",self,"dead")
		timer.set_wait_time(intatts)
		timer.start()
		sprite.play("dead")
	pass

func dead():
	dead = true
	sprite.play("dead")
	pass
	
func set_vulnerability():
	if not dead:
		attacking = false;
		sprite.play("stun")
		timer.disconnect("timeout", self,"set_vulnerability")
		timer.connect("timeout",self,"set_section_attacks",[state[0]])
		timer.set_wait_time(4)
		timer.start()
	pass

func set_section_attacks(att):
	if not dead:
		if att == "att":
			if hp < 200:
				velatts = 2;
				intatts = 1.5
			if hp < 100:
				velatts = 3;
				intatts = 1;
			if atts < 4:
				atts += 1;
				attack(0)
			else:
				atts = 0
				attack(1)
		else:
			attacking = false;
			specialatt = false;
			reback = false;
			timer.disconnect("timeout", self,"set_section_attacks")
			timer.connect("timeout",self,"set_section_attacks",[state[1]])
			timer.set_wait_time(intatts)
			timer.start()
			weapon.get_child(0).play("default")
			weapon.position.x = 0;
			pos.x = 0;
			sprite.play("idle")
		pass

##função chamada a cada frame
func _process(delta):
	if not dead:
		if specialatt and not reback and weapon.position.x < 400 and weapon.position.x > -400:
			weapon.position.x = weapon.position.x + 3 * direction + velatts;
		elif specialatt and reback:
			weapon.position.x = weapon.position.x - 6 * direction + velatts;
		
		for i in $AreaWeapon.get_overlapping_bodies():
			if specialatt and reback and weapon.position.x - sprite.position.x > -20 and weapon.position.x - sprite.position.x < 20 and i == sprite.get_parent().get_child(2):
				receive_damage(25)
			
			if specialatt and i == player and player.attacking and not reback:
				reback = true
			if (specialatt or attacking) and i == player and not player.stun_to_hitted and not reback:
				player.receive_damage(damage)
				player.poisoning = player.poisoning + 1
				#print_debug(player.poisoning)
	
	pos.y += GRV
	if player and player.position.x - self.position.x < -12:
			direction = -1;
			$AnimatedSprite.flip_h = true;
	if player and player.position.x - self.position.x > 12:
			direction = 1;
			$AnimatedSprite.flip_h = false;
	
	pos = move_and_slide(pos)
	
	
	pass
