class_name StringTrait extends Trait

var default_value: Variant

func _init(name_: String, default_value_: Variant = null) -> void:
    super(name_)
    default_value = default_value_
    assert(default_value == null or typeof(default_value) == TYPE_STRING, "Default value must be string or null")

func sift(value: Variant) -> Result:
    if value == null:
        if default_value == null:
            return Result.error("Value of non-optional string is null, Name# %s" % name)
        else:
            return Result.success(default_value)

    var str_conversion: Result = Converters.variant_to_string(value)
    if !str_conversion.is_success():
        return Result.error(str_conversion.get_error_reason())
    var str_value: String = str_conversion.get_value()
    return Result.success(str_value)
