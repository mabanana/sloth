extends Node2D
class_name GridMapController

@export var tile_maps: Node2D
var grid: Dictionary # Vector3 : TileData
var main: Main
var focused_tile: TileData

# Called when the node enters the scene tree for the first time.
func _ready():
	main = get_parent()
	init_grid()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	var result = main.input_handler.handle_input(event)
	if event is InputEventMouseMotion:
		var coords = get_mouse_coords()
		if coords in grid:
			focused_tile = grid[coords]
		prints(coords, focused_tile and focused_tile.terrain == 0)

func init_grid():
	grid = {}
	var map_layers = tile_maps.get_children()
	for layer_num in range(len(map_layers)):
		var layer: TileMapLayer = map_layers[layer_num]
		for cell in layer.get_used_cells():
			var coords = Vector3i(cell.x, cell.y, layer_num)
			grid[coords] = layer.get_cell_tile_data(cell)
	print(grid)

func get_mouse_coords():
	var mouse_pos = get_viewport().get_mouse_position()
	var map_layers = tile_maps.get_children()
	for layer_num in range(len(map_layers) - 1, -1, -1):
		var layer: TileMapLayer = map_layers[layer_num]
		var mouse_grid_coord = layer.local_to_map(mouse_pos)
		var coords = Vector3i(mouse_grid_coord.x, mouse_grid_coord.y + layer_num, layer_num)
		if coords in grid:
			return coords
			
