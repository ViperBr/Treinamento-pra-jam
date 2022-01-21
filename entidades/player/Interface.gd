extends Control

func _ready():
	get_node("progresso_boss").hide()


func conectar_vida(vida):
	get_node("vida").text = "Vida :" + str(vida)
	get_node("progresso_vida").value = vida
	
func conectar_stamina(stamina):
	get_node("stamina").text = "Stamina :" + str(stamina)
	get_node("progresso_stamina").value = stamina

func conectar_vida_boss(vida,max_hp):
	get_node("progresso_boss").show()
	get_node("progresso_boss").max_value = max_hp
	get_node("progresso_boss").value = vida
