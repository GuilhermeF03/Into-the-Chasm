extends Resource
class_name BooleanCallable

var fn: Callable

func bool_call(...args) -> bool:
	return fn.call(args)
