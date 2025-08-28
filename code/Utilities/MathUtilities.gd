extends Node
class_name MathUtilities

static func mod_wrap(n: int, m: int) -> int:
	return ((n % m) + m) % m
