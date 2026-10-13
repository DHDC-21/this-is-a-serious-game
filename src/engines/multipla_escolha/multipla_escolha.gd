extends QuestionEngineBase
class_name MultiplaEscolhaEngine

var botoes: Array[Button] = []
var indice_resposta_selecionada: int = -1

@export_category("Teste")
@export var teste: MultiplaEscolhaModel

func _on_ready() -> void:
	if teste:
		pergunta = teste

func _construir_as_alternativas() -> void:
	botoes.clear()

	for botao in alternativas.get_children():
		botoes.append(botao)

	# Agora usamos a função da classe pai para obter os índices embaralhados
	var indices = gerar_indices_randomizados(pergunta.alternativas.size())

	for i in range(botoes.size()):
		var indice_da_vez = indices[i]

		botoes[i].text = pergunta.alternativas[indice_da_vez]
		botoes[i].set_meta("indice_original", indice_da_vez)
		botoes[i].pressed.connect(resposta_do_botao.bind(botoes[i]))

func resposta_do_botao(botao: Button) -> void:
	if not _confirmar:
		for b in botoes:
			b.modulate = cor_normal

		botao.modulate = cor_selecao

		indice_resposta_selecionada = botao.get_meta("indice_original")

func _checar_resposta() -> bool:
	if indice_resposta_selecionada == -1:
		return false

	return indice_resposta_selecionada == pergunta.alternativa_correta
