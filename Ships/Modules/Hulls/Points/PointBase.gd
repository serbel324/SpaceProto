class_name PointBase
extends Node2D

var self_ship: Ship

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass

func assign_to_ship(ship: Ship) -> void:
    self_ship = ship

func get_installed_module() -> ModuleBase:
    return null
