extends KinematicBody2D
const grv = 30;
var stamina_to_increase = 50
onready var player
var phy = Vector2(0,grv)

func give_stamina():
	queue_free()

func _ready():
	for p in get_tree().get_nodes_in_group("player"):
		player = p
		
func _process(delta):
	
	if not is_on_floor(): 
		phy.y += grv;
	if player:
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if collision.collider.name == "Player":
				player.stamina_increase(stamina_to_increase)
				give_stamina()
	
	phy = move_and_slide(phy, Vector2.UP);
