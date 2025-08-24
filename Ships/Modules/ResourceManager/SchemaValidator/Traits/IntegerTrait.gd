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
            return Result.new(Result.Status.ERROR, null, "Value of non-optional integer is null, #Name" % name)
        else:
            return Result.new(Result.Status.SUCCESS, default_value)

    var int_value: int

    match typeof(value):
        TYPE_INT:
            int_value = value
        TYPE_STRING:
            var str_value: String = value
            if !str_value.is_valid_int():
                return Result.new(Result.Status.ERROR, null, "Unable to parse integer, Name# %s" % name)
            int_value = str_value.to_int()
        _:
            return Result.new(Result.Status.ERROR, null, "Malformed input for integer, Name# %s" % name)

    if min_value != null and int_value < int(min_value):
        return Result.new(Result.Status.ERROR, null, "Integer range violation, Name# %s, Value# %s, Minimum# %s" % [name, int_value, min_value])

    if max_value != null and int_value > int(max_value):
        return Result.new(Result.Status.ERROR, null, "Integer range violation, Name# %s, Value# %s, Maximum# %s" % [name, int_value, max_value])

    return Result.new(Result.Status.SUCCESS, int_value)
