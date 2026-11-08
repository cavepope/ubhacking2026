extends Node2D

var value: Types.Card = Types.Card.new()
var face_up: bool = true
@onready var render_suit = $"Suit"
@onready var render_value = $"Value"
@onready var background = $"Polygon2D"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	render_suit.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	render_value.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_render() -> void:
	if not face_up:
		render_value.text = ""
		render_suit.text = ""
		background.color = Consts.card_back_color
		return
		
	background.color = Consts.card_front_color
	render_value.text = translate_value(value.val)
	render_suit.text = translate_suit(value.suit)
	
	if value.suit == Types.Suit.HEARTS or value.suit == Types.Suit.DIAMONDS:
		render_suit.add_theme_color_override("font_color", Color.RED)
		render_suit.add_theme_color_override("font_outline_color", Color.BLACK)
		render_value.add_theme_color_override("font_color", Color.RED)
		render_value.add_theme_color_override("font_outline_color", Color.BLACK)
	else:
		render_suit.add_theme_color_override("font_color", Color.BLACK)
		render_suit.add_theme_color_override("font_outline_color", Color.BLACK)
		render_value.add_theme_color_override("font_color", Color.BLACK)
		render_value.add_theme_color_override("font_outline_color", Color.BLACK)
	

func update(c: Types.Card) -> void:
	value = c
	update_render()
	
		
	

func translate_suit(s: Types.Suit) -> String:
	match s:
		Types.Suit.SPADES:
			return "♤"
		Types.Suit.HEARTS:
			return "♡"
		Types.Suit.CLUBS:
			return "♧"
		Types.Suit.DIAMONDS:
			return "♢"
		_:
			return "Uh oh"

func translate_value(i: int) -> String:
	if i < 11 and i > 1:
		return str(i)
	
	match i:
		1:
			return "Ace"
		11:
			return "Jack"
		12:
			return "Queen"
		13:
			return "King"
		_:
			return "Oops" + str(i)
