extends Node2D


export (Texture) var texture setget _set_texture

func _set_texture(value):
	# If the texture variable is modified externally,
	# this callback is called.
	texture = value  # Texture was changed.
	update()  # Update the node's visual representation.

func _draw():
	draw_texture(texture, Vector2(10,200))
