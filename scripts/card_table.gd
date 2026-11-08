extends Node2D

@onready var deck = $"Deck"

@onready var winner_text = $"Winner"
@onready var balance = $"Balance"
@onready var oppBalance = $"OppBalance"
@onready var pot = $"Pot"
@onready var bet = $"Bet"
@onready var current_bet_label = $"CurrentBet"
@onready var current_bet_text = $"CurrBetText"

@onready var button = $"Button"
@onready var debug_step = $"debug_step"
@onready var debug_view = $"debug_view"
@onready var fold = $"Fold"
@onready var match_ = $"Match"

@onready var player_card1 = $"PlayerCards/Card1"
@onready var player_card2 = $"PlayerCards/Card2"

@onready var opp_card1 = $"OppCards/Card1"
@onready var opp_card2 = $"OppCards/Card2"

@onready var dis_card1 = $"Discards/Card1"
@onready var dis_card2 = $"Discards/Card2"
@onready var dis_card3 = $"Discards/Card3"

@onready var board_card1 = $"Board/Card1"
@onready var board_card2 = $"Board/Card2"
@onready var board_card3 = $"Board/Card3"
@onready var board_card4 = $"Board/Card4"
@onready var board_card5 = $"Board/Card5"

var game_sequence = 0
var debug_sequence = 0
var current_bet: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	balance.add(1000)
	oppBalance.add(1000)
	fold.pressed.connect(fold_func)
	match_.pressed.connect(match_func)
	button.pressed.connect (button_func)
	debug_view.pressed.connect (debug_view_func)
	debug_step.pressed.connect(debug_step_func)
	bet.visible = false
	fold.visible = false
	match_.visible = false
	current_bet_label.visible = false
	current_bet_text.visible = false
	
	

func fold_func() -> void:
	winner_text.text = "Folded"
	oppBalance.add(pot.amount)
	pot.sub(pot.amount)
	game_sequence = 10
	
func match_func() -> void:
	if balance.amount > current_bet:
		balance.sub(current_bet)
		pot.add(current_bet)
	else:
		pot.add(balance.amount)
		balance.sub(balance.amount)
	
	current_bet_label.visible = false
	current_bet_text.visible = false
	game_sequence += 1
	button_func()
		
	

func debug_step_func() -> void:
	match debug_sequence:
		0: 
			dis_card1.face_up = false
			dis_card1.update(deck.deal_one())
			dis_card1.visible = true
			
			board_card1.update(deck.deal_one())
			board_card2.update(deck.deal_one())
			board_card3.update(deck.deal_one())
			
			board_card1.visible = true
			board_card2.visible = true
			board_card3.visible = true
			debug_sequence += 1
			
		1: 
			dis_card2.face_up = false
			dis_card2.update(deck.deal_one())
			dis_card2.visible = true
			
			board_card4.update(deck.deal_one())
			
			board_card4.visible = true
			debug_sequence += 1
		
		2: 
			dis_card3.face_up = false
			dis_card3.update(deck.deal_one())
			dis_card3.visible = true
			
			board_card5.update(deck.deal_one())
			
			board_card5.visible = true
			debug_sequence += 1
		
		3: 
			opp_card1.face_up = true
			opp_card2.face_up = true
			opp_card1.update_render()
			opp_card2.update_render()
			debug_sequence += 1
		4:
			var winner = eval_poker_hands()
			if winner:
				winner_text.text = "Congratulations!"
			else:
				winner_text.text = "Sorry :("

func debug_view_func() -> void:
	opp_card1.face_up = not opp_card1.face_up
	opp_card2.face_up = not opp_card2.face_up
	
	opp_card1.update_render()
	opp_card2.update_render()

func bet_check() -> bool:
	if bet.value < current_bet:
		return false
	if bet.value > balance.amount:
		return false
	return true 

# Return true for if match
# False if fold or raise 
func bet_dialog() -> bool:
	# Logic for what the opponent will bet
	# Test match
	oppBalance.sub(current_bet)
	pot.add(current_bet)
	
	#Test raise
	#current_bet = current_bet + 100
	#oppBalance.sub(current_bet)
	#pot.add(current_bet)
	#match_.visible = true
	#current_bet_label.text = str(current_bet)
	#current_bet_label.visible = true
	#current_bet_text.visible = true
	#return false
	
	return true

