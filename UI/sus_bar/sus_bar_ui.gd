extends TextureProgressBar


@export var ENABLED_MODULATION_ALPHA: int = 255
@export var DISABLED_MODULATION_ALPHA: int = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	State.sus_bar_changed.connect(update_bar)
	State.sus_mode_enabled.connect(enable_bar)
	State.sus_mode_disabled.connect(disable_bar)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func update_bar():
	value = State.state["sus"]["level"]/State.state["sus"]["max"] * max_value


func enable_bar():
	self_modulate.a8 = ENABLED_MODULATION_ALPHA

func disable_bar():
	self_modulate.a8 = DISABLED_MODULATION_ALPHA
