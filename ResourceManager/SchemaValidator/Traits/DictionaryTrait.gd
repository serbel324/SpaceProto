class_name DictionaryTrait extends Trait

var traits: Dictionary

func _init(name_: String, traits_: Dictionary) -> void:
    super(name_)
    traits = traits_

func sift(value: Variant) -> Result:
    if value == null:
        return Result.success({})

    if typeof(value) != TYPE_DICTIONARY:
        return Result.error("Malformed input for dictionary, Name# %s" % name)

    var result: Dictionary = {}

    for key in value.keys():
        if !traits.has(key):
            return Result.error("Unknown key in dictionary, Name# %s Key# %s Traits# %s Value# %s" % [name, key, traits.keys(), value])

    for key in traits.keys():
        var item_result: Result = traits[key].sift(value.get(key, null))
        if item_result.status == Result.Status.ERROR:
            return Result.error("Item of dictionary is invalid, Name# %s Key# %s ErrorReason# { %s }" % [name, key, item_result.get_error_reason()])
        result[key] = item_result.get_value()

    return Result.success(result)
