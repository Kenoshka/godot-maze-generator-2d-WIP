extends Node2D

var maze_size = Vector2(10, 10)
const point = preload("res://ScenesAndScripts/MazePathDot.tscn")
var astr = AStar2D.new()
var tries = 0

const START_POINT = 0
const FINAL_POINT = 98

var rng = RandomNumberGenerator.new()
var path : PoolIntArray

func _ready():
	rng.randomize()
	try_to_create_maze()

func _process(delta):
	pass

func create_points():
	rng.randomize()
	var maze_rect = Vector2(100 * maze_size.x, 100 * maze_size.y)
	$Maze.region_rect = Rect2(0, 0, maze_rect.x, maze_rect.y)
	for i in range(maze_size.x * maze_size.y):
		var pnt = point.instance()
		pnt.position.x = (i % int(maze_size.x) + 1) * 100 - (maze_rect.x / 2) - 50
		pnt.position.y = (int(i / maze_size.x) + 1) * 100 - (maze_rect.y / 2) - 50
		if bool(rng.randi_range(0, 1)):
			astr.add_point(i, pnt.position, rng.randf_range(1, 100))
		else:
			astr.add_point(i, pnt.position)
		$Maze/Points.add_child(pnt)

func try_to_create_maze():
	astr.clear()
	for child in $Maze/Points.get_children():
		$Maze/Points.remove_child(child)
		child.queue_free()
	$Line2D.clear_points()
	create_points()
	block_points()
	connect_maze_points()
	if not is_maze_possible():
		print("Failed to create maze")
		tries += 1
		try_to_create_maze()
	else:
		print(path)
		print(tries)
		tries = 0
		draw_path()
		draw_walls()

func block_points():
	for child in $Maze/Points.get_children():
		if child.get_position_in_parent() != START_POINT or child.get_position_in_parent() != FINAL_POINT:
			child.notBlocked = bool(rng.randi_range(0, 3))

func connect_maze_points():
	var childs = $Maze/Points.get_children()
	var count = $Maze/Points.get_child_count()
	for i in count - 1:
		if i < count - maze_size.x:
			if childs[i].notBlocked and childs[i + maze_size.x].notBlocked:
				astr.connect_points(i, i + maze_size.x)
		if childs[i].notBlocked and childs[i + 1].notBlocked:
			if (i % int(maze_size.x) != maze_size.x - 1):
				astr.connect_points(i, i + 1)

func is_maze_possible():
	if astr.get_id_path(START_POINT, FINAL_POINT).size() > 0:
		path = astr.get_id_path(START_POINT, FINAL_POINT)
		return true
	else:
		return false

func draw_path():
	var child = $Maze/Points.get_children()
	for point in path:
		$Line2D.add_point(child[point].global_position)

func draw_walls():
	for i in path.size():
		pass

func _on_Button_pressed():
	try_to_create_maze()
