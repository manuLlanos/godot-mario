extends CanvasLayer

@onready var lives = %Lives
@onready var score = %Score
@onready var time_left = %TimeLeft
@onready var win_text = %WinText
@onready var game_beaten_text = %GameBeatenText
@onready var game_over_text = %GameOverText


func _ready():
	win_text.hide()
	game_beaten_text.hide()
	game_over_text.hide()
	Globals.update_ui.connect(update)
	Globals.game_over.connect(_on_game_over)
	update()


func update():
	score.text = str(Globals.score)
	lives.text = str(Globals.lives)
	time_left.text = str(Globals.timeleft)

func show_victory_text():
	win_text.show()

func show_game_won():
	game_beaten_text.show()

func _on_game_over():
	await get_tree().create_timer(1).timeout
	game_over_text.show()
