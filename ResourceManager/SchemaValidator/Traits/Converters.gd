class_name Converters

func _init() -> void:
    assert(false, "Converters is purely static class")

static var EPSILON: float = 1e-9

static func variant_to_boolean(value: Variant) -> Result:
    match typeof(value):
        TYPE_STRING:
            match value.to_lower():
                "true", "t", "y", "yes", "1":
                    return Result.success(true)
                "false", "f", "n", "no", "0":
                    return Result.success(false)
                _:
                    return Result.error("Bad string to boolean conversion %s" % value)
        TYPE_INT:
            match value:
                0:
                    return Result.success(false)
                1:
                    return Result.success(true)
                _:
                    return Result.error("Bad integer to boolean conversion %i" % value)
        TYPE_BOOL:
            return Result.success(value)
        _:
            return Result.error("Unable to convert variant to boolean, Type# %s" % typeof(value))


static func variant_to_int(value: Variant) -> Result:
    match typeof(value):
        TYPE_INT:
            return Result.success(value)
        TYPE_FLOAT:
            var float_value: float = value
            var closest_int: int = round(float_value)
            if abs(float_value - closest_int) > EPSILON:
                return Result.error("Unable to convert float to integer, Value# %f" % float_value)
            return Result.success(closest_int)
        TYPE_STRING:
            var str_value: String = value
            if !str_value.is_valid_int():
                return Result.error("Unable to parse integer from string, Value# %s" % value)
            return Result.success(str_value.to_int())
        _:
            return Result.error("Unable to convert variant to integer, Type# %s" % typeof(value))


static func variant_to_float(value: Variant) -> Result:
    match typeof(value):
        TYPE_FLOAT, TYPE_INT:
            return Result.success(value)
        TYPE_STRING:
            var str_value: String = value
            if !str_value.is_valid_float():
                return Result.error("Unable to parse float from string, Value# %s" % value)
            return Result.success(str_value.to_float())
        _:
            return Result.error("Unable to convert variant to float, Type# %s" % typeof(value))


static func variant_to_string(value: Variant) -> Result:
    match typeof(value):
        TYPE_STRING:
            return Result.success(value)
        _:
            return Result.error("Unable to convert variant to string, Type# %s" % typeof(value))


static func variant_to_optional_int(value: Variant) -> Result:
    if value == null:
        return Result.success(null)

    var converted: Result = Converters.variant_to_int(value)

    if !converted.is_success():
        return Result.error(converted.get_error_reason())
    return converted


static func variant_to_optional_float(value: Variant) -> Result:
    if value == null:
        return Result.success(null)

    var converted: Result = Converters.variant_to_float(value)

    if !converted.is_success():
        return Result.error(converted.get_error_reason())
    return converted


static func variant_to_optional_string(value: Variant) -> Result:
    if value == null:
        return Result.success(null)

    var converted: Result = Converters.variant_to_string(value)

    if !converted.is_success():
        return Result.error(converted.get_error_reason())
    return converted


static func variant_to_optional_boolean(value: Variant) -> Result:
    if value == null:
        return Result.success(null)

    var converted: Result = Converters.variant_to_boolean(value)

    if !converted.is_success():
        return Result.error(converted.get_error_reason())
    return converted