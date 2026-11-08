extends Label

var amount: int = 0

func sub(i: int) -> void:
	amount -= i
	text = str(amount)

func add(i: int) -> void:
	amount += i
	text = str(amount)
	
