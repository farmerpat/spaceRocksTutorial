extends KinematicBody2D

signal explode

export var bounce = 1.1

var size
var vel = Vector2()
var rot_speed
var screen_size
var extents
var textures = {
	'big': [
		'res://art/sheet.meteorGrey_big1.atex',
		'res://art/sheet.meteorGrey_big2.atex',
		'res://art/sheet.meteorGrey_big3.atex',
		'res://art/sheet.meteorGrey_big4.atex'
	],
	'med': [
		'res://art/sheet.meteorGrey_med1.atex',
		'res://art/sheet.meteorGrey_med2.atex'
	],
	'small': [
		'res://art/sheet.meteorGrey_small1.atex',
		'res://art/sheet.meteorGrey_small2.atex'
	],
	'tiny': [
		'res://art/sheet.meteorGrey_tiny1.atex',
		'res://art/sheet.meteorGrey_tiny2.atex'
	]
}

onready var puff = get_node("puff")

func _ready():
	# sort of like tags in unity
	add_to_group("asteroids")
	randomize()
	set_fixed_process(true)

	rot_speed = rand_range(-1.5, 1.5)
	screen_size = get_viewport_rect().size

func init(init_size, init_pos, init_vel):
	size = init_size
	
	if init_vel.length() > 0:
		vel = init_vel
	else:
		vel = Vector2(rand_range(30, 100), 0).rotated(rand_range(0, 2*PI))

	var texture = load(textures[init_size][randi() % textures[init_size].size()])
	get_node("sprite").set_texture(texture)
	# we divide by two b/c we care about how far the edge is from the center of the texture
	extents = texture.get_size() / 2
	var shape = CircleShape2D.new()
	shape.set_radius(min(texture.get_width()/2, texture.get_height()/2))
	add_shape(shape)
	set_pos(init_pos)

func _fixed_process(delta):
	vel = vel.clamped(300)
	set_rot(get_rot() + rot_speed * delta)
	move(vel * delta)

	if is_colliding():
		puff.set_global_pos(get_collision_pos())
		puff.set_emitting(true)
		vel += get_collision_normal() * (get_collider().vel.length() * bounce)

	# wrap around screen edges
	var pos = get_pos()
	if pos.x > screen_size.width + extents.width:
		pos.x = -extents.width
	if pos.x < -extents.width:
		pos.x = screen_size.width + extents.width
	if pos.y > screen_size.height + extents.height:
		pos.y = -extents.height
	if pos.y < -extents.height:
		pos.y = screen_size.height + extents.height

	set_pos(pos)

func explode(hit_vel):
	emit_signal("explode", size, get_pos(), vel, hit_vel)
	queue_free()
	
	
	