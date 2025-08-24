class_name TraitBuilder

func _init() -> void:
    assert(false, "TraitBuilder is purely static class")

static func read_optional_int(value: Variant) -> Result:
    if value == null:
        return Result.new(Result.Status.SUCCESS, null)

    var int_value: int

    match typeof(value):
        TYPE_INT:
            int_value = value
        TYPE_STRING:
            var str_value: String = value
            if !str_value.is_valid_int():
                return Result.new(Result.Status.ERROR, null, "Unable to parse integer")
            int_value = str_value.to_int()
        _:
            return Result.new(Result.Status.ERROR, null, "Malformed input for integer")

    return Result.new(Result.Status.SUCCESS, int(int_value))


static func read_optional_float(value: Variant) -> Result:
    if value == null:
        return Result.new(Result.Status.SUCCESS, null)

    var float_value: float

    match typeof(value):
        TYPE_INT, TYPE_FLOAT:
            float_value = value
        TYPE_STRING:
            var str_value: String = value
            if !str_value.is_valid_float():
                return Result.new(Result.Status.ERROR, null, "Unable to parse float")
            float_value = str_value.to_float()
        _:
            return Result.new(Result.Status.ERROR, null, "Malformed input for float")

    return Result.new(Result.Status.SUCCESS, float(float_value))


static func read_optional_string(value: Variant) -> Result:
    if value == null:
        return Result.new(Result.Status.SUCCESS, null)

    match typeof(value):
        TYPE_STRING:
            return Result.new(Result.Status.SUCCESS, value)
        _:
            return Result.new(Result.Status.ERROR, null, "Malformed input for string")


static func build_integer_trait(name: String, data: Dictionary) -> Result:
    var min_result: Result = read_optional_int(data.get("Min", null))
    if !min_result.is_success():
        return Result.new(Result.Status.ERROR, null, "Bad %s.Min value, ErrorReason# %s" % [name, min_result.get_error_reason()])
    var min_value: Variant = min_result.get_value()

    var max_result: Variant = read_optional_int(data.get("Max", null))
    if !max_result.is_success():
        return Result.new(Result.Status.ERROR, null, "Bad %s.Max value, ErrorReason# %s" % [name, max_result.get_error_reason()])
    var max_value: Variant = max_result.get_value()

    var default_result: Result = read_optional_int(data.get("Default", null))
    if !default_result.is_success():
        return Result.new(Result.Status.ERROR, null, "Bad %s.Default value, ErrorReason# %s" % [name, default_result.get_error_reason()])
    var default_value: Variant = default_result.get_value()
    return Result.new(Result.Status.SUCCESS, IntegerTrait.new(name, min_value, max_value, default_value))


static func build_float_trait(name: String, data: Dictionary) -> Result:
    var min_result: Result = read_optional_float(data.get("Min", null))
    if !min_result.is_success():
        return Result.new(Result.Status.ERROR, null, "Bad %s.Min value, ErrorReason# %s" % [name, min_result.get_error_reason()])
    var min_value: Variant = min_result.get_value()

    var max_result: Variant = read_optional_float(data.get("Max", null))
    if !max_result.is_success():
        return Result.new(Result.Status.ERROR, null, "Bad %s.Max value, ErrorReason# %s" % [name, max_result.get_error_reason()])
    var max_value: Variant = max_result.get_value()

    var default_result: Result = read_optional_float(data.get("Default", null))
    if !default_result.is_success():
        return Result.new(Result.Status.ERROR, null, "Bad %s.Default value, ErrorReason# %s" % [name, default_result.get_error_reason()])
    var default_value: Variant = default_result.get_value()
    return Result.new(Result.Status.SUCCESS, IntegerTrait.new(name, min_value, max_value, default_value))


