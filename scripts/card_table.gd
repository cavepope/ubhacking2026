extends Node2D

@onready var deck = $"Deck"
@onready var button = $"Button"
@onready var player_card1 = $"PlayerCards/Card1"
@onready var player_card2 = $"PlayerCards/Card2"
@onready var player_card3 = $"PlayerCards/Card3"
@onready var player_card4 = $"PlayerCards/Card4"
@onready var player_card5 = $"PlayerCards/Card5"

@onready var opp_card1 = $"OppCards/Card1"
@onready var opp_card2 = $"OppCards/Card2"
@onready var opp_card3 = $"OppCards/Card3"
@onready var opp_card4 = $"OppCards/Card4"
@onready var opp_card5 = $"OppCards/Card5"

var game_sequence = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button.pressed.connect (button_func)

func button_func() -> void:
	match game_sequence:
		0:	# Start
			full_deal()
			button.text = "Bet"
		_:	# Game has finished
			game_sequence = -1

	
	game_sequence += 1


func full_deal() -> void:
	# Player cards
	player_card1.update(deck.deal_one())
	player_card2.update(deck.deal_one())
	player_card3.update(deck.deal_one())
	player_card4.update(deck.deal_one())
	player_card5.update(deck.deal_one())
	player_card1.visible = true
	player_card2.visible = true
	player_card3.visible = true
	player_card4.visible = true
	player_card5.visible = true
	
	# Opponent cards
	opp_card1.face_up = false
	opp_card2.face_up = false
	opp_card3.face_up = false
	opp_card4.face_up = false
	opp_card5.face_up = false
	opp_card1.update(deck.deal_one())
	opp_card2.update(deck.deal_one())
	opp_card3.update(deck.deal_one())
	opp_card4.update(deck.deal_one())
	opp_card5.update(deck.deal_one())
	opp_card1.visible = true
	opp_card2.visible = true
	opp_card3.visible = true
	opp_card4.visible = true
	opp_card5.visible = true


func get_card_tuple(i: int) -> Types.Card:
	var c: Types.Card = Types.Card.new()
	c.suit = i / 13
	c.value = i % 13
	return c
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
