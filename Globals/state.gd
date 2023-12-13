extends Node

signal item_destroyed(id: int)

signal sus_bar_changed
signal sus_mode_enabled
signal sus_mode_disabled

var state: Dictionary = {
	"sus": {
		"level": 1000,
		"max": 1000,
		"convo_fail_loss_rate": 200,
		"enabled": false
		},
	"gossip": {
		"sidone": {
			"family": {
				"1": false,
			},
			"fashion": {
				"1": false,
			},
			"gossip": {
				"1": false
			}
		},
		"mathilde": {
			"family": {
				"1": false,
			},
			"fashion": {
				"1": false,
			},
			"gossip": {
				"1": false
			}
		},
		"helene": {
			"family": {
				"1": false,
			},
			"fashion": {
				"1": false,
			},
			"gossip": {
				"1": false
			}
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

func decrease_sus_bar(amount: float) -> void:
	state["sus"]["level"] -= amount
	sus_bar_changed.emit()

# TODO: Rename functions so that they're about the bar and not the mode
func enable_cat_mode() -> void:
	state["sus"]["enabled"] = true
	sus_mode_enabled.emit()

func disable_cat_mode() -> void:
	state["sus"]["enabled"] = false
	sus_mode_disabled.emit()
