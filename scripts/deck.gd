extends Node2D

@onready var text = $"Label"
var card_list = []
var count = 52

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for t in range(4):
		for i in range(1, 14):
			var c: Types.Card = Types.Card.new()
			c.suit = t
			c.val = i
			card_list.append(c)
	update_text()

func deal_one() -> Types.Card:
	var index = randi() % count
	var card = card_list[index]
	card_list.remove_at(index)
	count -= 1
	update_text()
	return card
	
	
func update_text() -> void:
	text.text = str(count)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
