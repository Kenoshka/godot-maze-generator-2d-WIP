extends Position2D
class_name Dot

enum {
	CORRIDOR,
	TURN,
	CROSS,
	T_CROSS
}

var notBlocked = true setget set_block

func set_block(value):
	notBlocked = value
	if value == false:
		modulate = Color(0, 0, 0)

func set_walls(wall):
	pass
