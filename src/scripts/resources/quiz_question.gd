class_name QuizQuestion
extends Resource

@export var question_id: int = 0
@export var question_info: String = ""
@export var base_points: int = 100

@export var engine: Enum.QuestionEngine = Enum.QuestionEngine.MULTIPLA_ESCOLHA
@export var question_type: Enum.QuestionType = Enum.QuestionType.TEXTO

@export var question_image: Texture2D
@export var question_audio: AudioStream
@export var question_video: VideoStream

@export var question_choices: Array[String] = []
@export var correct_choice: int = -1
@export var correct_answers: Array[int] = []
@export var feedback_correct: String = ""
@export var feedback_wrong: String = ""

func is_correct_choice(selected_index: int) -> bool:
	if selected_index < 0:
		return false

	match engine:
		Enum.QuestionEngine.MULTIPLA_ESCOLHA:
			return selected_index == correct_choice
		Enum.QuestionEngine.VERDADEIRO_OU_FALSO:
			return selected_index == correct_choice
		Enum.QuestionEngine.SELECAO_MULTIPLA:
			return correct_answers.has(selected_index)
		_:
			return false

func is_correct_selection(selected_indices: Array[int]) -> bool:
	if engine != Enum.QuestionEngine.SELECAO_MULTIPLA:
		return selected_indices.size() == 1 and is_correct_choice(selected_indices[0])

	if selected_indices.size() != correct_answers.size():
		return false

	selected_indices.sort()
	var expected := correct_answers.duplicate()
	expected.sort()

	return selected_indices == expected

func get_selected_correct_feedback() -> String:
	if feedback_correct.is_empty():
		return "Resposta correta!"
	return feedback_correct

func get_selected_wrong_feedback() -> String:
	if feedback_wrong.is_empty():
		return "Resposta incorreta. Tente novamente."
	return feedback_wrong

