class_name IntegerTrait extends Trait

var min_value: Variant
var max_value: Variant
var default_value: Variant

func _init(name_: String, default_value_: Variant = null, min_value_: Variant = null, max_value_: Variant = null) -> void:
    super(name_)
    default_value = default_value_
    min_value = min_value_
    max_value = max_value_
    assert(default_value == null or typeof(default_value) == TYPE_INT, "Default value must be an integer or null")
    assert(min_value == null or typeof(min_value) == TYPE_INT, "Minimum value must be an integer or null")
    assert(max_value == null or typeof(max_value) == TYPE_INT, "Maximum value must be an integer or null")

func sift(value: Variant) -> Result:
    if value == null:
        if default_value == null:
            return Result.error("Value of non-optional integer is null, Name# %s" % name)
        else:
            return Result.success(default_value)

    var int_conversion: Result = Converters.variant_to_int(value)
    if !int_conversion.is_success():
        return Result.error(int_conversion.get_error_reason())
    var int_value: int = int_conversion.get_value()

    if min_value != null and int_value < int(min_value):
        return Result.error("Integer range violation, Name# %s, Value# %s, Minimum# %s" % [name, int_value, min_value])

    if max_value != null and int_value > int(max_value):
        return Result.error("Integer range violation, Name# %s, Value# %s, Maximum# %s" % [name, int_value, max_value])

    return Result.success(int_value)
