class_name HullBase
extends Entity

var engines_power_consumption: float = 50
var engines_power_provided: float = 0.0
var engines_efficiency: float = 1.0

var ship_stats: ShipStats = null
var ship: Ship = null
var engine: EngineBase = null

func apply_ship_stats(effective_ship_stats: ShipStats) -> void:
	mass = effective_ship_stats.mass
	ship_stats = effective_ship_stats

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state = State.E.ALIVE
	gravity_scale = 0.0
	contact_monitor = true

func assign_to_ship(self_ship: Ship) -> void:
	ship = self_ship

func attach_engine(engine_value: EngineBase) -> void:
	engine = engine_value

func state_alive(_delta: float) -> void:
	var dir_forward: Vector2 = get_global_transform().x

	apply_central_force(dir_forward * engine.get_effective_engine_force(EngineBase.EngineDirection.FORWARD))
	apply_central_force(-dir_forward * engine.get_effective_engine_force(EngineBase.EngineDirection.REVERSE))

	var dir_side: Vector2 = get_global_transform().y
	apply_central_force(dir_side * engine.get_effective_engine_force(EngineBase.EngineDirection.SIDE))
	apply_torque(engine.get_effective_engine_force(EngineBase.EngineDirection.TURN))

	var linear_friction_force: Vector2 = -linear_velocity * ship_stats.linear_friction
	var turn_friction_force: float = -angular_velocity * ship_stats.turn_friction
	apply_central_force(linear_friction_force)
	apply_torque(turn_friction_force)

func on_death() -> void:
	# TODO: Play death animation
	ship.hull_destroyed()
	ship = null
	engine = null
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	act(_delta)
