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
	if not result:
		return
	if result["context"] == InputHandler.Context.mouse_moved:
		var coords = get_mouse_coords()
		if coords in grid:
			focused_tile = grid[coords]
		prints(coords, focused_tile and focused_tile.terrain == 0)
	elif result["context"] == InputHandler.Context.mouse_pressed and result["action"] == InputHandler.PlayerActions.INTERACT:
		move_to($Mob, get_mouse_coords())

func init_grid():
	grid = {}
	var map_layers = tile_maps.get_children()
	for layer_num in range(len(map_layers)):
		var layer: TileMapLayer = map_layers[layer_num]
		for cell in layer.get_used_cells():
			var coords = Vector3i(cell.x, cell.y + layer_num, layer_num)
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
			
func move_to(node, grid_coord):
	if not grid_coord:
		print("Invalid move destination!")
		return
	var layer_num = grid_coord.z
	var coord = Vector2i(grid_coord.x, grid_coord.y - layer_num)
	if grid_coord in grid and grid[grid_coord].terrain == 0:
		var tile_pos = tile_maps.get_child(layer_num).map_to_local(coord)
		var sprite_height = node.get_rect().size.y * node.scale.y
		
		node.z_index = layer_num + 1
		node.position = tile_pos + Vector2(0, 48 - sprite_height)
	
