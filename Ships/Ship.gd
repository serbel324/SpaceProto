class_name Ship extends Node2D

# General ship manager
# Manages modules and hull
# Controlled by ShipController

var state: State.E = State.E.INITIALIZING
var ship_preset: ShipPreset = null
var team: Team.E

# hull
var hull: HullBase

# modules
var engine: EngineBase
var power_plant: PowerPlantBase
var fixed_weapon_points: Array[FixedWeaponPoint] = []
var active_modules: Array[ActiveModuleBase] = []

var subscriptions: Array[ShipSubscription] = []

var camera_to_bind_on_start: CameraController = null

# heat stats
# TODO: separate class??
var heat_current: float = 0.0
var heat_capacity: float = 0.0
var heat_dissipation: float = 0.0
var overheat_resistance: float = 0.0

# TODO: select weapon point scene based on ship preset
@export var fixed_weapon_point_scene: PackedScene = preload("res://Ships/Modules/Weapons/Weapon30mmCannon/Weapon30mmCannon.tscn")

func initialize(team_id: Team.E, start_ship_preset: ShipPreset, start_position: Vector2) -> void:
    team = team_id
    ship_preset = start_ship_preset
    position = start_position

func _ready() -> void:
    state = State.E.ALIVE

    # Initialize hull
    hull = ship_preset.hull_scene.instantiate() as HullBase
    hull.apply_ship_stats(calculate_ship_stats())
    hull.assign_to_ship(self)
    hull.initialize_entity(team, 100)
    # TODO: maybe we should attach hull to map, not to this manager?
    add_child(hull)

    # Bind main camera to hull
    if camera_to_bind_on_start != null:
        camera_to_bind_on_start.bind_to_node(hull)
        camera_to_bind_on_start = null

    # Initialize points
    for child in hull.get_children():
        if child is PointBase:
            child.assign_to_ship(self)
            if child is FixedWeaponPoint:
                fixed_weapon_points.append(child)

    # Set fixed weaponry
    replace_fixed_weaponry(fixed_weapon_point_scene)

    var ship_stats: ShipStats = calculate_ship_stats()

    # Initialize power plant
    power_plant = PowerPlantBase.new(
            ship_stats.power_plant_generation,
            ship_stats.power_plant_heat_generation) as PowerPlantBase
    assert(power_plant != null, "Power plant was not created")
    power_plant.attach_to_ship(self)

    # Initialize engine
    engine = EngineBase.new(ship_stats.engines_power_consumption,
        ship_stats.engines_heat_generation,
        ship_stats.main_engine_force,
        ship_stats.reverse_engine_force,
        ship_stats.turn_engine_force,
        ship_stats.side_engine_force) as EngineBase
    assert(engine != null, "Engine was not created")
    engine.attach_to_ship(self)
    hull.attach_engine(engine)

    # set equal power to all components
    power_plant.set_power_to_component(PowerPlantBase.Component.ENGINES, 1)
    power_plant.set_power_to_component(PowerPlantBase.Component.WEAPONS, 1)
    power_plant.set_power_to_component(PowerPlantBase.Component.ACTIVE_MODULES, 2)

    # Initialize heat state
    heat_capacity = ship_stats.heat_capacity
    heat_dissipation = ship_stats.heat_dissipation
    overheat_resistance = ship_stats.overheat_resistance

    # Initialize active modules
    var heat_dissipator: ActiveHeatDissipator = ActiveHeatDissipator.new()
    heat_dissipator.attach_to_ship(self)
    active_modules.append(heat_dissipator)

func _process(delta: float) -> void:
    match state:
        State.E.ALIVE:
            state_alive(delta)
        State.E.DEAD:
            destroy()
        _:
            pass

func bind_camera_to_hull(camera: CameraController) -> void:
    match state:
        State.E.INITIALIZING:
            camera_to_bind_on_start = camera
        State.E.ALIVE:
            camera.bind_to_node(hull)
        _:
            assert(false, "Wrong state")

