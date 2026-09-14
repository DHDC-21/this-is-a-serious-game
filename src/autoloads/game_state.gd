extends Node

var current_quiz: QuizTheme = null
var current_question_index: int = 0
var current_score: int = 0
var total_questions: int = 0
var total_question_points: int = 0

func reset_round() -> void:
	current_quiz = null
	current_question_index = 0
	current_score = 0
	total_questions = 0
	total_question_points = 0

func build_default_theme() -> QuizTheme:
	var theme := QuizTheme.new()
	var source_theme_path := "res://src/resources/themes/theme_varied.tres"
	var loaded_theme = load(source_theme_path)
	var source_questions: Array[QuizQuestion] = []

	if loaded_theme is QuizTheme:
		source_questions = loaded_theme.theme.duplicate()

	if source_questions.is_empty():
		var question_path := "res://src/resources/questions"
		var dir := DirAccess.open(question_path)

		if dir == null:
			push_error("Não foi possível abrir a pasta de perguntas: %s" % question_path)
			return theme

		var files := dir.get_files()
		files.sort()

		for file_name in files:
			if not file_name.ends_with(".tres"):
				continue

			var resource_path := "%s/%s" % [question_path, file_name]
			var loaded_resource = load(resource_path)
			if loaded_resource is QuizQuestion:
				source_questions.append(loaded_resource)
			else:
				push_warning("Arquivo ignorado por não ser uma pergunta válida: %s" % resource_path)

	if source_questions.is_empty():
		push_warning("Nenhuma pergunta foi encontrada no tema principal.")
		return theme

	var randomized_questions: Array[QuizQuestion] = []
	for question in source_questions:
		if question == null:
			continue
		var cloned_question: QuizQuestion = question.duplicate(true)
		_randomize_question_choices(cloned_question)
		randomized_questions.append(cloned_question)

	randomized_questions.shuffle()
	theme.theme = randomized_questions
	return theme

func _randomize_question_choices(question: QuizQuestion) -> void:
	if question == null:
		return

	if question.question_choices.size() <= 1:
		return

	var original_choices: Array[String] = question.question_choices.duplicate()
	var shuffled_choices: Array[String] = original_choices.duplicate()
	shuffled_choices.shuffle()
	question.question_choices = shuffled_choices

	if question.correct_choice >= 0 and question.correct_choice < original_choices.size():
		var original_value: String = original_choices[question.correct_choice]
		question.correct_choice = shuffled_choices.find(original_value)

	if question.correct_answers.size() > 0:
		var remapped_answers: Array[int] = []
		for original_index in question.correct_answers:
			if original_index < 0 or original_index >= original_choices.size():
				continue
			var original_value: String = original_choices[original_index]
			var new_index: int = shuffled_choices.find(original_value)
			if new_index >= 0:
				remapped_answers.append(new_index)
		question.correct_answers = remapped_answers

func begin_quiz(theme: QuizTheme) -> void:
	current_quiz = theme
	current_question_index = 0
	current_score = 0
	total_questions = current_quiz.theme.size() if current_quiz != null else 0
	total_question_points = 0

	if current_quiz == null:
		push_error("Não foi possível iniciar o quiz: tema nulo.")
		return

	for question in current_quiz.theme:
		if question != null:
			total_question_points += max(question.base_points, 0)

	load_current_question()

func get_current_question() -> QuizQuestion:
	if current_quiz == null:
		return null
	if current_question_index < 0 or current_question_index >= current_quiz.theme.size():
		return null
	return current_quiz.theme[current_question_index]

func is_scene_valid_for_current_question(scene_path: String) -> bool:
	var question := get_current_question()
	if question == null:
		return false
	return scene_path == get_scene_for_question(question)

func load_current_question() -> void:
	if current_quiz == null:
		finish_quiz()
		return

	var question: QuizQuestion = get_current_question()
	if question == null:
		finish_quiz()
		return

	var target_scene := get_scene_for_question(question)
	if target_scene.is_empty():
		finish_quiz()
		return

	var current_scene_path := ""
	if is_instance_valid(get_tree().current_scene):
		current_scene_path = get_tree().current_scene.scene_file_path

	if current_scene_path != target_scene:
		get_tree().change_scene_to_file(target_scene)
		return

	# Se a cena já estiver correta, a pergunta atual continua sendo renderizada.
	# A validação final pode ser feita na própria cena quando ela for criada.
	if current_scene_path == target_scene:
		return

func get_scene_for_question(question: QuizQuestion) -> String:
	if question == null:
		return ""

	match question.engine:
		Enum.QuestionEngine.SELECAO_MULTIPLA:
			return "res://src/scenes/selecao_multipla.tscn"
		Enum.QuestionEngine.MULTIPLA_ESCOLHA:
			return "res://src/scenes/multipla_escolha.tscn"
		_:
			return "res://src/scenes/multipla_escolha.tscn"

func advance_to_next_question() -> void:
	if current_quiz == null:
		return

	current_question_index += 1
	if current_question_index >= current_quiz.theme.size():
		finish_quiz()
		return

	load_current_question()

func finish_quiz() -> void:
	if current_quiz == null:
		get_tree().change_scene_to_file("res://src/ui/result_screen/result_screen.tscn")
		return

	var result_scene_path := "res://src/ui/result_screen/result_screen.tscn"
	if get_tree().current_scene == null or get_tree().current_scene.scene_file_path != result_scene_path:
		get_tree().change_scene_to_file(result_scene_path)
