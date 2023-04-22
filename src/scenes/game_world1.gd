extends Node2D

# debug stuff, comment out later
var enemy = preload("res://src/scenes/enemies & allies/enemy.tscn")
var ally = preload("res://src/scenes/enemies & allies/ally.tscn")

func _process(delta):
	if Input.is_action_just_pressed("primary_fire"):
		var enemy_inst = enemy.instantiate()
		get_tree().get_root().call_deferred("add_child", enemy_inst)
		enemy_inst.global_position = get_global_mouse_position()
	
	if Input.is_action_just_pressed("secondary_fire"):
		var ally_inst = ally.instantiate()
		get_tree().get_root().call_deferred("add_child", ally_inst)
		ally_inst.global_position = get_global_mouse_position()
	
	Engine.time_scale = 1
