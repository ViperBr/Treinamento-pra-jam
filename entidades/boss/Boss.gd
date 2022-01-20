extends KinematicBody2D


##declarando variaveis
var hp = 300
var damage = 25

const GRV = 25
const SPD = 100

var direction = -1
var initialpos = self.position
var pos = Vector2(0,position.y);

onready var player
onready var timer = 0
onready var dead: = false
var cycle = 0;


## função chamada no início da cena
func _ready():
	pass 

func attack():
	
	pass

func receive_damage(damage):
	
	pass

func dead():
	
	pass

##função chamada a cada frame
func _process(delta):
	yield(get_tree().create_timer(20), "time_out")
	
	pass
