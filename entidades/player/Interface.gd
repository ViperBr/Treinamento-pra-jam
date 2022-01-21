extends Control

func conectar_vida(vida):
	get_node("vida").text = "Vida :" + str(vida)
	get_node("progresso_vida").value = vida
	
	
func conectar_stamina(stamina):
	get_node("stamina").text = "Stamina :" + str(stamina)
	get_node("progresso_stamina").value = stamina
