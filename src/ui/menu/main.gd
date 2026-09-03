extends CanvasLayer


@onready var popup_sair = $Control/VBoxContainer/VBoxContainer/BtnCreditos/PopupSair

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_btn_iniciar_pressed() -> void:
	pass # Replace with function body.


func _on_btn_creditos_pressed() -> void:
	pass # Replace with function body.


func _on_btn_sair_pressed() -> void:
	pass # Replace with function body.
	popup_sair.popup_centered()

func _on_popup_sair_confirmed() -> void:
	get_tree().quit()
