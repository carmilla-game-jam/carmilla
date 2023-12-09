extends Node

signal item_destroyed(id: int)

var state: Dictionary = {
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
	}
}
