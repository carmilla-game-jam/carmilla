extends Node

signal item_destroyed(id: int)

var state: Dictionary = {
	"sus": {
		"level": 1000,
		"convo_fail_rate": 200,
		},
	"gossip": {
		"sidone": {
			"1": true,
			"2": false,
		},
	},
	"items": {
		"key": {
			"id": 0,
			"obtained": false,
		},
		"letter": {
			"id": 1,
			"obtained": false,
		},
		"handkerchief": {
			"id": 2,
			"obtained": false,
		},
		"garden_door_lock": {
			"id": 3,
			"obtained": false,
		},
	},
	"locks_opened": {
		"garden": false,
	},
}
