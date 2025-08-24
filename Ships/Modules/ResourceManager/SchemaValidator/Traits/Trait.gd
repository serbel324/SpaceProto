class_name Trait

enum Type {
    INTEGER,
    FLOAT,
    STRING,
    LIST,
    DICTIONARY,
    MALFORMED,
    # TODO: unsigned types (?), boolean, enum
}

var name: String

func _init(name_: String) -> void:
    name = name_

func sift(_value: Variant) -> Result:
    assert(false, "Not implemented")
    return Result.new(Result.Status.ERROR, null, "Fatal error") # never reached

static func get_type(type_name: String) -> Type:
    match type_name.to_lower():
        "integer", "int", "int32":
            return Type.INTEGER
        "float", "float32", "real":
            return Type.FLOAT
        "string", "str":
            return Type.STRING
        "list", "array":
            return Type.LIST
        "dictionary", "dict", "map":
            return Type.DICTIONARY
        _:
            return Type.MALFORMED # unknown type