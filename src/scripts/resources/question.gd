extends Resource
class_name QuizQuestion

@export var question_info: String

@export var question_type: Enum.QuestionType

@export var question_image: Texture2D
@export var question_audio: AudioStream
@export var question_video: VideoStream

@export var question_choices: Array[String]
@export var question_answer: String