func calculate_ship_stats() -> ShipStats:
    # TODO: implement module system, calculate ship stats based on modules
    var ship_stats: ShipStats = ShipStats.new()
    ship_stats.mass = 1
    ship_stats.main_engine_force = 100
    ship_stats.reverse_engine_force = 50
    ship_stats.turn_engine_force = 300
    ship_stats.side_engine_force = 30
    ship_stats.angular_damp = 1
    ship_stats.linear_friction = 0.05
    ship_stats.turn_friction = 0.05
    ship_stats.engines_power_consumption = 50
    ship_stats.power_plant_generation = 200

    ship_stats.heat_capacity = 100
    ship_stats.heat_dissipation = 10

    ship_stats.power_plant_heat_generation = 3
    ship_stats.engines_heat_generation = 3
    ship_stats.overheat_resistance = 10.0

    return ship_stats

func state_alive(delta: float) -> void:
    # hull movement
    update_power_state(delta)
    update_heat_state(delta)

    for active_module in active_modules:
        active_module.update(delta)

func set_movement(direction: EngineBase.EngineDirection, value: float) -> void:
    engine.set_movement(direction, value)

func reset_movement() -> void:
    engine.reset_movement()

func fire_fixed_weapons() -> void:
    for fixed_weapon_point in fixed_weapon_points:
        fixed_weapon_point.fire()

func replace_fixed_weaponry(new_weapon_scene: PackedScene) -> void:
    for fixed_weapon_point in fixed_weapon_points:
        fixed_weapon_point.update_weapon(new_weapon_scene)

func get_team() -> Team.E:
    return team

func hull_destroyed() -> void:
    state = State.E.DEAD
    destroy()

func destroy() -> void:
    for subscription in subscriptions:
        subscription.release()
    queue_free()

func get_engine() -> EngineBase:
    return engine

func set_energy_distribution(component: PowerPlantBase.Component, value: float) -> void:
    power_plant.set_power_to_component(component, value)

func set_power_output(value: float) -> void:
    power_plant.set_power_output(value)

func set_power_distribution(values: Dictionary) -> void:
    power_plant.reset_power_distribution()
    for component in values.keys():
        power_plant.set_power_to_component(component, values[component])

func get_heat_percentage() -> float:
    return heat_current / heat_capacity

func update_power_state(_delta: float) -> void:
    var power_to_engines: float = power_plant.get_power_to_component(PowerPlantBase.Component.ENGINES)
    engine.set_energy_supply(power_to_engines)

    var power_to_all_points: float = power_plant.get_power_to_component(PowerPlantBase.Component.WEAPONS)
    var power_to_each_point: float = power_to_all_points / fixed_weapon_points.size()

    for fixed_weapon_point in fixed_weapon_points:
        var installed_module: ModuleBase = fixed_weapon_point.get_installed_module()
        if installed_module != null:
            installed_module.set_energy_supply(power_to_each_point)

    var power_to_all_active_modules: float = power_plant.get_power_to_component(PowerPlantBase.Component.ACTIVE_MODULES)
    var power_to_each_active_module: float = power_to_all_active_modules / active_modules.size()
    for active_module in active_modules:
        active_module.set_energy_supply(power_to_each_active_module)

func update_heat_state(delta: float) -> void:
    var delta_heat: float = 0.0
    delta_heat += engine.get_heat_generated(delta)
    delta_heat += power_plant.get_heat_generated(delta)
    for fixed_weapon_point in fixed_weapon_points:
        var installed_module: ModuleBase = fixed_weapon_point.get_installed_module()
        if installed_module != null:
            delta_heat += installed_module.get_heat_generated(delta)

    for active_module in active_modules:
        delta_heat += active_module.get_heat_generated(delta)

    var dissipated_heat: float = heat_dissipation * delta

    heat_current = max(heat_current + delta_heat - dissipated_heat, 0)

    assert(heat_capacity > 0.0, "Heat capacity is not set")
    var relative_overheat: float = (heat_current - heat_capacity) / heat_capacity
    if relative_overheat > 0.0:
        var overheat_damage: float = relative_overheat / overheat_resistance
        hull.deal_damage(Team.E.ENVIRONMENT, overheat_damage)

func get_active_module_state(index: int) -> ActiveModuleState:
    if index < 0 or index >= active_modules.size():
        return null
    return active_modules[index].get_state()

func try_activate_active_module(index: int) -> void:
    if index >= 0 and index < active_modules.size():
        active_modules[index].try_activate()
