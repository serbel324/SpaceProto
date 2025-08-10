class_name BattleGui
extends Control

var health_bar: HealthBar = null
var camera_rotation_locked_icon: Control = null
var ship_in_focus: ShipSubscription = null
var power_output_slider: HSlider = null
var power_distribution_slider: HSlider = null
var heat_bar: ProgressBar = null

var active_module_activation_buttons: Array[ActiveModuleActivationButton] = []

func _init() -> void:
   ship_in_focus = ShipSubscription.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    camera_rotation_locked_icon = get_node("CameraRotationLockIcon") as Control
    assert(camera_rotation_locked_icon != null, "CameraRotationLockIcon not found")
    health_bar = get_node("HealthBar") as HealthBar
    assert(health_bar != null, "HealthBar not found")

    power_output_slider = get_node("PowerOutputSlider") as HSlider
    assert(power_output_slider != null, "PowerOutputSlider not found")

    power_distribution_slider = get_node("PowerDistributionSlider") as HSlider
    assert(power_distribution_slider != null, "PowerDistributionSlider not found")

    heat_bar = get_node("HeatBar") as ProgressBar
    assert(heat_bar != null, "HeatBar not found")

    for i in range(1):
        var idx = i + 1
        var node_name: String = "ActiveModuleActivationButton" + str(idx)
        var active_module_activation_button: ActiveModuleActivationButton = get_node(node_name) as ActiveModuleActivationButton
        assert(active_module_activation_button != null, node_name + " not found")
        active_module_activation_buttons.append(active_module_activation_button)

func acquire_ship(ship: Ship) -> void:
    ship_in_focus.acquire(ship)

func set_camera_rotation_locked(value: bool) -> void:
    camera_rotation_locked_icon.visible = value

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    if ship_in_focus.is_acquired():
        health_bar.set_hitpoints(ship_in_focus.get_ship().hull.get_max_hitpoints(),
                                 ship_in_focus.get_ship().hull.get_hitpoints())

    for i in range(active_module_activation_buttons.size()):
        var state = ship_in_focus.get_ship().get_active_module_state(i)
        if state != null:
            active_module_activation_buttons[i].apply_state(state)

func get_energy_output() -> float:
    return power_output_slider.value / power_output_slider.max_value

func get_power_distribution() -> float:
    return power_distribution_slider.value / power_distribution_slider.max_value

func set_heat_percentage(heat: float) -> void:
    heat_bar.value = heat * heat_bar.max_value
