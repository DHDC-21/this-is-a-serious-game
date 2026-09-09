extends Node

@export var quiz: QuizTheme
@export var color_right: Color
@export var color_wrong: Color

var buttons: Array[Button]
var index: int
var correct: int

@onready var question_texts = %QuestionText
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
	var question = quiz.theme[index]

	# muda o texto da label "question_text" para o valor da question_info
	question_texts.text = question.question_info

	for i in range(min(buttons.size(), question.question_choices.size())):
		buttons[i].text = question.question_choices[i]
		buttons[i].pressed.connect(_buttons_answer.bind(buttons[i]))

func _buttons_answer(button: Button) -> void:
	if quiz.theme[index].correct_answer == button.text:
		button.modulate = color_right
	else:
		button.modulate = color_wrong
