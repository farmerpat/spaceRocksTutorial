extends Node

# if memory serves, this class is like GameManager in cooking w/
# unity examples
 # game settings
var game_over = false
var score = 0
var level = 0

# player settings
var shield_max = 100
var shield_regen = 10

# asteroid settings
var break_pattern = {
	'big': 'med',
	'med': 'small',
	'small': 'tiny',
	'tiny': null
}

var ast_damage = {
	'big': 40,
	'med': 20,
	'small': 15,
	'tiny': 10
}

var ast_points = {
	'big': 10,
	'med': 15,
	'small': 20,
	'tiny': 40 
}