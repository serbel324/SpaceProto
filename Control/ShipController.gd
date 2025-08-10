class_name ShipController extends Node

var possessed_ship: ShipSubscription = null

func _init() -> void:
    possessed_ship = ShipSubscription.new()

func set_possessed_ship(ship: Ship) -> void:
    possessed_ship.acquire(ship)
