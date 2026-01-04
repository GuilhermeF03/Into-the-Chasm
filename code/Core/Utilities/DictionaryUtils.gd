extends Node
class_name DictionaryUtils

## Lazy version of get_or_add
## - dict: Dictionary to look into
## - key: key to fetch
## - create_func: Callable to lazily create the value only if not found
static func get_or_add_lazy(dict: Dictionary, key, create_func: Callable):
	if key in dict:
		return dict[key]
	var value = create_func.call()
	dict[key] = value
	return value
