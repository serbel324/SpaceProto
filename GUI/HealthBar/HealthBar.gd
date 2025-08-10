class_name HealthBar
extends Control

var max_hitpoints: int
var current_hitpoints: int
var frames_count: int

var label: Label = null
var texture: AnimatedSprite2D = null

func set_hitpoints(max_hitpoints_: float, current_hitpoints_: float) -> void:
    max_hitpoints = ceil(max_hitpoints_)
    current_hitpoints = floor(current_hitpoints_)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    label = get_node("Label")
    texture = get_node("Texture")
    assert(label != null, "Label not found")
    assert(texture != null, "Texture not found")

    texture.pause()
    frames_count = texture.get_sprite_frames().get_frame_count("Stages")

func calculate_stage() -> int:
    return floor(float(current_hitpoints) / float(max_hitpoints) * frames_count)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    label.text = str(current_hitpoints) + "/" + str(max_hitpoints)
    texture.set_frame_and_progress(calculate_stage(), 0.0)
