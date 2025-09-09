class_name BooleanTrait extends Trait

var default_value: Variant

func _init(name_: String, default_value_: Variant = null) -> void:
    super(name_)
    default_value = default_value_
    assert(default_value == null or typeof(default_value) == TYPE_BOOL, "Default value must be boolean or null")

func sift(value: Variant) -> Result:
    if value == null:
        if default_value == null:
            return Result.error("Value of non-optional boolean is null, Name# %s" % name)
        else:
            return Result.success(default_value)

    var boolean_conversion: Result = Converters.variant_to_boolean(value)
    if !boolean_conversion.is_success():
        return Result.error(boolean_conversion.get_error_reason())
    var boolean_value: bool = boolean_conversion.get_value()

    return Result.success(boolean_value)

