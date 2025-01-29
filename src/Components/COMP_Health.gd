extends Node
class_name COMP_Health

@export var MaxHealth:int
var CurrentHealth:int

signal Damaged
signal Death
signal Healed

func Damage(amount:int):
	if CurrentHealth - amount <= 0:
		Death.emit()
	else:
		Damaged.emit()
		CurrentHealth -= amount
	pass
	
func Heal(amount:int):
	Healed.emit()
	CurrentHealth += amount
	CurrentHealth = clamp(CurrentHealth,0,MaxHealth)
	pass
