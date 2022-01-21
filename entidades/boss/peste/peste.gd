extends KinematicBody2D


##declarando variaveis
var hp = 300
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
	if attack == 0:
		attacking = true;
		sprite.play("dash")
		timer.disconnect("timeout", self,"set_section_attacks")
		timer.connect("timeout",self,"set_section_attacks",[state[0]])
		timer.set_wait_time(velatts)
		timer.start()
		weapon.position.x = 25 * direction
		pos.x = 200 * direction
	elif attack == 1:
		specialatt = true;
		sprite.play("attack")
		weapon.get_child(0).play("att")
		timer.disconnect("timeout", self,"set_section_attacks")
		timer.connect("timeout",self,"set_vulnerability")
		timer.set_wait_time(velatts*2)
		timer.start()
		print_debug("ataque especial")
	pass

func receive_damage(damage):
	print_debug("Ai recebi dano")
	pass

func dead():
	pass
	
func set_vulnerability():
	attacking = false;
	sprite.play("stun")
	timer.disconnect("timeout", self,"set_vulnerability")
	timer.connect("timeout",self,"set_section_attacks",[state[0]])
	timer.set_wait_time(4)
	timer.start()
	pass

func set_section_attacks(att):
	
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
	if specialatt and not reback and weapon.position.x < 400 and weapon.position.x > -400:
		weapon.position.x = weapon.position.x + 2 * direction;
	elif specialatt and reback:
		print_debug("Valor do reback é:" + reback)
		weapon.position.x = weapon.position.x - 2 * direction;
	
	for i in $AreaWeapon.get_overlapping_bodies():
		if specialatt and reback and i == self:
			receive_damage(damage)
			set_section_attacks(state[0])
		if (specialatt or attacking) and i == player and not player.stun_to_hitted:
			player.receive_damage(damage)
			player.poisoning = true
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
