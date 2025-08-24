class_name ListTrait extends Trait

var item_trait: Trait

func _init(name_: String, item_trait_: Trait) -> void:
    super(name_)
    item_trait = item_trait_

func sift(value: Variant) -> Result:
    if value == null:
        return Result.new(Result.Status.SUCCESS, [])

    if typeof(value) != TYPE_ARRAY:
        return Result.new(Result.Status.ERROR, null, "Malformed input for array, Name# %s" % name)

    var result: Array = []
    for idx in range(value.size()): # doing this kolhoz stuff since gdscript doesn't have enumerate()
        var item_result: Result = item_trait.sift(value[idx])
        if item_result.status == Result.Status.ERROR:
            return Result.new(Result.Status.ERROR, null,
                    "Item of array is invalid, Name# %s Index# %s ErrorReason# { %s }" % [name, idx, item_result.get_error_reason()])
        result.append(item_result.get_value())

    return Result.new(Result.Status.SUCCESS, result)