func button_func() -> void:
	match game_sequence:
		0:	# Start
			full_deal()
			button.text = "Bet"
			bet.visible = true
			fold.visible = true
			
			game_sequence += 1
		1: 
			if bet_check(): # Successfully passed
				current_bet = bet.value
				balance.sub(current_bet)
				pot.add(current_bet)
				if bet_dialog():
					game_sequence += 1
					button_func()
			
			
		2: 
			current_bet = 0
			dis_card1.face_up = false
			dis_card1.update(deck.deal_one())
			dis_card1.visible = true
			
			board_card1.update(deck.deal_one())
			board_card2.update(deck.deal_one())
			board_card3.update(deck.deal_one())
			
			board_card1.visible = true
			board_card2.visible = true
			board_card3.visible = true
			game_sequence += 1
			
		3:
			if bet_check(): # Successfully passed
				current_bet = bet.value
				balance.sub(current_bet)
				pot.add(current_bet)
				if bet_dialog():
					game_sequence += 1
					button_func()
		
		4:
			current_bet = 0
			dis_card2.face_up = false
			dis_card2.update(deck.deal_one())
			dis_card2.visible = true
			
			board_card4.update(deck.deal_one())
			
			board_card4.visible = true
			game_sequence += 1
		
		5:
			if bet_check(): # Successfully passed
				current_bet = bet.value
				balance.sub(current_bet)
				pot.add(current_bet)
				if bet_dialog():
					game_sequence += 1
					button_func()
			
		6:
			current_bet = 0
			dis_card3.face_up = false
			dis_card3.update(deck.deal_one())
			dis_card3.visible = true
			
			board_card5.update(deck.deal_one())
			
			board_card5.visible = true
			game_sequence += 1
			
		7:
			if bet_check(): # Successfully passed
				current_bet = bet.value
				balance.sub(current_bet)
				pot.add(current_bet)
				if bet_dialog():
					game_sequence += 1
					button_func()
			
		8:
			opp_card1.face_up = true
			opp_card2.face_up = true
			opp_card1.update_render()
			opp_card2.update_render()
			game_sequence += 1
			
		9:
			var winner = eval_poker_hands()
			if winner:
				winner_text.text = "Congratulations!"
				balance.add(pot.amount)
				pot.sub(pot.amount)
			else:
				winner_text.text = "Sorry :("
				oppBalance.add(pot.amount)
				pot.sub(pot.amount)
		_:	# Game has finished
			game_sequence = -1


func full_deal() -> void:
	# Player cards
	player_card1.update(deck.deal_one())
	player_card2.update(deck.deal_one())
	player_card1.visible = true
	player_card2.visible = true
	
	# Opponent cards
	opp_card1.face_up = false
	opp_card2.face_up = false
	opp_card1.update(deck.deal_one())
	opp_card2.update(deck.deal_one())
	opp_card1.visible = true
	opp_card2.visible = true

