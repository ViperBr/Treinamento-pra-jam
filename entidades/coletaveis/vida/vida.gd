extends KinematicBody2D
const grv = 30;
var life_to_increase = 50
onready var player = get_node("/root/Main/Player");
var phy = Vector2(0,grv)

func give_life():
	queue_free()

func _process(delta):
	if not is_on_floor(): 
		phy.y += grv;
	if player:
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if collision.collider.name == "Player":
				player.life_increase(life_to_increase)
				give_life()
	
	phy = move_and_slide(phy, Vector2.UP);
	pass
