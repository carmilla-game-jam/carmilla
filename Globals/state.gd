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
				"1": true,
			},
			"fashion": {
				"1": true,
			},
			"gossip": {
				"1": true,
			}
		},
		"mathilde": {
			"family": {
				"1": true,
			},
			"fashion": {
				"1": true,
			},
			"gossip": {
				"1": true,
			}
		},
		"helene": {
			"family": {
				"1": true,
			},
			"fashion": {
				"1": true,
			},
			"gossip": {
				"1": true,
			}
		},
	},
	"convo": {
		"sidone": {
			"met": false,
			"fashion_done": false,
			"family_done": false,
			"gossip_done": false,
			"fashion_topics": {
				"1": false,
				"2": false,
				"3": false,
			},
			"family_topics": {
				"1": false,
				"2": false,
				"3": false,
			},
			"gossip_topics": {
				"1": false,
				"2": false,
				"3": false,
			},
		},
		"mathilde": {
			"met": false,
			"fashion_done": false,
			"family_done": false,
			"gossip_done": false,
			"fashion_topics": {
				"1": false,
				"2": false,
				"3": false,
			},
			"family_topics": {
				"1": false,
				"2": false,
				"3": false,
			},
			"gossip_topics": {
				"1": false,
				"2": false,
				"3": false,
			},
		},
		"helene": {
			"met": false,
			"fashion_done": false,
			"family_done": false,
			"gossip_done": false,
			"fashion_topics": {
				"1": false,
				"2": false,
				"3": false,
			},
			"family_topics": {
				"1": false,
				"2": false,
				"3": false,
			},
			"gossip_topics": {
				"1": false,
				"2": false,
				"3": false,
			},
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
		"footprints_garden": {
			"id": 4,
			"obtained": false,
		},
		"footprints_inside": {
			"id": 5,
			"obtained": false,
		},
	},
	"locks_opened": {
		"garden": false,
	},
}

func is_all_convos_finished(name: String) -> bool:
	var fashion_done = state["convo"][name]["fashion_done"]
	var family_done = state["convo"][name]["family_done"]
	var gossip_done = state["convo"][name]["gossip_done"]
	print("convos finished: ", fashion_done, family_done, gossip_done)
	return fashion_done && family_done && gossip_done

func is_convo_category_unlocked(topic: String) -> bool:
	var sidone_done = state["gossip"]["sidone"][topic].values().all(func(value): return value)
	var mathilde_done = state["gossip"]["mathilde"][topic].values().all(func(value): return value)
	var helene_done = state["gossip"]["helene"][topic].values().all(func(value): return value)
	print("convos unlocked for ", topic, ": ", sidone_done, mathilde_done, helene_done)
	return sidone_done && mathilde_done && helene_done

func decrease_sus_bar(amount: float) -> void:
	state["sus"]["level"] -= amount
	sus_bar_changed.emit()
	if state["sus"]["level"] <= 0:
		SceneTransition.change_scene("sus_end")

# TODO: Rename functions so that they're about the bar and not the mode
func enable_cat_mode() -> void:
	state["sus"]["enabled"] = true
	sus_mode_enabled.emit()

func disable_cat_mode() -> void:
	state["sus"]["enabled"] = false
	sus_mode_disabled.emit()
