class_name FixedWeaponPoint
extends PointBase

var weapon: WeaponBase = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.

func update_weapon(new_weapon_scene: PackedScene) -> void:
    if weapon != null:
        weapon.queue_free()

    weapon = new_weapon_scene.instantiate() as WeaponBase
    weapon.initialize(self_ship)
    add_child(weapon)

func fire() -> void:
    if weapon != null:
        weapon.fire()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass

func get_installed_module() -> ModuleBase:
    if weapon != null:
        return weapon.as_module()
    return null
