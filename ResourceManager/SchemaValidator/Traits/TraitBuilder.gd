class_name TraitBuilder

func _init() -> void:
	assert(false, "TraitBuilder is purely static class")


static func build_integer_trait(name: String, data: Dictionary) -> Result:
	var min_result: Result = Converters.variant_to_optional_int(data.get("Min", null))
	if !min_result.is_success():
		return Result.error("Bad %s.Min value, ErrorReason# { %s }" % [name, min_result.get_error_reason()])
	var min_value: Variant = min_result.get_value()

	var max_result: Result = Converters.variant_to_optional_int(data.get("Max", null))
	if !max_result.is_success():
		return Result.error("Bad %s.Max value, ErrorReason# { %s }" % [name, max_result.get_error_reason()])
	var max_value: Variant = max_result.get_value()

	var default_result: Result = Converters.variant_to_optional_int(data.get("Default", null))
	if !default_result.is_success():
		return Result.error("Bad %s.Default value, ErrorReason# { %s }" % [name, default_result.get_error_reason()])
	var default_value: Variant = default_result.get_value()
	return Result.success(IntegerTrait.new(name, default_value, min_value, max_value))


static func build_float_trait(name: String, data: Dictionary) -> Result:
	var min_result: Result = Converters.variant_to_optional_float(data.get("Min", null))
	if !min_result.is_success():
		return Result.error("Bad %s.Min value, ErrorReason# { %s }" % [name, min_result.get_error_reason()])
	var min_value: Variant = min_result.get_value()

	var max_result: Result = Converters.variant_to_optional_float(data.get("Max", null))
	if !max_result.is_success():
		return Result.error("Bad %s.Max value, ErrorReason# { %s }" % [name, max_result.get_error_reason()])
	var max_value: Variant = max_result.get_value()

	var default_result: Result = Converters.variant_to_optional_float(data.get("Default", null))
	if !default_result.is_success():
		return Result.error("Bad %s.Default value, ErrorReason# { %s }" % [name, default_result.get_error_reason()])
	var default_value: Variant = default_result.get_value()
	return Result.success(FloatTrait.new(name, default_value, min_value, max_value))


static func build_string_trait(name: String, data: Dictionary) -> Result:
	var default_result: Result = Converters.variant_to_optional_string(data.get("Default", null))
	if !default_result.is_success():
		return Result.error("Bad %s.Default value, ErrorReason# { %s }" % [name, default_result.get_error_reason()])
	var default_value: Variant = default_result.get_value()

	return Result.success(StringTrait.new(name, default_value))


static func build_list_trait(name: String, data: Dictionary) -> Result:
	if !data.has("Item"):
		return Result.error("Unspecified Item type for list trait, Name# %s" % name)

	var item_data: Variant = data["Item"]
	if typeof(item_data) != TYPE_DICTIONARY:
		return Result.error("Malformed Item type for list trait, Name# %s" % name)

	var item_result: Result = build_trait(name, name + ".<item>", item_data)
	if !item_result.is_success():
		return Result.error("Bad itemItem type for list trait, Name# %s, ErrorReason# { %s }" % [name, item_result.get_error_reason()])

	return Result.success(ListTrait.new(name, item_result.get_value()))


static func build_dictionary_trait(name: String, data: Dictionary) -> Result:
	if !data.has("Items"):
		return Result.error("No Items specified for dictionary trait, Name# %s" % name)

	var items_data: Variant = data["Items"]
	if typeof(items_data) != TYPE_ARRAY:
		return Result.error("Malformed Items type for dictionary trait, Name# %s" % name)

	var traits: Dictionary = {} 

	for item_data in items_data:
		if typeof(item_data) != TYPE_DICTIONARY:
			return Result.error("Malformed item type for dictionary trait, Name# %s" % name)

		if !item_data.has("Key"):
			return Result.error("Dictionary trait item must have Key, Name# %s Data# { %s }" % [name, item_data])
		var key_data: Variant = item_data["Key"]
		if typeof(key_data) != TYPE_STRING:
			return Result.error("Dictionary trait item's Key must be a string, Name# %s Type# %s" % [name, typeof(key_data)])
		var key_str: String = str(key_data)

		var value_data: Variant = item_data["Value"]
		var value_result: Result = build_trait(name, name + "." + key_str, value_data)
		if !value_result.is_success():
			return Result.error("Bad Value for dictionary trait, Name# %s, ErrorReason# { %s }" % [name, value_result.get_error_reason()])

		traits[key_str] = value_result.get_value()

	return Result.success(DictionaryTrait.new(name, traits))


static func build_boolean_trait(name: String, data: Dictionary) -> Result:
	var default_result: Result = Converters.variant_to_optional_boolean(data.get("Default", null))
	if !default_result.is_success():
		return Result.error("Bad %s.Default value, ErrorReason# { %s }" % [name, default_result.get_error_reason()])
	var default_value: Variant = default_result.get_value()
	return Result.success(BooleanTrait.new(name, default_value))


static func build_enum_trait(name: String, data: Dictionary) -> Result:
	if !data.has("Values"):
		return Result.error("No Values specified for enum trait, Name# %s" % name)

	var values_data: Variant = data["Values"]
	if typeof(values_data) != TYPE_ARRAY:
		return Result.error("Bad Values type for enum trait, Name# %s Type# %s" % [name, typeof(values_data)])
	
	var default_result: Result = Converters.variant_to_optional_string(data.get("Default", null))
	if !default_result.is_success():
		return Result.error("Bad %s.Default value, ErrorReason# { %s }" % [name, default_result.get_error_reason()])
	var default_value: Variant = default_result.get_value()

	if typeof(default_value) == TYPE_STRING:
		if !values_data.has(default_value):
			return Result.error("Default value for enum trait is not in Values, Name# %s Default# %s" % [name, default_value])

	return Result.success(EnumTrait.new(name, default_value, values_data))


static func build_trait(parent_name: String, name: Variant, data: Variant) -> Result:
	if typeof(data) != TYPE_DICTIONARY:
		return Result.error("Malformed trait data, ParentName# %s" % parent_name)

	if name == null:
		if !data.has("Name"):
			name = "<unnamed>"
		else:
			var name_result: Result = Converters.variant_to_string(data["Name"])
			if !name_result.is_success():
				return Result.error("Bad Name for trait, ParentName# %s, ErrorReason# { %s }" % [parent_name, name_result.get_error_reason()])
			name = name_result.get_value()

	if !data.has("Type"):
		return Result.error("Trait Type is required, ParentName# %s" % parent_name)

	var type_result: Result = Converters.variant_to_string(data.get("Type", null))
	if !type_result.is_success():
		return Result.error("Bad Type for trait, ParentName# %s, ErrorReason# { %s }" % [parent_name, type_result.get_error_reason()])
	var type_name: String = type_result.get_value()
	var type: Trait.Type = Trait.get_type(type_name)

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
		Trait.Type.BOOLEAN:
			return build_boolean_trait(name, data)
		Trait.Type.ENUM:
			return build_enum_trait(name, data)
		_:
			return Result.error("Unknown trait type, ParentName# %s" % parent_name)
