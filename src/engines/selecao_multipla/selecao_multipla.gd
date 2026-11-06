extends QuestionEngineBase
class_name SelecaoMultiplaEngine

var checkbox: Array[Button] = []
var indices_respostas_selecionadas: Array[int] = []

@export_category("Teste")
@export var teste: SelecaoMultiplaModel

func _on_ready() -> void:
	if teste:
		pergunta = teste

func _construir_as_alternativas() -> void:
	if pergunta == null or pergunta.alternativas.size() == 0:
		print("Erro: A pergunta não possui alternativas definidas!")
		return

	checkbox.clear()
	
	# Pega todos os botões iniciais
	for check in alternativas.get_children():
		if check is Button:
			checkbox.append(check)

	var qtd_alternativas = pergunta.alternativas.size()
	
	# Se houver mais alternativas do que botões, criamos novos
	if qtd_alternativas > checkbox.size():
		var botao_modelo = checkbox[0] # Usa o primeiro botão como modelo
		for i in range(checkbox.size(), qtd_alternativas):
			var novo_botao = botao_modelo.duplicate()
			alternativas.add_child(novo_botao)
			checkbox.append(novo_botao)

	var indices = gerar_indices_randomizados(qtd_alternativas)

	for i in range(checkbox.size()):
		if i < qtd_alternativas:
			var indice_da_vez = indices[i]
			checkbox[i].text = pergunta.alternativas[indice_da_vez]
			checkbox[i].set_meta("indice_original", indice_da_vez)
			
			# Limpa conexões antigas para evitar duplicidade ao reutilizar botões
			for connection in checkbox[i].pressed.get_connections():
				checkbox[i].pressed.disconnect(connection.callable)
				
			checkbox[i].pressed.connect(resposta_do_checkbox.bind(checkbox[i]))
			checkbox[i].visible = true
		else:
			checkbox[i].visible = false

func resposta_do_checkbox(check: Button) -> void:
	if not _confirmar:
		var indice = check.get_meta("indice_original")

		if indices_respostas_selecionadas.has(indice):
			indices_respostas_selecionadas.erase(indice)
			check.modulate = cor_normal
		else:
			indices_respostas_selecionadas.append(indice)
			check.modulate = cor_selecao

func _checar_resposta() -> bool:
	return 0
