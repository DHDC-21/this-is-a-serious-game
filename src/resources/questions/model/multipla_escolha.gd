extends QuestionModel
class_name MultiplaEscolhaModel

@export_category("Alternativas")
@export var alternativas: Array[String] = []
@export var resposta_correta: int = alternativas.size() - 1
