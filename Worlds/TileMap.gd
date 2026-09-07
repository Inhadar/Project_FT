extends TileMap


var x_lenght = 512

func _ready():
	for x in range (0,x_lenght):
		set_cell(x,0,0)
		set_cell(x,0,10)
		set_cell(x,16,3)
		for y in range(0,16):
			if get_cell(x,y) == 10 and get_cell(x,y+1) == -1:
				set_cell(x,y+1,10)
				
