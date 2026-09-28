extends Resource
class_name QuestionModel

@export_category("Enunciado")
@export var question_media_type: QuestionMediaType.QuestionMediaType
@export var texto: String
@export var imagem: Texture2D
@export var video: VideoStream
@export var audio: AudioStream

@export_category("Dados")
@export var categoria: QuestionCategory.QuestionCategory
@export var dificuldade: QuestionDifficulty.QuestionDifficulty
@export var pontuacao_base: int = 200

@export_category("Feedback")
@export var feedback_correto: String
@export var feedback_incorreto: String
