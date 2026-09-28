extends Control

@onready var text = %Texto
@onready var image = %Imagem
@onready var video = %Video
@onready var audio = %Audio

@onready var alternativas = %Alternativas
@onready var feedback = %FeedbackPanel

@onready var botao_confirmar: Button = %BotaoConfirmar

@export var teste: QuestionModel
var pergunta: QuestionModel
var _confirmar: Bool = false


# Função chamada quando o nó é adicionado à cena
func _ready() -> void:
	botao_confirmar.pressed.connect(_on_botao_confirmar_pressed)

	if teste:
		carregar_pergunta(teste)


# Função para carregar a pergunta e seus elementos
func carregar_pergunta(q: QuestionModel) -> void:
	question = q
	_confirmar = false
	text.text = q.texto

	imagem.visible = false
	video.visible = false

	match q.question_media_type:
		QuestionMediaType.QuestionMediaType.IMAGE:
			imagem.texture = q.imagem
			imagem.visible = true

		QuestionMediaType.QuestionMediaType.VIDEO:
			video.stream = q.video
			video.visible = true
			video.play()

		QuestionMediaType.QuestionMediaType.AUDIO:
			imagem.texture = q.imagem
			imagem.visible = true

			audio.stream = q.audio
			audio.play()

		_:
			pass

	feedback.visible = false
	_construir_as_alternativas()


func _on_botao_confirmar_pressed() -> void:
	if not _confirmar:
		var correcao := _checar_resposta()
		_confirmar = true

		for alt in alternativas.get_children():
			alt.set_disabled(true)

		# feedback.get_node("FeedbackLabel").tetxt = pergunta.feedback
		feedback.visible = true
		botao_confirmar.text = "Proxima"

		_last_correct = correcao

		else:
			answered.emit(_last_correct, question.pontuacao_base if _last_correct else 0)
var _last_correct: bool = false


# Função para construir as alternativas de resposta
func _construir_as_alternativas() -> void:
	push_error("Implementar a construção das alternativas de resposta na classe filha.")
	pass


func _checar_resposta() -> bool:
	push_error("Implementar a checagem da resposta na classe filha.")
	return false
