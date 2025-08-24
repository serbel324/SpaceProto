class_name StringTrait extends Trait

var default_value: Variant

func _init(name_: String, default_value_: Variant = null) -> void:
    super(name_)
    default_value = default_value_
    assert(default_value == null or typeof(default_value) == TYPE_STRING, "Default value must be string or null")

func sift(value: Variant) -> Result:
    if value == null:
        if default_value == null:
            return Result.new(Result.Status.ERROR, null, "Value of non-optional string is null, #Name" % name)
        else:
            return Result.new(Result.Status.SUCCESS, default_value)

    if typeof(value) != TYPE_STRING:
        return Result.new(Result.Status.ERROR, null, "Malformed input for string, Name# %s" % name)

    var str_value: String = value
    return Result.new(Result.Status.SUCCESS, str_value)
