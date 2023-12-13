extends Node

var transitioning_target_scene: String
var dialog_resource: DialogueResource = load("res://UI/cutscenes/cutscene_resources/cutscenes.dialogue")

var scenes: Dictionary = {
	"opening": {
		"bg": "res://assets/dummy/Carmilla Environment MockUp.png",
		"next_scene": {
			"name": "main",
			"scene_path": "res://Main/main.tscn",
		},
	},
	"main": {},
	"sus_end": {
		"bg": "res://assets/dummy/Carmilla Environment MockUp.png",
	},
	"sidone_end": {
		"bg": "res://assets/dummy/Carmilla Environment MockUp.png",
		"dialog_title": "sidone_end",
		"next_scene": {
			"name": "main",
			"scene_path": "res://Main/main.tscn",
		},
	},
	"helene_end": {
		"bg": "res://assets/dummy/Carmilla Environment MockUp.png",
		"dialog_title": "helene_end",
	},
	"mathile_end": {
		"bg": "res://assets/dummy/Carmilla Environment MockUp.png",
		"dialog_title": "mathile_end",
	},
}
