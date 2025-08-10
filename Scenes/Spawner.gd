class_name Spawner extends Node

@export var player_controller_scene: PackedScene
@export var ai_dumb_controller_scene: PackedScene
@export var player_ship_hull_scene: PackedScene
@export var ship_scene: PackedScene = null

var main_scene: Node2D
var main_camera: CameraController
var battle_gui: BattleGui

var player_input: PlayerInputController
var player_start_position: Node2D = null
var enemy_start_position: Node2D = null

func _ready() -> void:
    main_scene = get_parent() as Node2D
    assert(main_scene != null, "MainScene not found")

    player_start_position = main_scene.get_node("PlayerStartPosition") as Node2D
    assert(player_start_position != null, "PlayerStartPosition not found")

    enemy_start_position = main_scene.get_node("EnemyStartPosition") as Node2D
    assert(enemy_start_position != null, "EnemyStartPosition not found")

    main_camera = main_scene.get_node("MainCamera") as CameraController
    assert(main_camera != null, "MainCamera not found")

    battle_gui = main_scene.get_node("GuiLayer/BattleGui") as BattleGui
    assert(battle_gui != null, "BattleGui not found")

    spawn_player_ship()
    spawn_enemy_ship()

func spawn_player_ship() -> void:
    if player_input == null:
        player_input = player_controller_scene.instantiate() as PlayerInputController
        assert(player_input != null, "PlayerInput wasn't instantiated")
        main_scene.add_child.call_deferred(player_input)
        player_input.set_main_camera(main_camera)
        player_input.set_battle_gui(battle_gui)

    var ship_preset: ShipPreset = ShipPreset.new(player_ship_hull_scene)
    var player_ship: Ship = ship_scene.instantiate() as Ship
    player_ship.initialize(Team.E.PLAYER, ship_preset, player_start_position.position)
    # TODO: get hp from ship preset
    main_scene.add_child.call_deferred(player_ship)
    player_input.set_possessed_ship(player_ship)
    player_ship.bind_camera_to_hull(main_camera)
    battle_gui.acquire_ship(player_ship)


func spawn_enemy_ship() -> void:
    var enemy_input: DumbAiController = ai_dumb_controller_scene.instantiate() as DumbAiController
    assert(enemy_input != null, "EnemyInput wasn't instantiated")
    main_scene.add_child.call_deferred(enemy_input)

    var ship_preset: ShipPreset = ShipPreset.new(player_ship_hull_scene)
    var enemy_ship: Ship = ship_scene.instantiate() as Ship
    # TODO: get hp from ship preset
    enemy_ship.initialize(Team.E.ENEMY, ship_preset, enemy_start_position.position)
    main_scene.add_child.call_deferred(enemy_ship)
    enemy_input.set_possessed_ship(enemy_ship)
