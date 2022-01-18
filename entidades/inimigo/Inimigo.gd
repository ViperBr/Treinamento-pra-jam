extends KinematicBody2D

var hp = 50
var damage = 15

const GRV = 25
const SPD = 100

var direction = -1
var initialpos = self.position
var pos = Vector2(0,position.y)


func attack():
	pass
	
func receive_damage():
	pass

func dead():
	pass

func _ready():
	direction = -1;
	$FloorDetector.position.x = $CollisionShape2D.shape.get_extents().x * direction;
	pass

func _process(delta):
	if is_on_wall() or not $FloorDetector.is_colliding(): 
		direction = direction * -1
		$FloorDetector.position.x = $CollisionShape2D.shape.get_extents().x * direction;
	
	pos.y += GRV  #gravidade agindo no inimigo.
	pos = move_and_slide(pos,Vector2.UP) #movendo o inimigo
	pos.x = SPD * direction
	pass
