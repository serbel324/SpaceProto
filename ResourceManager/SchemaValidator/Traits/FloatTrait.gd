class_name FloatTrait extends Trait

var min_value: Variant
var max_value: Variant
var default_value: Variant

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
            return Result.error("Value of non-optional float is null, Name# %s" % name)
        else:
            return Result.success(default_value)

    var float_conversion: Result = Converters.variant_to_float(value)
    if !float_conversion.is_success():
        return Result.error(float_conversion.get_error_reason())
    var float_value: float = float_conversion.get_value()

    if min_value != null and float_value < float(min_value) - Converters.EPSILON:
        return Result.error("Float range violation, Name# %s, Value# %s, Minimum# %s" % [name, float_value, min_value])

    if max_value != null and float_value > float(max_value) + Converters.EPSILON:
        return Result.error("Float range violation, Name# %s, Value# %s, Maximum# %s" % [name, float_value, max_value])

    return Result.success(float_value)
