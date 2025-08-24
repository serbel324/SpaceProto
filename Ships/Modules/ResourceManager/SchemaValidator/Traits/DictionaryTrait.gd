class_name DictionaryTrait extends Trait

var traits: Dictionary

func _init(name_: String, traits_: Dictionary) -> void:
    super(name_)
    traits = traits_

func sift(value: Variant) -> Result:
    if value == null:
        return Result.new(Result.Status.SUCCESS, [])

    if typeof(value) != TYPE_DICTIONARY:
        return Result.new(Result.Status.ERROR, null, "Malformed input for dictionary, Name# %s" % name)

    var result: Dictionary = {}

    for key in value.keys():
        if !traits.has(key):
            return Result.new(Result.Status.ERROR, null, "Unknown key in dictionary, Name# %s Key# %s" % [name, key])
        var item_result: Result = traits[key].sift(value[key])
        if item_result.status == Result.Status.ERROR:
            return Result.new(Result.Status.ERROR, null,
                    "Item of dictionary is invalid, Name# %s Key# %s ErrorReason# { %s }" % [name, key, item_result.get_error_reason()])
        result[key] = item_result.get_value()

    return Result.new(Result.Status.SUCCESS, result)
