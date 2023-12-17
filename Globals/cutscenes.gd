extends Node

var transitioning_target_scene: String
var dialog_resource: DialogueResource = load("res://UI/cutscenes/cutscene_resources/cutscenes.dialogue")

var scenes: Dictionary = {
	"title": {
		"scene_path": "res://UI/title_screen.tscn",
	},
	"credits": {
		"scene_path": "res://UI/credits_screen.tscn",
	},
	"opening": {
		"scene_path": "res://UI/cutscenes/cutscene.tscn",
		"bg": "res://assets/cutscenes/intro.png",
		"dialog_title": "opening",
		"next_scene": {
			"name": "main",
		},
	},
	"main": {
		"scene_path": "res://Main/main.tscn",
	},
	"sus_end": {
		"scene_path": "res://UI/cutscenes/cutscene.tscn",
		"bg": "res://assets/ui/titlescreen_bg.png",
		"dialog_title": "sus_end",
	},
	"sidone_end": {
		"scene_path": "res://UI/cutscenes/cutscene.tscn",
		"bg": "res://assets/ui/titlescreen_bg.png",
		"dialog_title": "sidone_end",
	},
	"helene_end": {
		"scene_path": "res://UI/cutscenes/cutscene.tscn",
		"bg": "res://assets/ui/titlescreen_bg.png",
		"dialog_title": "helene_end",
	},
	"mathilde_end": {
		"scene_path": "res://UI/cutscenes/cutscene.tscn",
		"bg": "res://assets/ui/titlescreen_bg.png",
		"dialog_title": "mathilde_end",
	},
}
