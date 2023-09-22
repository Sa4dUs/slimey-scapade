extends Node2D

var tilemap: TileMap
var players: Node2D
var coins: Node2D
var boxes: Node2D

var state: Stack
var current_level_state: LevelState

class LevelState:
	var tilemap_info: Array
	var player_prefs: Array
	var coin_prefs: Array
	var box_prefs: Array
	
	func __init__():
		tilemap_info = []
		player_prefs = []
		coin_prefs = []
		box_prefs = []
			
	func build_level_info(tilemap, players, coins, boxes):
		self.build_tilemap_info(tilemap)
		self.build_players_info(players)
		self.build_coins_info(coins)
		self.build_boxes_info(boxes)
		
	func extract_data_from_node(node: Node2D) -> Array:
		var result = []
		if node:
			for i in range(node.get_child_count()):
				var aux = node.get_child(i)
				result.append(aux.position)
			
		return result
	func build_tilemap_info(tilemap: TileMap):
		var raw_data = tilemap.get_used_cells(0).duplicate()
		
		for i in range(raw_data.size()):
			var coords = raw_data[i]
			var tile = tilemap.get_cell_source_id(0, raw_data[i])
			tilemap_info.append([coords, tile])
		
	func build_players_info(node: Node2D):
		player_prefs = extract_data_from_node(node)
			
	func build_coins_info(node: Node2D):
		coin_prefs = extract_data_from_node(node)
			
	func build_boxes_info(node: Node2D):
		box_prefs = extract_data_from_node(node)

class Stack:
	var info: LevelState
	var next: Stack
	
	func __init__(s: Stack = null):
		if s:
			self.info = s.info
			self.next = s.next
		else:
			info = null
			next = null
		
	func is_empty():
		return !info
		
	func push(e: LevelState):
		if self.is_empty():
			info = e
		else:
			var aux = self
			self.next = aux
			self.info = e
			
	func pop():
		if !self.is_empty():
			if self.next:			
				self.info = self.next.info
				self.next = self.next.next
			else:
				self.info = null			
				self.next = null
	
	func top() -> LevelState:
		return self.info

func load_current_level_info() -> LevelState:
	
	var result = LevelState.new()
	
	result.build_level_info(tilemap, players, coins, boxes)
	
	return result
	
func update_state():
	print("StateManager.gd/update_state()")
	var aux = load_current_level_info()
	state.push(aux)
	
func load_tilemap_state(tilemap_state: Array):
	for i in range(tilemap_state.size()):
		var coords = tilemap_state[i][0]
		var tile = tilemap_state[i][1]
		
		# Get old data
		var old_tile = tilemap.get_cell_source_id(0, coords)
		
		if old_tile != tile:
			print("StateManager.gd/load_tilemap_state ", coords, ' ', old_tile, ' -> ', tile)
		
		tilemap.set_cell(0, coords, tile, Vector2i(0, 0))
	
func load_player_state(player_state: Array):
	for i in range(player_state.size()):
		var aux = players.get_child(i)
		print(aux.position, ' ', player_state[i])
		aux.position = player_state[i]
	
func load_coin_state(coin_state: Array):
	pass
	
func load_box_state(box_state: Array):
	pass	
	
func load_state(state: LevelState):
	load_tilemap_state(state.tilemap_info)
	load_player_state(state.player_prefs)
	load_coin_state(state.coin_prefs)
	load_box_state(state.coin_prefs)
	
func revert_move():
	state.pop()
	if !state.is_empty():
		load_state(state.top())

# Called when the node enters the scene tree for the first time.
func _ready():
	# Wait for the level to download
	await get_tree().create_timer(0.1).timeout
	
	# Variable initialization
	state = Stack.new()
	
	var root = get_tree().get_current_scene()
	var level = root.get_node("Level")
	
	if level:
		tilemap = level.get_node("TileMap")
		players = level.get_node("Players")
		coins = level.get_node("Coins")
		boxes = level.get_node("Boxes")
		
	update_state()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
