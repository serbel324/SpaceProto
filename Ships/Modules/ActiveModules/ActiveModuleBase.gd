class_name ActiveModuleBase
extends ModuleBase

var state: ActiveModuleState = null

func _init(energy_consumption_value: float,
        heat_generation_value: float,
        cooldown_time_value: float) -> void:
    super(energy_consumption_value, heat_generation_value)
    state = ActiveModuleState.new(cooldown_time_value)

func activate() -> void:
    pass

func try_activate() -> void:
    if state.is_ready:
        activate()
        state.activate()

func update(delta: float) -> void:
    var delta_cooldown: float = delta * get_efficiency()
    state.update(delta_cooldown)

func get_state() -> ActiveModuleState:
    return state
