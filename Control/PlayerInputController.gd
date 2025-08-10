class_name PlayerInputController extends ShipController

var main_camera: CameraController = null
var battle_gui: BattleGui = null

var camera_rotation_locked: bool = false

func set_main_camera(camera: CameraController) -> void:
    main_camera = camera

func set_battle_gui(gui: BattleGui) -> void:
    battle_gui = gui

func _process(_delta: float) -> void:
    if !possessed_ship.is_acquired():
        return

    var forward_movement: float = Input.get_action_strength("move_forward")
    var backward_movement: float = Input.get_action_strength("move_backward")
    var left_side_movement: float = Input.get_action_strength("move_left")
    var right_side_movement: float = Input.get_action_strength("move_right")
    var left_turn: float = Input.get_action_strength("turn_left")
    var right_turn: float = Input.get_action_strength("turn_right")

    var side_movement: float = right_side_movement - left_side_movement
    var turn_movement: float = right_turn - left_turn

    possessed_ship.get_ship().set_movement(EngineBase.EngineDirection.REVERSE, backward_movement)
    possessed_ship.get_ship().set_movement(EngineBase.EngineDirection.FORWARD, forward_movement)
    
    possessed_ship.get_ship().set_movement(EngineBase.EngineDirection.TURN, turn_movement)
    possessed_ship.get_ship().set_movement(EngineBase.EngineDirection.SIDE, side_movement)

    if Input.is_action_just_pressed("lock_camera_rotation"):
        camera_rotation_locked = !camera_rotation_locked
        main_camera.set_rotation_lock(camera_rotation_locked)

    battle_gui.set_camera_rotation_locked(camera_rotation_locked)

    if Input.is_action_pressed("fire_fixed_weapons"):
        possessed_ship.get_ship().fire_fixed_weapons()

    if Input.is_action_just_pressed("selfharm"):
        possessed_ship.get_ship().hull.deal_damage(Team.E.ENEMY, 10)

    possessed_ship.get_ship().set_power_output(battle_gui.get_energy_output())

    var power_distribution_ratio: float = battle_gui.get_power_distribution()
    var power_distribution: Dictionary = {}
    power_distribution[PowerPlantBase.Component.ENGINES] = power_distribution_ratio
    power_distribution[PowerPlantBase.Component.WEAPONS] = 1 - power_distribution_ratio
    power_distribution[PowerPlantBase.Component.ACTIVE_MODULES] = 1
    possessed_ship.get_ship().set_power_distribution(power_distribution)

    battle_gui.set_heat_percentage(possessed_ship.get_ship().get_heat_percentage())

    if Input.is_action_just_pressed("activate_active_module_1"):
        possessed_ship.get_ship().try_activate_active_module(0)
