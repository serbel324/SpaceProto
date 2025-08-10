class_name ActiveModuleActivationButton
extends Control

var button: TextureButton = null
var progress_bar: ProgressBar = null

func _ready() -> void:
    button = get_node("Button") as TextureButton
    assert(button != null, "Button not found")
    progress_bar = get_node("ProgressBar")
    assert(progress_bar != null, "ProgressBar not found")

func apply_state(state: ActiveModuleState) -> void:
    button.release_focus()
    if state.is_ready:
        button.disabled = false
        progress_bar.visible = false
    else:
        button.disabled = true
        progress_bar.visible = true
        progress_bar.value = state.get_progress_percentage() * 100

# TODO: activate module on click
func _on_button_pressed() -> void:
    pass
