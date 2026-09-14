class_name QuizTheme
extends Resource

@export var theme: Array[QuizQuestion] = []

func get_shuffled_theme() -> Array[QuizQuestion]:
	var shuffled: Array[QuizQuestion] = theme.duplicate()
	shuffled.shuffle()
	return shuffled
