extends Area2D

var direction = 1
const SPD = 300

var archer = preload("res://entidades/inimigo/archer/archer.gd").new()


func _process(delta):
	if direction > 0:
		get_node("Sprite").flip_h = false
		position.x += SPD * delta
	if direction < 0:
		get_node("Sprite").flip_h = true
		position.x -= SPD * delta


func _on_archer_arrow_body_entered(body):
	if body.is_in_group("player"):
		body.receive_damage(archer.damage)
	
	queue_free()
