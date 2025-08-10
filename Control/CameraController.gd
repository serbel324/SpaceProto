class_name CameraController
extends Camera2D

var node_in_focus: Node2D = null
var rotation_locked: bool = false
var battle_gui: BattleGui = null

@export var rotation_lock_offset: float = PI / 2.0

func _ready() -> void:
    pass

func _process(_delta: float) -> void:
    # move camera to the node in focus
    if node_in_focus != null:
        global_position = node_in_focus.global_position
        if rotation_locked:
            global_rotation = node_in_focus.global_rotation + rotation_lock_offset
        else:
            global_rotation = 0.0

func bind_to_node(node: Node2D) -> void:
    node_in_focus = node

func set_rotation_lock(value: bool) -> void:
    rotation_locked = value
