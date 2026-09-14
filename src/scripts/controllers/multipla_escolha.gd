extends Control

var current_question: QuizQuestion = null
var selected_index: int = -1

func _ready() -> void:
	if GameState == null:
		push_error("GameState não foi encontrado.")
		return

	if not GameState.is_scene_valid_for_current_question(scene_file_path):
		GameState.load_current_question()
		return

	current_question = GameState.get_current_question()
	if current_question == null:
		GameState.finish_quiz()
		return

	_update_question_type_visibility()
	_render_question()

	for i in range(1, 6):
		var button: Button = get_node_or_null("Margem/VBox/Alternativas/Alternativa%d/ButtonOption%d" % [i, i]) as Button
		if button != null:
			button.pressed.connect(_on_choice_pressed.bind(i - 1))

func _update_question_type_visibility() -> void:
	if current_question == null:
		return

	var question_text: Label = get_node_or_null("Margem/VBox/Enunciado/QuestionText") as Label
	var question_holder: Panel = get_node_or_null("Margem/VBox/Enunciado/QuestionHolder") as Panel
	var question_image: TextureRect = get_node_or_null("Margem/VBox/Enunciado/QuestionHolder/QuestionImage") as TextureRect
	var question_video: VideoStreamPlayer = get_node_or_null("Margem/VBox/Enunciado/QuestionHolder/QuestionVideo") as VideoStreamPlayer
	var question_audio: AudioStreamPlayer = get_node_or_null("Margem/VBox/Enunciado/QuestionHolder/QuestionAudio") as AudioStreamPlayer

	if question_text == null:
		return

	var type := current_question.question_type
	var should_show_media := type != Enum.QuestionType.TEXTO

	if question_holder != null:
		question_holder.visible = should_show_media

	if question_image != null:
		question_image.visible = type == Enum.QuestionType.IMAGEM

	if question_video != null:
		question_video.visible = type == Enum.QuestionType.VIDEO
		if type != Enum.QuestionType.VIDEO:
			question_video.stop()

	if question_audio != null:
		if type == Enum.QuestionType.AUDIO:
			question_audio.stream_paused = false
		else:
			question_audio.stop()
			question_audio.stream_paused = true

	question_text.visible = true
	question_text.add_theme_font_size_override("font_size", 32)

func _apply_feedback(is_correct: bool) -> void:
	var feedback_box: TextEdit = get_node_or_null("Margem/VBox/Feedback") as TextEdit
	if feedback_box == null:
		return

	feedback_box.visible = true
	feedback_box.focus_mode = Control.FOCUS_NONE
	feedback_box.editable = false
	feedback_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	feedback_box.add_theme_font_size_override("font_size", 32)
	feedback_box.text = current_question.get_selected_correct_feedback() if is_correct else current_question.get_selected_wrong_feedback()

	if is_correct:
		feedback_box.add_theme_color_override("font_color", Color(0.18, 0.85, 0.34))
		feedback_box.add_theme_color_override("font_readonly_color", Color(0.18, 0.85, 0.34))
		feedback_box.modulate = Color(0.18, 0.85, 0.34)
	else:
		feedback_box.add_theme_color_override("font_color", Color(0.88, 0.25, 0.25))
		feedback_box.add_theme_color_override("font_readonly_color", Color(0.88, 0.25, 0.25))
		feedback_box.modulate = Color(0.88, 0.25, 0.25)

func _render_question() -> void:
	if current_question == null:
		return

	var label: Label = get_node_or_null("Margem/VBox/Enunciado/QuestionText") as Label
	if label != null:
		label.text = current_question.question_info

	for i in range(1, 6):
		var button: Button = get_node_or_null("Margem/VBox/Alternativas/Alternativa%d/ButtonOption%d" % [i, i]) as Button
		var item_label: Label = get_node_or_null("Margem/VBox/Alternativas/Alternativa%d/Label%d" % [i, i]) as Label
		if button == null:
			continue
		button.visible = i - 1 < current_question.question_choices.size()
		button.text = "" if i - 1 >= current_question.question_choices.size() else current_question.question_choices[i - 1]
		if item_label != null:
			item_label.visible = i - 1 < current_question.question_choices.size()
			if i - 1 < current_question.question_choices.size():
				item_label.text = char(97 + (i - 1)) + "."

	var feedback_box: TextEdit = get_node_or_null("Margem/VBox/Feedback") as TextEdit
	if feedback_box != null:
		feedback_box.visible = false

func _on_choice_pressed(index: int) -> void:
	selected_index = index
	_submit_answer()

func _submit_answer() -> void:
	if current_question == null:
		return
	if selected_index < 0 or selected_index >= current_question.question_choices.size():
		return

	var is_correct := current_question.is_correct_choice(selected_index)
	_apply_feedback(is_correct)

	if is_correct:
		GameState.current_score += max(current_question.base_points, 0)
		await get_tree().create_timer(1.2).timeout
		GameState.advance_to_next_question()
	else:
		# Permite retry na mesma pergunta, como o Duolingo.
		selected_index = -1
		for i in range(1, 6):
			var button: Button = get_node_or_null("Margem/VBox/Alternativas/Alternativa%d/ButtonOption%d" % [i, i]) as Button
			if button != null:
				button.disabled = false
