class_name PowerPlantBase
extends ModuleBase

enum Component {
    ENGINES,
    WEAPONS,
    ACTIVE_MODULES,
}

var power_generation: float = 100
var power_output: float = 0
var power_distribution: Dictionary
var total_power: float = 0

func _init(power_generation_value: float, heat_generation_value: float):
    super(0.0, heat_generation_value) # Power plant doesn't consume power
    power_generation = power_generation_value
    power_output = 1.0
    for component in Component.values():
        power_distribution[component] = 0

func calculate_total_power():
    total_power = 0
    for power in power_distribution.values():
        total_power += power

func set_power_to_component(component: Component, value: float):
    power_distribution[component] = value
    calculate_total_power()

func get_power_to_component(component: Component):
    if total_power == 0:
        return 0
    return power_distribution[component] / total_power * power_output * power_generation

func set_power_output(value: float):
    power_output = clamp(value, 0, 1)

func get_power_output():
    return power_output

func reset_power_distribution():
    for component in Component.values():
        power_distribution[component] = 0
    calculate_total_power()