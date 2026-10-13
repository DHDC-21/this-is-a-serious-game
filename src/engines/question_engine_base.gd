extends Control
class_name QuestionEngineBase

signal answered(correct: bool, points: int)

@onready var texto = %Texto
@onready var midia_container = %MidiaContainer
@onready var imagem = %Imagem
@onready var video = %Video
@onready var audio = %Audio


@onready var alternativas = %Alternativas
@onready var feedback = %FeedbackPanel

@onready var botao_confirmar: Button = %BotaoConfirmar

var pergunta: QuestionModel
var _confirmar: = false

@export_category("Cores")
@export var cor_correta: Color = Color(0, 1, 0)
@export var cor_errada: Color = Color(1, 0, 0)
@export var cor_selecao: Color = Color.YELLOW
@export var cor_normal: Color = Color(1, 1, 1)


# Função chamada quando o nó é adicionado à cena
func _ready() -> void:
	botao_confirmar.pressed.connect(_on_botao_confirmar_pressed)
	_on_ready()
	carregar_pergunta(pergunta)


func _on_ready() -> void:
	# Esta função pode ser sobrescrita nas classes filhas para inicializações específicas
	pass
	
func gerar_indices_randomizados(quantidade: int) -> Array:
	var indices = []
	for i in range(quantidade):
		indices.append(i)
	indices.shuffle()
	return indices


# Função para carregar a pergunta e seus elementos
func carregar_pergunta(q: QuestionModel) -> void:
	pergunta = q
	_confirmar = false
	texto.text = q.texto

	imagem.visible = false
	video.visible = false
	midia_container.visible = false

	match q.question_media_type:
		QuestionMediaType.QuestionMediaType.IMAGEM:
			imagem.texture = q.image
			imagem.visible = true
			midia_container.visible = true

		QuestionMediaType.QuestionMediaType.VIDEO:
			video.stream = q.video
			video.visible = true
			video.play()
			midia_container.visible = true

		QuestionMediaType.QuestionMediaType.AUDIO:
			imagem.texture = q.image
			imagem.visible = true
			midia_container.visible = true

			audio.stream = q.audio
			audio.play()

		_:
			pass

	feedback.visible = false
	_construir_as_alternativas()


var _last_correct: bool = false

func _on_botao_confirmar_pressed() -> void:
	if not _confirmar:
		var correcao := _checar_resposta()

		feedback.visible = true

		if correcao:
			# FEEDBACK POSITIVO
			_confirmar = true # Agora sim, bloqueia a troca de resposta
			feedback.modulate = cor_correta
			# Aqui você pode acessar o label do feedback para escrever "Correto!"
			feedback.get_node("FeedbackLabel").text = pergunta.feedback_correto


			for alt in alternativas.get_children():
				alt.set_disabled(true)

			botao_confirmar.text = "Próxima"
			_last_correct = true
		else:
			# FEEDBACK NEGATIVO
			_confirmar = false # Permite que o usuário tente de novo
			feedback.modulate = cor_errada
			feedback.get_node("FeedbackLabel").text = pergunta.feedback_incorreto
			_last_correct = false
	else:
		# Quando já confirmou e clicou em "Próxima"
		answered.emit(_last_correct, pergunta.pontuacao_base if _last_correct else 0)


# Função para construir as alternativas de resposta
func _construir_as_alternativas() -> void:
	push_error("Implementar a construção das alternativas de resposta na classe filha.")
	pass


func _checar_resposta() -> bool:
	push_error("Implementar a checagem da resposta na classe filha.")
	return false
