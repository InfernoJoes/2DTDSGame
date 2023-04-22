extends CharacterBody2D
# ---THIS IS THE ENEMY SCRIPT---
const ENEMY_MOVE_SPEED := 2
var current_anim = "idle"
var a = 0
@onready var sprite: AnimatedSprite2D = $sprite
var player = null
var enemy = null
var enemies = []

@onready var enemy_stats := $EnemyStats
@onready var damage_rate := $EnemyStats/damage_rate
var damage_per_second = 100
var can_damage : bool = true


func _ready():
	get_tree().call_group("Ally", "set_enemy", self)
	damage_rate.wait_time = damage_per_second / 100 # 100 / 1000 = 10 damage per second

func _process(delta):
	get_tree().call_group("Ally", "set_enemy", self)

func _physics_process(delta):
	if enemy != null:
		move_and_look_at_enemy(delta)
		if self.position.distance_to(enemy.position) < 100:
			#print("in ally range")
			if can_damage:
				move_and_look_at_enemy(delta)
				enemy.ally_stats._damage(10)
				can_damage = false
				damage_rate.start()
			player = null
		elif self.position.distance_to(player.position) < 100:
			#print("in player range")
			if can_damage:
				move_and_look_at_player(delta)
				player.player_stats._damage(10)
				can_damage = false
				damage_rate.start()
			enemy = null
	elif player != null:
		move_and_look_at_player(delta)
		if self.position.distance_to(player.position) < 100:
			#print("in player range")
			if can_damage:
				move_and_look_at_player(delta)
				player.player_stats._damage(10)
				can_damage = false
				damage_rate.start()
			enemy = null
	
	sprite.animation = current_anim + str(a)
	if !sprite.is_playing():
		sprite.play("idle0")
	
	if velocity != Vector2.ZERO:
		current_anim = "idle"
	else:
		current_anim = "run"
	
	#print(sprite.animation)

func move_and_look_at_player(delta):
	if player != null:
		var vec_to_player = player.global_position - global_position
		a = snapped(vec_to_player.angle(), PI/4)/(PI/4)
		a = wrapi(int(a), 0, 8)
		move_and_collide(vec_to_player * ENEMY_MOVE_SPEED * delta)
	else:
		return

func move_and_look_at_enemy(delta):
	if enemy != null:
		var vec_to_enemy = enemy.global_position - global_position
		a = snapped(vec_to_enemy.angle(), PI/4)/(PI/4)
		a = wrapi(int(a), 0, 8)
		move_and_collide(vec_to_enemy * ENEMY_MOVE_SPEED * delta)
	else:
		return

func set_player(p):
	player = p

func set_enemy(e):
	enemy = e # the enemy will attack allies and players

func _on_enemy_stats_die():
	queue_free()

func _on_damage_rate_timeout():
	can_damage = true
