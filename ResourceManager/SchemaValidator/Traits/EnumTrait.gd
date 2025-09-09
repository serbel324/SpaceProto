class_name EnumTrait extends Trait

var enum_values: Array[String]
var default_value: Variant

func _init(name_: String, default_value_: Variant, enum_values_: Array[String]) -> void:
    super(name_)
    enum_values = enum_values_
    default_value = default_value_
    assert(default_value == null or typeof(default_value) == TYPE_STRING and enum_values.has(default_value),
            "Default value must be a string in enum values or null")


func sift(value: Variant) -> Result:
    if value == null:
        if default_value == null:
            return Result.error("Value of non-optional enum is null, Name# %s" % name)
        else:
            return Result.success(default_value)

    var str_conversion: Result = Converters.variant_to_string(value)
    if !str_conversion.is_success():
        return Result.error(str_conversion.get_error_reason())
    var str_value: String = str_conversion.get_value()
    
    if !enum_values.has(str_value):
        return Result.error("Value is not in enum values, Name# %s Value# %s" % [name, str_value])

    return Result.success(str_value)
