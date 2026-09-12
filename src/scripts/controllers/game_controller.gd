extends Node

@export var quiz: QuizTheme
@export var color_right: Color
@export var color_wrong: Color

var answer_buttons: Array[Control] = []
var current_index: int = 0
var last_selected_index: int = -1
var submit_button: Button = null
var is_multiple_choice_scene: bool = false

var current_quiz: QuizQuestion:
	get:
		if current_index >= quiz.theme.size():
			return null
		return quiz.theme[current_index]

@onready var question_text = %QuestionText
@onready var question_holder = %QuestionHolder
@onready var question_image = %QuestionImage
@onready var question_video = %QuestionVideo
@onready var question_audio = %QuestionAudio
@onready var feedback_label: TextEdit = get_node_or_null("%Feedback")
@onready var answer_container: VBoxContainer = $Margem/VBox/Alternativas

func _ready() -> void:
	_collect_answer_buttons()
	_connect_submit_button()
	if quiz != null:
		randomize_array(quiz.theme)
	_load_question()

func _collect_answer_buttons() -> void:
	answer_buttons.clear()
	is_multiple_choice_scene = false

	for child in answer_container.get_children():
		if child is CheckBox:
			answer_buttons.append(child)
			child.button_pressed = false
			child.modulate = Color.WHITE
			if child.toggled.is_connected(_on_checkbox_toggled):
				child.toggled.disconnect(_on_checkbox_toggled)
			child.toggled.connect(_on_checkbox_toggled.bind(child))
			continue

		if child is HBoxContainer:
			for option_child in child.get_children():
				if option_child is Button:
					answer_buttons.append(option_child)
					is_multiple_choice_scene = true
					if option_child.pressed.is_connected(_on_answer_pressed):
						option_child.pressed.disconnect(_on_answer_pressed)
					option_child.pressed.connect(_on_answer_pressed.bind(option_child))

func _connect_submit_button() -> void:
	submit_button = get_node_or_null("%SubmitButton")
	if submit_button != null and not submit_button.pressed.is_connected(_submit_answer):
		submit_button.pressed.connect(_submit_answer)

func _load_question() -> void:
	if current_quiz == null:
		print("Quiz finalizado!")
		return

	var question: QuizQuestion = current_quiz
	question_text.text = question.question_info
	if feedback_label:
		feedback_label.text = ""
		feedback_label.visible = false
	if submit_button != null:
		submit_button.disabled = false

	_reset_option_buttons()

	var options := randomize_array(question.question_choices)
	for i in range(min(answer_buttons.size(), options.size())):
		var control: Control = answer_buttons[i]
		if control is CheckBox:
			control.text = options[i]
			control.button_pressed = false
			control.visible = true
			control.disabled = false
		else:
			control.text = options[i]
			control.disabled = false
			control.visible = true

	for i in range(answer_buttons.size() - 1, options.size() - 1, -1):
		var control: Control = answer_buttons[i]
		control.visible = false
		control.disabled = true

	match question.question_type:
		Enum.QuestionType.TEXTO:
			question_holder.hide()
		Enum.QuestionType.IMAGEM:
			question_holder.show()
			question_image.texture = question.question_image
			question_video.stop()
			question_audio.stop()
		Enum.QuestionType.VIDEO:
			question_holder.show()
			question_video.stream = question.question_video
			question_video.play()
			question_image.texture = null
			question_audio.stop()
		Enum.QuestionType.AUDIO:
			question_holder.show()
			question_image.texture = null
			question_audio.stream = question.question_audio
			question_audio.play()
			question_video.stop()

func _on_checkbox_toggled(is_on: bool, option: CheckBox) -> void:
	if current_quiz == null:
		return
	if current_quiz.engine != Enum.QuestionEngine.SELECAO_MULTIPLA:
		for control in answer_buttons:
			if control is CheckBox and control != option:
				control.button_pressed = false

func _on_answer_pressed(button: Button) -> void:
	last_selected_index = answer_buttons.find(button)
	if submit_button == null:
		_submit_answer()

func _submit_answer() -> void:
	if current_quiz == null:
		return

	var selected_indices: Array[int] = []
	if is_multiple_choice_scene:
		if last_selected_index >= 0:
			selected_indices = [last_selected_index]
	else:
		for i in range(answer_buttons.size()):
			if answer_buttons[i] is CheckBox and answer_buttons[i].button_pressed:
				selected_indices.append(i)

	if selected_indices.is_empty():
		return

	if submit_button != null:
		submit_button.disabled = true

	var is_correct: bool
	if current_quiz.engine == Enum.QuestionEngine.SELECAO_MULTIPLA:
		is_correct = current_quiz.is_correct_selection(selected_indices)
	else:
		is_correct = current_quiz.is_correct_choice(selected_indices[0])

	for i in range(answer_buttons.size()):
		if not answer_buttons[i].visible:
			continue

		if answer_buttons[i] is CheckBox:
			if is_correct:
				if current_quiz.engine == Enum.QuestionEngine.SELECAO_MULTIPLA:
					answer_buttons[i].modulate = color_right if current_quiz.correct_answers.has(i) else Color.WHITE
				else:
					answer_buttons[i].modulate = color_right if i == current_quiz.correct_choice else Color.WHITE
			else:
				answer_buttons[i].modulate = color_wrong if answer_buttons[i].button_pressed else Color.WHITE
		else:
			if is_correct:
				answer_buttons[i].modulate = color_right if i == selected_indices[0] else Color.WHITE
			else:
				answer_buttons[i].modulate = color_wrong if i == selected_indices[0] else Color.WHITE

	if is_correct:
		if feedback_label != null:
			feedback_label.text = current_quiz.get_selected_correct_feedback()
		if %CorrectAnswerAudio != null:
			%CorrectAnswerAudio.play()
	else:
		if feedback_label != null:
			feedback_label.text = current_quiz.get_selected_wrong_feedback()
		if %WrongAnswerAudio != null:
			%WrongAnswerAudio.play()

	if feedback_label != null:
		feedback_label.visible = true
	_next_question()

func _next_question() -> void:
	await get_tree().create_timer(1.0).timeout

	for control in answer_buttons:
		if control is CheckBox:
			control.button_pressed = false
		control.modulate = Color.WHITE

	if question_audio != null:
		question_audio.stop()
	if question_video != null:
		question_video.stop()
	if question_audio != null:
		question_audio.stream = null
	if question_video != null:
		question_video.stream = null
	if question_image != null:
		question_image.texture = null

	current_index += 1
	_load_question()

func _reset_option_buttons() -> void:
	last_selected_index = -1
	for control in answer_buttons:
		if control is CheckBox:
			control.button_pressed = false
		control.modulate = Color.WHITE
		control.disabled = false
		control.visible = true

func randomize_array(array: Array) -> Array:
	var shuffled := array.duplicate()
	shuffled.shuffle()
	return shuffled
