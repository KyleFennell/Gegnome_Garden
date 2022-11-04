tool
extends GridContainer

export(int) var label_row_height = 30 setget set_label_row_height
export(int) var label_column_width = 70 setget set_label_column_width
export(int) var data_cell_height = 50 setget set_data_cell_height
export(int) var data_cell_width = 100 setget set_data_cell_width

export(Resource) var father
export(Resource) var mother
export(String) var property

onready var gridContainer = $GridContainer
onready var topLeftCell = $TopLeftCell
onready var paternalCells = [$PaternalGene1, $PaternalGene2]
onready var maternalCells = [$MaternalGene1, $MaternalGene2]
onready var childCells = [$Child1, $Child2, $Child3, $Child4]

func set_label_row_height(value):
	label_row_height = value
	if not (topLeftCell or paternalCells):
		return
	dimentions_updated()
	
func set_label_column_width(value):
	label_column_width = value
	if not (topLeftCell or maternalCells):
		return
	dimentions_updated()
	
func set_data_cell_height(value):
	data_cell_height = value
	if not (paternalCells or childCells):
		return
	dimentions_updated()
	
func set_data_cell_width(value):
	data_cell_width = value
	if not (maternalCells or childCells):
		return
	dimentions_updated()

func dimentions_updated():
	topLeftCell.rect_min_size = Vector2(label_column_width, label_row_height)
	for c in paternalCells:
		c.rect_min_size = Vector2(data_cell_width, label_row_height)
	for c in maternalCells:
		c.rect_min_size = Vector2(label_column_width, data_cell_height)
	for c in childCells:
		c.rect_min_size = Vector2(data_cell_width, data_cell_height)

func _ready():
	dimentions_updated()
