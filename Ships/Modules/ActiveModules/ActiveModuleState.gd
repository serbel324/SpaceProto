class_name ActiveModuleState

var is_ready: bool = false
var cooldown_time: float = 0.0
var cooldown_timer: float = 0.0

func _init(cooldown_time_value: float) -> void:
    cooldown_time = cooldown_time_value
    cooldown_timer = cooldown_time
    is_ready = false

func update(delta_cooldown: float) -> void:
    if cooldown_timer <= delta_cooldown:
        is_ready = true
        cooldown_timer = 0.0
    else:
        cooldown_timer -= delta_cooldown
        is_ready = false

func activate() -> void:
    cooldown_timer = cooldown_time
    is_ready = false

func get_progress_percentage() -> float:
    return clamp(1 - cooldown_timer / cooldown_time, 0.0, 1.0)
