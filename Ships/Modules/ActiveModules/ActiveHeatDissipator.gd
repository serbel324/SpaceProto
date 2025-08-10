class_name ActiveHeatDissipator
extends ActiveModuleBase

var heat_dissipation: float = 10.0
var heat_dissipation_time: float = 1.0
var heat_dissipation_timer: float = 0.0
var cooldown_power_consumption: float = 100.0

func _init() -> void:
    super(cooldown_power_consumption, 0.0, heat_dissipation_time * 2)

func activate() -> void:
    heat_dissipation_timer = heat_dissipation_time

func get_heat_generated(delta: float) -> float:
    if heat_dissipation_timer == 0.0:
        return 0.0
    else:
        return heat_dissipation * delta * -1

func update(delta: float) -> void:
    super(delta)
    heat_dissipation_timer = max(heat_dissipation_timer - delta, 0.0)
