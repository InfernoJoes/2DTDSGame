extends Node
signal die

var maxHealth := 100
var health := maxHealth
var damage = 20
var heal = 20

@onready var health_text = $%health_text

func _process(_delta):
	health_text.text = str(health)
	if health <= 0:
		emit_signal("die")
	
	if health >= maxHealth:
		health = maxHealth

func _damage(dmg : int):
	health -= dmg

func _heal(hl : int):
	health += hl
