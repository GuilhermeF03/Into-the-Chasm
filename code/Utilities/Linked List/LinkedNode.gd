# LinkedListNode.gd
class_name LinkedNode

var value
var next: LinkedNode = null
var prev: LinkedNode = null

func _init(val):
	value = val
