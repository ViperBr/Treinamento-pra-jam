extends Control

func conectar_vida(vida):
	get_node("vida").text = "Vida :" + str(vida)
	
	
func conectar_stamina(stamina):
	get_node("stamina").text = "Stamina :" + str(stamina)
