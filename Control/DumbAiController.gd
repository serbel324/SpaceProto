class_name DumbAiController
extends ShipController

enum DumbAiAction {
    DO_NOTHING,
    MOVE_FORWARD,
    MOVE_BACKWARD,
    TURN_LEFT,
    TURN_RIGHT,
    FIRE_WEAPON,
}

var state_change_time_sec: float = 3.0
var state_change_timer: float = 0.0

var current_action: DumbAiAction = DumbAiAction.MOVE_FORWARD
var state: State.E = State.E.INITIALIZING

func _ready() -> void:
    state = State.E.ALIVE

func state_alive(delta: float) -> void:
    if state_change_timer <= delta:
        state_change_timer = state_change_time_sec
        current_action = DumbAiAction.values()[randi() % DumbAiAction.size()]
    else:
        state_change_timer -= delta
    do_action()

func do_action() -> void:
    possessed_ship.get_ship().reset_movement()
    match current_action:
        DumbAiAction.MOVE_FORWARD:
            possessed_ship.get_ship().set_movement(EngineBase.EngineDirection.FORWARD, 1.0)
        DumbAiAction.MOVE_BACKWARD:
            possessed_ship.get_ship().set_movement(EngineBase.EngineDirection.REVERSE, 1.0)
        DumbAiAction.TURN_LEFT:
            possessed_ship.get_ship().set_movement(EngineBase.EngineDirection.TURN, -1.0)
        DumbAiAction.TURN_RIGHT:
            possessed_ship.get_ship().set_movement(EngineBase.EngineDirection.TURN, 1.0)
        DumbAiAction.FIRE_WEAPON:
            possessed_ship.get_ship().fire_fixed_weapons()
        DumbAiAction.DO_NOTHING:
            pass

func _process(delta: float) -> void:
    if !possessed_ship.is_acquired():
        return

    match state:
        State.E.ALIVE:
            state_alive(delta)
        _:
            assert(false, "Invalid state")
