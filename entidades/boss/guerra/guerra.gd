extends KinematicBody2D


##declarando variaveis
var hp = 300
var damage = 25

const GRV = 25
const SPD = 100

var atts = 0;
var velatts = 0.3;
var intatts = 2;
var state =  ["idle","att"]
var direction = -1
var initialpos = self.position
var pos = Vector2(0,position.y);
var attacking = false;
var specialatt = false;
var is_stunning = false;

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
	if attack == 0:
		attacking = true;
		sprite.play("dash")
		timer.disconnect("timeout", self,"set_section_attacks")
		timer.connect("timeout",self,"set_section_attacks",[state[0]])
		timer.set_wait_time(velatts)
		timer.start()
		weapon.position.x = 55 * direction
		pos.x = 1000 * direction
	elif attack == 1:
		specialatt = true;
		sprite.play("attack")
		timer.disconnect("timeout", self,"set_section_attacks")
		timer.connect("timeout",self,"set_vulnerability")
		timer.set_wait_time(velatts*2)
		timer.start()
		print_debug("ataque especial")
	pass

func receive_damage(damage):
	print_debug("chega aqui no recieve")
	if hp - damage < 0:
		hp = 0;
		sprite.speed_scale = 1.3
		sprite.play("dead")
		timer.disconnect("timeout", self,"set_section_attacks")
		timer.connect("timeout",self,"dead")
		timer.set_wait_time(1)
		timer.start()
	else:
		hp -=  damage
		specialatt = false
		sprite.play("damage")
		timer.connect("timeout",self,"set_section_attacks",[state[0]])
		timer.set_wait_time(1)
		timer.start()
	pass

func dead():
	
	pass


func set_vulnerability():
	attacking = false;
	is_stunning = true;
	sprite.play("stun")
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
		specialatt = false;
		is_stunning = false;
		timer.disconnect("timeout", self,"set_section_attacks")
		timer.connect("timeout",self,"set_section_attacks",[state[1]])
		timer.set_wait_time(intatts)
		timer.start()
		pos.x = 0;
		sprite.play("idle")
	pass

##função chamada a cada frame
func _process(delta):
	
	for i in get_slide_count():
		print_debug(get_slide_collision(i))
	
	for i in $AreaWeapon.get_overlapping_bodies():
		
			
		if (specialatt or attacking) and i == player and not player.stun_to_hitted:
			player.receive_damage(damage)
			continue
	
	pos.y += GRV
	if player and player.position.x - self.position.x < -12:
			direction = -1;
			$AnimatedSprite.flip_h = false;
	if player and player.position.x - self.position.x > 12:
			direction = 1;
			$AnimatedSprite.flip_h = true;
	
	pos = move_and_slide(pos)
	
	
	pass
