extends Node

var modules: Dictionary

@export var module_schema: JSON = null
@export var modules_data: JSON = null

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(modules_data != null, "Modules data is not set")
	assert(module_schema != null, "Module schema is not set")
	var modules_result: Result = SchemaValidator.construct_validated(modules_data.data, module_schema.data)
	if !modules_result.is_success():
		print("Error: Failed to construct validated modules, ErrorReason# { %s }" % modules_result.get_error_reason())
		return
	modules = modules_result.get_value()
	print("LOADED MODULES: %s" % JSON.stringify(modules, "  "))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
