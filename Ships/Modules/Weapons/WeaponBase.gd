class_name WeaponBase
extends Node2D
# TODO? this class is not inherited from ModuleBase
# Maybe we should make separate Weapon controller class
# and weapon puppet Node2D class

var self_ship: Ship
var self_module: ModuleBase = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    # TODO: variable energy consumption
    pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass

func fire() -> void:
    pass

func initialize(ship: Ship) -> void:
    self_ship = ship

    # Weapon doesn't generate heat when idle
    # TODO: variable energy consumption
    self_module = ModuleBase.new(25.0, 0.0)

func as_module() -> ModuleBase:
    return self_module
