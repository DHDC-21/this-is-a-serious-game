extends Resource
class_name QuestionModel

@exoport_category("Enunciado")
@export var question_type: QuestionMediaType

@export var texto: String
@export var imagem: Texture2D
@export var video: VideoStream
@export var audio: AudioStream

@export_category("Dados")
@export var pontuacao_base: int = 360
@export var tema: QuestionCategory = QuestionCategory.PLANCON
@export var dificuldade: QuestionDifficulty = QuestionDifficulty.FACIL
