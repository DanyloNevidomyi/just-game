extends CanvasLayer

@onready var hp_bar: ProgressBar = $Control/HPBar
@onready var sanity_bar: ProgressBar = $Control/SanityBar
@onready var money_label: Label = $Control/MoneyLabel

func _ready() -> void:
	hp_bar.max_value = GameState.max_hp
	sanity_bar.max_value = GameState.max_sanity
	hp_bar.value = GameState.hp
	sanity_bar.value = GameState.sanity
	money_label.text = "$" + str(GameState.money)

	GameState.hp_changed.connect(func(v): hp_bar.value = v)
	GameState.sanity_changed.connect(func(v): sanity_bar.value = v)
	GameState.money_changed.connect(func(v): money_label.text = "$" + str(v))