static func build_string_trait(name: String, data: Dictionary) -> Result:
    var default_result: Result = read_optional_float(data.get("Default", null))
    if !default_result.is_success():
        return Result.new(Result.Status.ERROR, null, "Bad %s.Default value, ErrorReason# %s" % [name, default_result.get_error_reason()])
    var default_value: Variant = default_result.get_value()

    return Result.new(Result.Status.SUCCESS, StringTrait.new(name, default_value))


static func build_list_trait(name: String, data: Dictionary) -> Result:
    if !data.has("Item"):
        return Result.new(Result.Status.ERROR, null, "Unspecified Item type for list trait, Name# %s" % name)

    var item_data: Variant = data["Item"]
    if typeof(item_data) != TYPE_DICTIONARY:
        return Result.new(Result.Status.ERROR, null, "Malformed Item type for list trait, Name# %s" % name)

    var item_result: Result = build_trait(name, item_data)
    if !item_result.is_success():
        return Result.new(Result.Status.ERROR, null, "Bad itemItem type for list trait, Name# %s, ErrorReason# %s" % [name, item_result.get_error_reason()])

    return Result.new(Result.Status.SUCCESS, ListTrait.new(name, item_result.get_value()))


static func build_dictionary_trait(name: String, data: Dictionary) -> Result:
    if !data.has("Items"):
        return Result.new(Result.Status.ERROR, null, "No Items specified for dictionary trait, Name# %s" % name)

    var items_data: Variant = data["Items"]
    if typeof(items_data) != TYPE_ARRAY:
        return Result.new(Result.Status.ERROR, null, "Malformed Items type for dictionary trait, Name# %s" % name)

    var traits: Dictionary = {} 

    for item_data in items_data:
        if typeof(item_data) != TYPE_DICTIONARY:
            return Result.new(Result.Status.ERROR, null, "Malformed item type for dictionary trait, Name# %s" % name)

        if !item_data.has("Key"):
            return Result.new(Result.Status.ERROR, null, "Dictionary trait item must have Key, Name# %s" % name)
        var key_data: Variant = item_data["Key"]
        if typeof(key_data) != TYPE_STRING:
            return Result.new(Result.Status.ERROR, null, "Dictionary trait item's Key must be a string, Name# %s" % name)

        var value_data: String = item_data["Value"]
        var value_result: Result = build_trait(name, value_data)
        if !value_result.is_success():
            return Result.new(Result.Status.ERROR, null, "Bad Value for dictionary trait, Name# %s, ErrorReason# %s" % [name, value_result.get_error_reason()])

        traits[str(key_data)] = value_result.get_value()

    return Result.new(Result.Status.SUCCESS, DictionaryTrait.new(name, traits))


static func build_trait(parent_name: String, data: Variant) -> Result:
    if typeof(data) != TYPE_DICTIONARY:
        return Result.new(Result.Status.ERROR, null, "Malformed trait data, ParentName# %s" % parent_name)

    if !data.has("name"):
        return Result.new(Result.Status.ERROR, null, "Unnamed trait, ParentName# %s" % parent_name)

    var name: String = data["name"]
    if typeof(name) != TYPE_STRING:
        return Result.new(Result.Status.ERROR, null, "Trait name must be a string, ParentName# %s" % parent_name)

    if !data.has("type"):
        return Result.new(Result.Status.ERROR, null, "Trait type is required, ParentName# %s" % parent_name)

    var type_value: String = data["type"]
    if typeof(type_value) != TYPE_STRING:
        return Result.new(Result.Status.ERROR, null, "Trait type must be a string, ParentName# %s" % parent_name)
    var type: Trait.Type = Trait.get_type(type_value)

    match type:
        Trait.Type.INTEGER:
            return build_integer_trait(name, data)
        Trait.Type.FLOAT:
            return build_float_trait(name, data)
        Trait.Type.STRING:
            return build_string_trait(name, data)
        Trait.Type.LIST:
            return build_list_trait(name, data)
        Trait.Type.DICTIONARY:
            return build_dictionary_trait(name, data)
        _:
            return Result.new(Result.Status.ERROR, null, "Unknown trait type, ParentName# %s" % parent_name)
