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

	for check in alternativas.get_children():
		checkbox.append(check)

	var indices = gerar_indices_randomizados(pergunta.alternativas.size())

	for i in range(checkbox.size()):
		var indice_da_vez = indices[i]

		checkbox[i].text = pergunta.alternativas[indice_da_vez]
		checkbox[i].set_meta("indice_original", indice_da_vez)
		checkbox[i].pressed.connect(resposta_do_checkbox.bind(checkbox[i]))

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
