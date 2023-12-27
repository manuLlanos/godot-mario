extends Node

var sounds: Dictionary

func _ready():
	for children in get_children():
		sounds[children.name] = children

func play(audioname: String):
	if sounds[audioname]:
		sounds[audioname].play()
