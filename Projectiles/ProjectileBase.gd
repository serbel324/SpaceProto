class_name ProjectileBase
extends Area2D

var linear_velocity: Vector2 = Vector2.ZERO

@export var ttl_sec: float = 0.0
@export var damage_amount: int = 0

var ttl_time: float
var team: Team.E

func initialize(team_id: Team.E, start_position: Vector2, start_rotation: float, velocity: Vector2) -> void:
    team = team_id
    linear_velocity = velocity
    global_position = start_position
    global_rotation = start_rotation
    ttl_time = ttl_sec

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    body_entered.connect(_on_body_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    global_position += linear_velocity * delta

    if ttl_time > delta:
        ttl_time -= delta
    else:
        queue_free()

func _on_body_entered(body: Node2D) -> void:
    # TODO: check if the area is a damageble object and apply damage
    if body is Entity:
        body.deal_damage(team, damage_amount)
    queue_free()
