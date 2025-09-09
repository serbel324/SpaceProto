class_name SchemaValidator

func _init() -> void:
	assert(false, "SchemaValidator is purely static class")

static func construct_validated(data: Variant, schema: Variant) -> Result:
	var traits_result: Result = TraitBuilder.build_trait("Root", null, schema)
	if !traits_result.is_success():
		return Result.error("Failed to build traits, ErrorReason# { %s }" % traits_result.get_error_reason())

	var traits: Trait = traits_result.get_value()
	var result: Result = traits.sift(data)
	if !result.is_success():
		return Result.error("Failed to sift traits, ErrorReason# { %s }" % result.get_error_reason())

	return Result.success(result.get_value())
