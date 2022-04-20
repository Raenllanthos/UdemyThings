extends Control

var playerWords = []
var template
var currentStory

onready var PlayerText = $VBoxContainer/HBoxContainer/PlayerText
onready var DisplayText = $VBoxContainer/DisplayText
onready var Label = $VBoxContainer/HBoxContainer/Label

func _ready():
	setCurrentStory()
	DisplayText.text = " \n"
	checkPlayerWordsLength()
	PlayerText.grab_focus()

func setCurrentStory():
	var stories = getFromJson("story.json")
	randomize()
	currentStory = stories[randi()  % stories.size()]
#	var stories = $StoryBook.get_child_count()
#	var selectedStory = randi() % stories
#	currentStory.prompts = $StoryBook.get_child(selectedStory).prompts
#	currentStory.story = $StoryBook.get_child(selectedStory).story
##	currentStory = template[randi() % template.size()]

func getFromJson(filename):
	var file = File.new()
	file.open(filename, File.READ)
	var text = file.get_as_text()
	var data = parse_json(text)
	file.close()
	return data

func _on_PlayerText_text_entered(words):
	addToPlayerWords()
	
func _on_TextureButton_pressed():
	if isStoryDone():
		get_tree().reload_current_scene()
	else:
		addToPlayerWords()
	
func addToPlayerWords():
	playerWords.append(PlayerText.text)
	DisplayText.text = ""
	PlayerText.clear()
	checkPlayerWordsLength()
	
func isStoryDone():
	return playerWords.size() == currentStory.prompts.size()

func checkPlayerWordsLength():
	if isStoryDone():
		endGame()
	else:
		promptPlayer()
		
func tellStory():
	DisplayText.text = currentStory.story % playerWords

func promptPlayer():
	DisplayText.text += "May I have " + currentStory.prompts[playerWords.size()] + " please?"

func endGame():
	PlayerText.queue_free()
	tellStory()
	Label.text = "Again!"
