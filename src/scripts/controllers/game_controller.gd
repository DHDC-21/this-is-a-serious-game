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

	randomize_array(quiz.theme)
	load_quiz()

	print("Total de botões encontrados: ", buttons.size())

func load_quiz() -> void:
	if index >= quiz.theme.size():
		print("Quiz finalizado!")
		return

	var question = current_quiz

	# muda o texto da label "question_text" para o valor da question_info
	question_text.text = question.question_info

	var options = randomize_array(question.question_choices)
	for i in range(min(buttons.size(), question.question_choices.size())):
		buttons[i].text = options[i]
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

	_next_question()

func _next_question() -> void:
	for bt in buttons:
		bt.pressed.disconnect(_buttons_answer)

	await get_tree().create_timer(1.0).timeout

	for bt in buttons:
		bt.modulate = Color.WHITE

	question_audio.stop()
	question_video.stop()

	question_audio.stream = null
	question_video.stream = null

	index += 1
	load_quiz()

func randomize_array(array: Array) -> Array:
	var array_temp := array
	array_temp.shuffle()
	return array_temp
