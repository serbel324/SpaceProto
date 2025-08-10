class_name ModuleBase

var energy_consumption: float = 0.0
var energy_supply: float = 0.0

var passive_heat_generation: float = 0.0
var heat_burst: float = 0.0

var ship: Ship = null

func _init(energy_consumption_value: float, heat_generation: float) -> void:
    energy_consumption = energy_consumption_value
    passive_heat_generation = heat_generation

func attach_to_ship(ship_value: Ship) -> void:
    ship = ship_value

func get_energy_consumption() -> float:
    return energy_consumption

func set_energy_consumption(value: float) -> void:
    energy_consumption = value

func set_energy_supply(value: float) -> void:
    energy_supply = value

func get_efficiency() -> float:
    if energy_consumption > 0.0:
        return energy_supply / energy_consumption
    else:
        return 1.0

func add_heat_burst(value: float) -> void:
    heat_burst += value

func get_heat_generated(delta: float) -> float:
    var heat_generated: float = passive_heat_generation * delta * get_efficiency() + heat_burst
    heat_burst = 0.0
    return heat_generated

func update(_delta: float) -> void:
    pass