# True if player win, false if opp wins
# Pls don't look too close at this function, it's pretty bad
func eval_poker_hands() -> bool:
	'''
	var card_list_player = []
	var card_list_opp = []
	
	card_list_player.append(board_card1.value)
	card_list_player.append(board_card2.value)
	card_list_player.append(board_card3.value)
	card_list_player.append(board_card4.value)
	card_list_player.append(board_card5.value)
	card_list_player.append(player_card1.value)
	card_list_player.append(player_card2.value)
	
	card_list_opp.append(board_card1.value)
	card_list_opp.append(board_card2.value)
	card_list_opp.append(board_card3.value)
	card_list_opp.append(board_card4.value)
	card_list_opp.append(board_card5.value)
	card_list_opp.append(opp_card1.value)
	card_list_opp.append(opp_card2.value)
	
	# Check for straight flushes
	# Player
	var suit_count_player = [0,0,0,0]
	var suit_count_opp = [0,0,0,0]
	var val_count_player = []
	var val_count_opp = []
	
	for x in range(13):
		val_count_player.append(0)
		val_count_opp.append(0)
	
	for each in card_list_player:
		suit_count_player[each.suit] += 1
		val_count_player[each.val - 1] += 1
	
	# Opp
	for each in card_list_opp:
		suit_count_opp[each.suit] += 1
		val_count_opp[each.val-1] += 1
		
	var player_has_royal = false
	var player_highest: Types.Card = Types.Card.new()
	var opp_has_royal = false
	var opp_highest: Types.Card = Types.Card.new() 
	for i in range(4):
		if suit_count_player[i] > 4:
			player_has_royal = true
			var temp = []
			for each in card_list_player:
				if each.suit == i:
					temp.append(each)
			temp.sort()
			player_highest = temp[-1]
			for l in range(2, temp.size()):
				if temp[l] - temp[l-1] != 1:
					if temp.size() > 5 and l == 2:
						continue
					player_has_royal = false
				
				
		if suit_count_opp[i] > 4:
			opp_has_royal = true
			var temp = []
			for each in card_list_opp:
				if each.suit == i:
					temp.append(each)
			temp.sort()
			opp_highest = temp[-1]
			for l in range(2, temp.size()):
				if temp[l] - temp[l-1] != 1:
					if temp.size() > 5 and l == 2:
						continue
					opp_has_royal = false
	if player_has_royal and not opp_has_royal:
		return true
	if not player_has_royal and opp_has_royal:
		return false
	if player_has_royal and opp_has_royal:
		if player_highest.val > opp_highest.val:
			return true
		else:
			return false
	
	var num_pairs_player = 0
	var num_pairs_opp = 0
	
	var num_three_player = 0
	var num_three_opp = 0
	
	var num_four_player = 0
	var num_four_opp = 0
	
	for i in range(13):
		match val_count_player[i]:
			2:
				num_pairs_player += 1
			3:
				num_three_player += 1
			4: 
				num_four_player += 1
		
		match val_count_opp[i]:
			2:
				num_pairs_opp += 1
			3: 
				num_three_opp += 1
			4:
				num_four_opp += 1
				
		if num_four_player > num_four_opp:
			return true
		if num_four_player < num_four_opp:
			return false
		
		if num_three_opp == 1 and num_pairs_opp > 0 and num_three_player == 0:
			return false
		if num_three_player == 1 and num_pairs_player > 0 and num_three_opp == 0:
			return true
		
		var max_player = suit_count_player.max()
		var max_opp = suit_count_opp.max()
		
		if max_player == 5 and max_opp < 5:
			return true 
		if max_opp == 5 and max_player < 5:
			return false
		
		var straight_player = false
		var straight_opp = false
		for i_x in range(13):
			if val_count_player[i_x] > 0:
				straight_player = true
				for j in range(5):
					if i_x + j >= 13:
						straight_player = false
						break
					if val_count_player[i_x + j] == 0:
						straight_player = false
						break
				if straight_player:
					break
		for i_y in range(13):
			if val_count_opp[i_y] > 0:
				straight_opp = true
				for j in range(5):
					if i_y + j >= 13:
						straight_opp = false
						break
					if val_count_opp[i_y + j] == 0:
						straight_opp = false
						break
		
		if straight_player and not straight_opp:
			return true
		if straight_opp and not straight_player:
			return false
		
		if num_three_player > 0 and num_three_opp == 0:
			return true
		if num_four_opp > 0 and num_three_player == 0:
			return false
		
		if num_pairs_player >= 2 and num_pairs_opp < 2:
			return true
		if num_pairs_opp >= 2 and num_pairs_player < 2:
			return false
		
		if num_pairs_player == 1 and num_pairs_opp == 0:
			return true
		if num_pairs_opp == 1 and num_pairs_player == 0:
			return false

	'''
	var card_list_player = []
	var card_list_opp = []
	
	card_list_player.append(board_card1.value)
	card_list_player.append(board_card2.value)
	card_list_player.append(board_card3.value)
	card_list_player.append(board_card4.value)
	card_list_player.append(board_card5.value)
	card_list_player.append(player_card1.value)
	card_list_player.append(player_card2.value)
	
	card_list_opp.append(board_card1.value)
	card_list_opp.append(board_card2.value)
	card_list_opp.append(board_card3.value)
	card_list_opp.append(board_card4.value)
	card_list_opp.append(board_card5.value)
	card_list_opp.append(opp_card1.value)
	card_list_opp.append(opp_card2.value)
	
	# Check for straight flushes
	# Player
	var suit_count_player = [0,0,0,0]
	var suit_count_opp = [0,0,0,0]
	var val_count_player = []
	var val_count_opp = []
	
	for x in range(13):
		val_count_player.append(0)
		val_count_opp.append(0)
	
	for each in card_list_player:
		suit_count_player[each.suit] += 1
		val_count_player[each.val - 1] += 1
	
	# Opp
	for each in card_list_opp:
		suit_count_opp[each.suit] += 1
		val_count_opp[each.val-1] += 1
	
	var straight_flush_player = check_straight_flush(card_list_player, suit_count_player, val_count_player)
	var straight_flush_opp = check_straight_flush(card_list_opp, suit_count_opp, val_count_opp)

	if straight_flush_player and not straight_flush_opp:
		return true
	if straight_flush_opp and not straight_flush_player:
		return false
	if straight_flush_opp and straight_flush_player:
		return true # FIX
	
	var fours_player = card_list_player.count(4)
	var fours_opp = card_list_opp.count(4)
	var threes_player = card_list_player.count(3)
	var threes_opp = card_list_opp.count(3)
	var twos_player = card_list_player.count(2)
	var twos_opp = card_list_opp.count(2)
	
	# Four of a kind 
	if fours_player == 1 and fours_opp != 1:
		return true
	if fours_opp == 1 and fours_player != 1:
		return false
	if fours_opp == 1 and fours_player == 1:
		return true # FIX
		
	# Full house
	if threes_player > 0 and twos_player > 0 and (threes_opp == 0 or twos_opp == 0):
		return true
	if threes_opp > 0 and twos_opp > 0 and (threes_player == 0 or twos_player == 0):
		return false
	if threes_player > 0 and twos_player > 0 and threes_opp > 0 or twos_opp > 0:
		return true # FIX
	
	# Flush
	if suit_count_player.max() > 4 and suit_count_opp.max() <= 4:
		return true
	if suit_count_opp.max() > 4 and suit_count_player.max() <= 4:
		return false
	if suit_count_opp.max() > 4 and suit_count_player.max() > 4:
		return false # FIX

	
	# Straight
	var straight_player = false
	var straight_opp = false
	var highest_player = 0
	var highest_opp = 0
	for i in range(10):
		if not straight_player:
			if val_count_player[i] > 0:
				var count = 0
				straight_player = true
				for j in range(5):
					if val_count_player[i + j % 13] > 0:
						count += 1
					else:
						straight_player = false
						break
				if straight_player:
					highest_player = i + 5
		if not straight_opp:
			if val_count_opp[i] > 0:
				var count = 0
				straight_opp = true
				for j in range(5):
					if val_count_opp[i + j % 13] == 0:
						straight_opp = false
						break
				if straight_opp:
					highest_opp = i + 5
					
	
	if straight_player and not straight_opp:
		return true
	if straight_opp and not straight_player:
		return false
	if straight_opp and straight_player:
		if highest_player > highest_opp:
			return true
		if highest_player < highest_opp:
			return false
					
					
		
	# Three of a kind
	if threes_player > 0 and threes_opp == 0:
		return true
	if threes_opp > 0 and threes_player == 0:
		return false
	if threes_opp > 0 and threes_player > 0:
		for i in range(12, -1, -1):
			if val_count_opp[i] >= 3 and val_count_player[i] < 3:
				return false
			if val_count_player[i] >= 3 and val_count_opp[i] < 3:
				return true
	
	# Two pair
	if twos_player > 1 and twos_opp <= 1:
		return true
	if twos_opp > 1 and twos_player <= 1:
		return false
	if twos_opp > 1 and twos_player > 1:
		for i in range(12, -1, -1):
			if val_count_opp[i] >= 2 and val_count_player[i] < 2:
				return false
			if val_count_player[i] >= 2 and val_count_opp[i] < 2:
				return true

	# One pair
	if twos_player > 0 and twos_opp <= 0:
		return true
	if twos_opp > 0 and twos_player <= 0:
		return false
	if twos_opp > 0 and twos_player > 0:
		for i in range(12, -1, -1):
			if val_count_opp[i] >= 2 and val_count_player[i] < 2:
				return false
			if val_count_player[i] >= 2 and val_count_opp[i] < 2:
				return true
		
	# Highest
	for i in range(12, -1, -1):
		if val_count_opp[i] > val_count_player[i]:
			return false
		if val_count_player[i] > val_count_opp[i]:
			return true
		
	
	return false

func check_straight_flush(cards, suits, values):
	var temp = []
	for suit in range(4):
		if suits[suit] > 4:
			for each in cards:
				if each.suit == suit:
					temp.append(each)
			temp.sort()
			if temp.size() == 5:
				var count = 0
				for i in range(4):
					if temp[i + 1] - temp[i] == 1:
						count += 1
				if count == 5:
					return true
				count = 0
				for i in range(4):
					if temp[i + 2 % 5] - temp[i + 1] == 1:
						count += 1
				if count == 5:
					return true

			
			if temp.size() == 6:
				for j in range(3):
					var count = 0
					for i in range(4):
						if temp[i + j + 1 % 6] - temp[i + j] == 1:
							count += 1
					if count == 5: 
						return true
						
			if temp.size() == 7:
				for j in range(4):
					var count = 0
					for i in range(4):
						if temp[i + j + 1 % 7] - temp[i + j] == 1:
							count += 1
					if count == 5: 
						return true
					
					
	
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
