class_name Entity
extends RigidBody2D

var state: State.E = State.E.INITIALIZING
var hitpoints: float = 0
var max_hitpoints: float = 0
var team: Team.E

func initialize_entity(team_id: Team.E, max_hp: float) -> void:
    team = team_id
    hitpoints = max_hp
    max_hitpoints = max_hp

func state_alive(_delta: float) -> void:
    pass

func state_dead(_delta: float) -> void:
    pass

func state_initializing(_delta: float) -> void:
    pass

func act(_delta: float) -> void:
    match state:
        State.E.ALIVE:
            state_alive(_delta)
        State.E.DEAD:
            state_dead(_delta)
        State.E.INITIALIZING:
            state_initializing(_delta)
        _:
            assert(false, "Invalid state")

func on_damage(_damage: float) -> void:
    pass

func on_death() -> void:
    pass

func deal_damage(damage_team: Team.E, damage_amount: float) -> void:
    if damage_team != team:
        if hitpoints <= damage_amount:
            hitpoints = 0
            state = State.E.DEAD
            on_death()
        else:
            hitpoints -= damage_amount
            on_damage(damage_amount)

func get_hitpoints() -> float:
    return hitpoints

func get_max_hitpoints() -> float:
    return max_hitpoints
