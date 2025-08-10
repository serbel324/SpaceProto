class_name ShipSubscription

var ship: Ship

func acquire(ship_: Ship) -> void:
    ship = ship_
    ship.subscriptions.append(self)

func release() -> void:
    ship = null

func is_acquired() -> bool:
    return ship != null

func get_ship() -> Ship:
    return ship
