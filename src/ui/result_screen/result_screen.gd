extends CanvasLayer

@export var final_score: int = 0
@export var total_questions: int = 0
@export var total_points: int = 0
@export var player_name: String = "Jogador"

@onready var score_label: Label = %ScoreLabel
@onready var feedback_label: Label = %FeedbackLabel
@onready var title_label: Label = %TitleLabel
@onready var retry_button: Button = %RetryButton
@onready var menu_button: Button = %MenuButton

func _ready() -> void:
	final_score = GameState.current_score
	total_questions = GameState.total_questions
	total_points = GameState.total_question_points
	_connect_buttons()
	update_result()

func _connect_buttons() -> void:
	retry_button.pressed.connect(_on_retry_pressed)
	menu_button.pressed.connect(_on_menu_pressed)

func update_result() -> void:
	if title_label != null:
		title_label.text = "Resultado final"
		title_label.add_theme_font_size_override("font_size", 52)

	if score_label != null:
		score_label.visible = true
		score_label.text = "Pontuação: %d / %d" % [final_score, total_points]
		score_label.add_theme_font_size_override("font_size", 38)

	if feedback_label != null:
		feedback_label.text = "Parabéns! Você concluiu a rodada. Vamos tentar novamente ou voltar ao menu?"
		feedback_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		feedback_label.add_theme_font_size_override("font_size", 30)

	if retry_button != null:
		retry_button.custom_minimum_size = Vector2(260, 110)
		retry_button.add_theme_font_size_override("font_size", 28)

	if menu_button != null:
		menu_button.custom_minimum_size = Vector2(260, 110)
		menu_button.add_theme_font_size_override("font_size", 28)

func _on_retry_pressed() -> void:
	GameState.reset_round()
	var quiz_theme := GameState.build_default_theme()
	GameState.begin_quiz(quiz_theme)

func _on_menu_pressed() -> void:
	GameState.reset_round()
	get_tree().change_scene_to_file("res://src/ui/menu/main.tscn")
