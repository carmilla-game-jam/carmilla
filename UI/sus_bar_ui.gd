extends TextureProgressBar


# Called when the node enters the scene tree for the first time.
func _ready():
	State.sus_bar_changed.connect(update_bar)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update_bar():
	value = State.state["sus"]["level"]/State.state["sus"]["max"] * max_value
