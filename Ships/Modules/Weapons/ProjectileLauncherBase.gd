class_name ProjectileLauncherBase
extends WeaponBase

# TODO: replace exports with presets
@export var projectile_scene: PackedScene = null
@export var cooldown_sec: float = 0.0
@export var projectile_speed: float = 0.0
@export var projectile_offset: Vector2 = Vector2.ZERO
@export var heat_generated_per_shot: float = 0.0

var main_scene: Node2D = null

var cooldown_time: float = 0.0

# TODO
# var backward_impulse: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    main_scene = get_node("/root/MainScene") as Node2D

func fire() -> void:
    if cooldown_time == 0.0:
        as_module().add_heat_burst(heat_generated_per_shot)
        launch_projectile()
        cooldown_time = cooldown_sec

func launch_projectile() -> void:
    var projectile: ProjectileBase = projectile_scene.instantiate() as ProjectileBase
    main_scene.add_child(projectile)
    var projectile_velocity: Vector2 = Vector2.RIGHT.rotated(global_rotation) * projectile_speed
    var projectile_position: Vector2 = global_position + projectile_offset.rotated(global_rotation)
    projectile.initialize(self_ship.get_team(), projectile_position, global_rotation, projectile_velocity)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    var delta_cd: float = delta * self_module.get_efficiency()
    if cooldown_time > 0.0:
        if cooldown_time <= delta_cd:
            cooldown_time = 0.0
        else:
            cooldown_time -= delta_cd
