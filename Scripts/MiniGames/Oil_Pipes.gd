extends Node2D

@onready var pipes: TileMap = $Pipes
@onready var wrench = $wrench

signal repaired

# Connections (smaller number first
#		1
#	4		2
#		3

var pipe_tiles = {
	13 : Vector2i(0, 1), # straight
	24 : Vector2i(1, 0),
	
	23 : Vector2i(2, 2), # curve
	34 : Vector2i(3, 2),
	12 : Vector2i(2, 3),
	14 : Vector2i(3, 3),
}

var board_template = [
	[Vector2i(7, 3), Vector2i(8, 3), Vector2i(9, 3), Vector2i(10, 3)],
	[Vector2i(7, 4), Vector2i(8, 4), Vector2i(9, 4), Vector2i(10, 4)],
	[Vector2i(7, 5), Vector2i(8, 5), Vector2i(9, 5), Vector2i(10, 5)],
	[Vector2i(7, 6), Vector2i(8, 6), Vector2i(9, 6), Vector2i(10, 6)],
]


var boards = [
	[
		[14, 13, 23, 14],
		[23, 14, 14, 14],
		[14, 24, 13, 12],
		[14, 24, 23, 13]
	],
	[
		[23, 13, 13, 34],
		[24, 12, 14, 24],
		[13, 12, 14, 13],
		[24, 34, 24, 24] 
	],
	[
		[24, 23, 24, 13],
		[14, 12, 34, 34],
		[34, 24, 23, 24],
		[24, 14, 12, 14]
	]
]

var boards_solved = [
	[
		[0, 0, 0, 0],
		[0, 0, 23, 34],
		[34, 0, 13, 12],
		[12, 24, 14, 0]
	],
	[
		[0, 0, 0, 0],
		[0, 23, 34, 0],
		[24, 14, 12, 24],
		[0, 0, 0, 0] 
	],
	[
		[0, 0, 0, 0],
		[23, 34, 0, 0],
		[14, 13, 23, 24],
		[0, 12, 14, 0]
	]
]
var current_board
var current_solution


func _ready():
	var r = randi() % boards.size()
	current_board = boards[r]
	current_solution = boards_solved[r]
	
	for i in range(4):
		for j in range(4):
			pipes.set_cell(0, board_template[i][j], 1, pipe_tiles.get(current_board[i][j]))


func _input(_event):
	if Input.is_action_just_released("turn_pipe"): # TODO test if double-rotate bug is fixed
		var mouse_pos = get_global_mouse_position()
		mouse_pos.x += 33
		var tile_position = pipes.local_to_map(mouse_pos)/4
		if tile_position.x >= 7 and tile_position.x <= 10 and tile_position.y >= 3 and tile_position.y <= 6:
			turn_pipe(tile_position)
			if solved(): 
				emit_signal("repaired")

func turn_pipe(tile_position: Vector2i): 
	if solved():
		return
	wrench.play(0)
	var x = tile_position.x - 7
	var y = tile_position.y - 3
	var current_tile = current_board[y][x]
	match current_tile:
		13: 
			current_tile = 24
		24: 
			current_tile = 13
		23: 
			current_tile = 34
		34: 
			current_tile = 14
		12:
			current_tile = 23
		14:
			current_tile = 12
	current_board[y][x] = current_tile
	pipes.set_cell(0, tile_position, 1, pipe_tiles.get(current_tile))

func solved(): # Test if Puzzle is solved
	for i in range(4):
		for j in range(4):
			if current_solution[i][j] == 0:
				continue
			if current_solution[i][j] != current_board[i][j]:
				return false
	return true
				
