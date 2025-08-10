class_name EngineBase
extends ModuleBase

enum EngineDirection {
    FORWARD,
    REVERSE,
    TURN,
    SIDE
}

var movement: Dictionary = {}
var engine_force: Dictionary = {}

func _init(energy_consumption_value: float,
        heat_generation_value: float,
        front_engine_force_value: float,
        reverse_engine_force_value: float,
        turn_engine_force_value: float,
        side_engine_force_value: float) -> void:
    super(energy_consumption_value, heat_generation_value)
    engine_force[EngineDirection.FORWARD] = front_engine_force_value
    engine_force[EngineDirection.REVERSE] = reverse_engine_force_value
    engine_force[EngineDirection.TURN] = turn_engine_force_value
    engine_force[EngineDirection.SIDE] = side_engine_force_value

    for direction in EngineDirection.values():
        movement[direction] = 0.0

func set_movement(direction: EngineDirection, value: float) -> void:
    movement[direction] = value

func reset_movement() -> void:
    for direction in EngineDirection.values():
        movement[direction] = 0.0

func get_effective_engine_force(direction: EngineDirection) -> float:
    return movement[direction] * engine_force[direction] * get_efficiency()
