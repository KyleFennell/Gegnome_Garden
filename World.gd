extends Node2D

@onready var UIResource = load("res://UI/UIRes.tres")
@onready var GenotypeViewer = $Control/GenotypeViewer
@onready var CrossBreedViewer = $Control/CrossBreedViewer

func _ready():
	UIResource.GenotypeViewer = GenotypeViewer
	UIResource.CrossBreedViewer = CrossBreedViewer

