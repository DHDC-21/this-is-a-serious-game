extends Control

@onready var popup_sair = %PopupSair

func _ready() -> void:
	if popup_sair != null:
		popup_sair.confirmed.connect(_on_popup_sair_confirmed)
		popup_sair.canceled.connect(_on_popup_sair_cancelled)

func _on_btn_iniciar_pressed() -> void:
	GameState.reset_round()
	var quiz_theme := GameState.build_default_theme()
	GameState.begin_quiz(quiz_theme)

func _on_btn_creditos_pressed() -> void:
	return

func _on_btn_sair_pressed() -> void:
	# Abre o popup de confirmação para sair.
	if popup_sair != null:
		popup_sair.dialog_text = "Você tem certeza que deseja fechar o jogo?"
		popup_sair.popup_centered()

func _on_popup_sair_confirmed() -> void:
	get_tree().quit()

func _on_popup_sair_cancelled() -> void:
	if popup_sair != null:
		popup_sair.hide()
