extends Node

var asteroid = preload("res://scenes/asteroid.tscn")
onready var spawns = get_node("spawn_locations")

func _ready():
	for i in range(5):
		var ast = asteroid.instance()
		add_child(ast)
		ast.init("big", spawns.get_child(i).get_pos()) 
