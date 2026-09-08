extends Node

@export var quiz: QuizTheme
@export var color_right: Color
@export var color_wrong: Color

var buttons: Array[Button]
var index: int
var correct: int

@onready var question_texts = $Content/QuestionInfo/QuestionText
@onready var question_image = $Content/QuestionInfo/QuestionHolder/QuestionImage
@onready var question_video = $Content/QuestionInfo/QuestionHolder/QuestionVideo
@onready var question_audio = $Content/QuestionInfo/QuestionHolder/AudioStreamPlayer

func _ready() -> void:
	for button in $Content/QuestionInfo/QuestionHolder.get_children():
		buttons.append(button)

	load_quiz()

func load_quiz() -> void:
	question_texts.text = quiz.theme[index].question_info

	var options = quiz.theme[index].options
	for i in buttons.size():
		buttons[i].text = options[i]
		# buttons[i].text = quiz.theme[index].options[i]
