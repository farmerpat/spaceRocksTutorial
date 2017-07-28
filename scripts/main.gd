extends Node

var asteroid = preload("res://scenes/asteroid.tscn")
var explosion = preload("res://scenes/explosion.tscn")

onready var spawns = get_node("spawn_locations")
onready var asteroid_container = get_node("asteroid_container")
onready var explosion_sounds = get_node("explosion_sounds")

# before continuing, find out why this is blowing up immediately
func _ready():
	set_process(true)
	for i in range(1): 
		spawn_asteroid("big", spawns.get_child(i).get_pos(), Vector2(0,0))

	get_node("music").play()

func _process(delta):
	if asteroid_container.get_child_count() == 0:
		for i in range(2): 
			spawn_asteroid("big", spawns.get_child(i).get_pos(), Vector2(0,0))

func spawn_asteroid(size, pos, vel):
	var ast = asteroid.instance()
	asteroid_container.add_child(ast)
	ast.connect("explode", self, "explode_asteroid")
	ast.init(size, pos, vel)
	# add_child(ast)

func explode_asteroid (size, pos, vel, hit_vel):
	print ("exploding asteroid")
	var new_size = global.break_pattern[size]

	if new_size:
		for offset in [-1, 1]:
			var new_pos =  pos + hit_vel.tangent().clamped(25) * offset
			var new_vel = vel + hit_vel.tangent() * offset
			spawn_asteroid(new_size, new_pos, new_vel)

	var expl = explosion.instance()
	add_child(expl)
	expl.set_pos(pos)
	expl.play()
	explosion_sounds.play("expl1")