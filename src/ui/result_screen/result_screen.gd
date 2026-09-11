extends CanvasLayer

@export var final_score: int = 0
@export var total_questions: int = 0
@export var player_name: String = "Jogador"

@onready var score_label: Label = %ScoreLabel
@onready var feedback_label: Label = %FeedbackLabel
@onready var title_label: Label = %TitleLabel
@onready var retry_button: Button = %RetryButton
@onready var menu_button: Button = %MenuButton

func _ready() -> void:
	update_result()
	_connect_buttons()

func _connect_buttons() -> void:
	retry_button.pressed.connect(_on_retry_pressed)
	menu_button.pressed.connect(_on_menu_pressed)

func update_result() -> void:
	var percentage: float = 0.0
	if total_questions > 0:
		percentage = float(final_score) / float(total_questions) * 100.0

	score_label.text = "%s / %s" % [final_score, total_questions]
	title_label.text = "Resultado final"

	if percentage >= 80:
		feedback_label.text = "Excelente! Você demonstrou bom conhecimento sobre a temática."
	elif percentage >= 60:
		feedback_label.text = "Muito bom! Você está no caminho certo, mas ainda pode reforçar alguns pontos."
	elif percentage >= 40:
		feedback_label.text = "Você conseguiu alguns acertos. Vale revisar os temas principais e tentar novamente."
	else:
		feedback_label.text = "Atenção! Essa é uma oportunidade para revisar os conceitos e tentar novamente."

func _on_retry_pressed() -> void:
	get_tree().change_scene_to_file("res://src/scenes/selecao_multipla.tscn")

func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://src/ui/menu/main.tscn")
