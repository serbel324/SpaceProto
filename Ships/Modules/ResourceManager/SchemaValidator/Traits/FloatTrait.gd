class_name FloatTrait extends Trait

var min_value: Variant
var max_value: Variant
var default_value: Variant

var epsilon: float = 1e-9

func _init(name_: String, default_value_: Variant = null, min_value_: Variant = null, max_value_: Variant = null) -> void:
    super(name_)
    default_value = default_value_
    min_value = min_value_
    max_value = max_value_
    assert(default_value == null or typeof(default_value) == TYPE_FLOAT, "Default value must be a float or null")
    assert(min_value == null or typeof(min_value) == TYPE_FLOAT, "Minimum value must be a float or null")
    assert(max_value == null or typeof(max_value) == TYPE_FLOAT, "Maximum value must be a float or null")

func sift(value: Variant) -> Result:
    if value == null:
        if default_value == null:
            return Result.new(Result.Status.ERROR, null, "Value of non-optional float is null, #Name" % name)
        else:
            return Result.new(Result.Status.SUCCESS, default_value)

    var float_value: float

    match typeof(value):
        TYPE_INT, TYPE_FLOAT:
            float_value = value
        TYPE_STRING:
            var str_value: String = value
            if !str_value.is_valid_float():
                return Result.new(Result.Status.ERROR, null, "Unable to parse float, Name# %s" % name)
            float_value = str_value.to_float()
        _:
            return Result.new(Result.Status.ERROR, null, "Malformed input for float, Name# %s" % name)

    if min_value != null and float_value < float(min_value) - epsilon:
        return Result.new(Result.Status.ERROR, null, "Float range violation, Name# %s, Value# %s, Minimum# %s" % [name, float_value, min_value])

    if max_value != null and float_value > float(max_value) + epsilon:
        return Result.new(Result.Status.ERROR, null, "Float range violation, Name# %s, Value# %s, Maximum# %s" % [name, float_value, max_value])

    return Result.new(Result.Status.SUCCESS, float_value)
