class_name Result

enum Status {
    SUCCESS,
    ERROR,
}

var value: Variant
var status: Status
var error_reason: String

func _init(status_: Status, value_: Variant = null, error_reason_: String = "") -> void:
    status = status_
    match status:
        Status.SUCCESS:
            value = value_
        Status.ERROR:
            error_reason = error_reason_

func is_success() -> bool:
    return status == Status.SUCCESS

func get_value() -> Variant:
    assert(status == Status.SUCCESS, "Attempted to get value from a failed result")
    return value

func get_error_reason() -> String:
    assert(status == Status.ERROR, "Attempted to get error reason from a successful result")
    return error_reason
