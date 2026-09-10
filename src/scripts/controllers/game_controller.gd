extends Node

@export var quiz: QuizTheme
@export var color_right: Color
@export var color_wrong: Color

var buttons: Array[Button]
var index: int
var correct: int

var current_quiz: QuizQuestion:
	get: return quiz.theme[index]

@onready var question_text = %QuestionText
@onready var question_holder = %QuestionHolder
@onready var question_image = %QuestionImage
@onready var question_video = %QuestionVideo
@onready var question_audio = %QuestionAudio

func _ready() -> void:
	for alternativa in %Alternativas.get_children():
		for child in alternativa.get_children():
			if child is Button:
				buttons.append(child)
				#print("Botão: ", child.name)
	load_quiz()

	print("Total de botões encontrados: ", buttons.size())

func load_quiz() -> void:
	var question = current_quiz

	# muda o texto da label "question_text" para o valor da question_info
	question_text.text = question.question_info

	for i in range(min(buttons.size(), question.question_choices.size())):
		buttons[i].text = question.question_choices[i]
		buttons[i].pressed.connect(_buttons_answer.bind(buttons[i]))

	match current_quiz.question_type:
		Enum.QuestionType.TEXTO:
			question_holder.hide()

		Enum.QuestionType.IMAGEM:
			question_holder.show()
			question_image.texture = current_quiz.question_image

		Enum.QuestionType.VIDEO:
			question_holder.show()
			question_video.stream = current_quiz.question_video
			question_video.play()

		Enum.QuestionType.AUDIO:
			question_holder.show()
			question_image.texture = current_quiz.question_image
			question_audio.stream = current_quiz.question_audio
			question_audio.play()

func _buttons_answer(button: Button) -> void:
	if current_quiz.correct_answer == button.text:
		button.modulate = color_right
		%CorrectAnswerAudio.play()
	else:
		button.modulate = color_wrong
		%WrongAnswerAudio.play()
