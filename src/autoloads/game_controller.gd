extends Node

var index_atual: int = 0
var fases: Array[QuestionModel] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func start_game(lista_de_fases: Array[QuestionModel]) -> void:
	print("Iniciando o jogo com ", lista_de_fases.size(), " fases.")

	fases = lista_de_fases
	fases.shuffle()  # Embaralha a lista de fases
	index_atual = 0

	carregar_pergunta_atual()

func carregar_pergunta_atual() -> void:
	print("Carregando pergunta atual: ", index_atual)

	var pergunta_atual = fases[index_atual]
	var caminho_da_engine: String = ""

	if pergunta_atual is MultiplaEscolhaModel:
		caminho_da_engine = "res://src/engines/multipla_escolha/multipla_escolha.tscn"

	elif pergunta_atual is SelecaoMultiplaModel:
		caminho_da_engine = "res://src/engines/selecao_multipla/selecao_multipla.tscn"


	elif pergunta_atual is VerdadeiroOuFalsoModel:
		caminho_da_engine = "res://src/engines/verdadeiro_falso/verdadeiro_falso.tscn"

	else:
		print("Erro: Tipo de pergunta não suportado: ", pergunta_atual)
		return

	print("Carregando engine: ", caminho_da_engine)
	get_tree().change_scene_to_file(caminho_da_engine)

func carregar_proxima_pergunta() -> void:
	index_atual += 1

	if index_atual < fases.size():
		carregar_pergunta_atual()
	else:
		print("Fim do jogo! Todas as perguntas foram respondidas.")
		get_tree().change_scene_to_file("res://src/ui/placar/placar.tscn")
