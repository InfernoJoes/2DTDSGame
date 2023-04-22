extends CharacterBody2D

@export var speed := 800
@export var friction = 0.18

var mousePos
var current_anim = "idle"
var a = 0
var facing = Vector2()
@onready var sprite: AnimatedSprite2D = $sprite

@onready var player_stats := $PlayerStats

func _ready():
	get_tree().call_group("Enemy", "set_player", self)
	get_tree().call_group("Ally", "set_player", self)

func _process(_delta):
	get_tree().call_group("Enemy", "set_player", self)
	get_tree().call_group("Ally", "set_player", self)
	mousePos = get_local_mouse_position()
	a = snapped(mousePos.angle(), PI/4)/(PI/4)
	a = wrapi(int(a), 0, 8)
	
	sprite.animation = current_anim + str(a)
	if !sprite.is_playing():
		sprite.play("idle0")
	#print(sprite.animation)
	

func _physics_process(_delta):
	var direction = Vector2()
	mousePos = get_local_mouse_position()
	
	direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	direction.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	
	facing = mousePos - self.global_position
	
	if direction.length() > 1.0:
		direction = direction.normalized()
	
	if direction != Vector2.ZERO:
		current_anim = "run"
	else:
		current_anim = "idle"
	
	$Hand.look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("primary_fire"):
		pass
	
	# Using the follow steering behavior.
	var target_velocity = direction * speed
	velocity += (target_velocity - velocity) * friction
	move_and_slide()


func _on_player_stats_die():
	get_tree().reload_current_scene()
	queue_free()
