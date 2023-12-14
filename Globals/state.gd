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
	"convo": {
		"sidone": {
			"met": false,
			"fashion_done": {
				"1": false,
				"2": false,
			},
			"family_done": {
				"1": false,
				"2": false,
			},
			"gossip_done": {
				"1": false,
				"2": false,
			},
		},
		"mathilde": {
			"met": false,
			"fashion_done": {
				"1": false,
				"2": false,
			},
			"family_done": {
				"1": false,
				"2": false,
			},
			"gossip_done": {
				"1": false,
				"2": false,
			},
		},
		"helene": {
			"met": false,
			"fashion_done": {
				"1": false,
				"2": false,
			},
			"family_done": {
				"1": false,
				"2": false,
			},
			"gossip_done": {
				"1": false,
				"2": false,
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
	},
	"locks_opened": {
		"garden": false,
	},
}

func is_all_convos_finished(name: String) -> bool:
	var fashion_done = state["convo"][name]["fashion_done"].values().all(func(value): return value)
	var family_done = state["convo"][name]["family_done"].values().all(func(value): return value)
	var gossip_done = state["convo"][name]["gossip_done"].values().all(func(value): return value)
	print("convos finished: ", fashion_done, family_done, gossip_done)
	return fashion_done && family_done && gossip_done

func is_convo_category_unlocked(topic: String) -> bool:
	var sidone_done = state["gossip"]["sidone"][topic].values().all(func(value): return value)
	var mathilde_done = state["gossip"]["mathilde"][topic].values().all(func(value): return value)
	var helene_done = state["gossip"]["helene"][topic].values().all(func(value): return value)
	print("convos unlocked: ", sidone_done, mathilde_done, helene_done)
	return sidone_done && mathilde_done && helene_done

func decrease_sus_bar(amount: float) -> void:
	state["sus"]["level"] -= amount
	sus_bar_changed.emit()
	if state["sus"]["level"] <= 0:
		Cutscenes.transitioning_target_scene = "sus_end"
		SceneTransition.change_scene("res://UI/cutscenes/cutscene.tscn")

# TODO: Rename functions so that they're about the bar and not the mode
func enable_cat_mode() -> void:
	state["sus"]["enabled"] = true
	sus_mode_enabled.emit()

func disable_cat_mode() -> void:
	state["sus"]["enabled"] = false
	sus_mode_disabled.emit()
