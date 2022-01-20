extends KinematicBody2D


##declarando variaveis
var hp = 400
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

onready var weapon = $AreaWeapon.get_child(0)
onready var areaAttR = $AreaWeapon.get_child(1)
onready var areaAttL = $AreaWeapon.get_child(2)
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
	timer.set_wait_time(2)
	timer.connect("timeout",self,"set_section_attacks",[state[0]])
	timer.start()
	pass 

func attack(attack):
	if attack == 0:
		attacking = true;
		sprite.play("dash")
		timer.disconnect("timeout", self,"set_section_attacks")
		timer.connect("timeout",self,"set_section_attacks",[state[0]])
		timer.set_wait_time(velatts)
		timer.start()
		weapon.position.x = 55 * direction
		pos.x = 400 * direction
	elif attack == 1:
		pos.y -= 200;
		attacking = true;
		sprite.play("attack")
		timer.disconnect("timeout", self,"set_section_attacks")
		timer.connect("timeout",self,"set_vulnerability")
		timer.set_wait_time(velatts*2)
		timer.start()
		areaAttL.position.x = lerp(1,-1200,4.0)
		areaAttR.position.x = lerp(1,1200,4.0)
		print_debug("ataque especial")
	pass

func receive_damage(damage):
	
	pass

func dead():
	
	pass


func set_vulnerability():
	attacking = false;
	sprite.play("stun")
	areaAttR.position.x = 1;
	areaAttL.position.x = 1;
	timer.disconnect("timeout", self,"set_vulnerability")
	timer.connect("timeout",self,"set_section_attacks",[state[0]])
	timer.set_wait_time(4)
	timer.start()
	pass

func set_section_attacks(att):
	print_debug(att)
	if att == "att":
		if hp < 200:
			velatts = 3;
			intatts = 1.5
		if hp < 100:
			velatts = 2;
			intatts = 1;
		if atts < 4:
			atts += 1;
			attack(0)
		else:
			atts = 0
			attack(1)
	else:
		attacking = false;
		timer.disconnect("timeout", self,"set_section_attacks")
		timer.connect("timeout",self,"set_section_attacks",[state[1]])
		timer.set_wait_time(intatts)
		timer.start()
		pos.x = 0;
		
		sprite.play("idle")
	pass

##função chamada a cada frame
func _process(delta):
	
	for i in $AreaWeapon.get_overlapping_bodies():
		if attacking and i == player and not player.stun_to_hitted:
			if player.damage > 5: 
				player.damage -= 5;
				damage += 5;
			player.receive_damage(damage)
	
	pos.y += GRV
	if player and player.position.x - self.position.x < -12:
			direction = -1;
			$AnimatedSprite.flip_h = false;
	if player and player.position.x - self.position.x > 12:
			direction = 1;
			$AnimatedSprite.flip_h = true;
	
	pos = move_and_slide(pos)
	
	
	pass
