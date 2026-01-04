# LinkedList.gd
class_name LinkedList

var head: LinkedNode = null
var tail: LinkedNode = null
var size: int = 0

func append(value):
	var node = LinkedNode.new(value)
	if not head:
		head = node
		tail = node
	else:
		tail.next = node
		node.prev = tail
		tail = node
	size += 1

func prepend(value):
	var node = LinkedNode.new(value)
	if not head:
		head = node
		tail = node
	else:
		node.next = head
		head.prev = node
		head = node
	size += 1

func remove(node: LinkedNode):
	if node == null: return
	if node.prev:
		node.prev.next = node.next
	else:
		head = node.next
	
	if node.next:
		node.next.prev = node.prev
	else:
		tail = node.prev
	
	size -= 1

func find(value) -> LinkedNode:
	var current = head
	while current:
		if current.value == value:
			return current
		current = current.next
	return null
	
func find_custom(predicate: Callable) -> LinkedNode:
	var current = head
	while current:
		if predicate.call(current.value):
			return current
		current = current.next
	return null

func to_array() -> Array:
	var arr = []
	var current = head
	while current:
		arr.append(current.value)
		current = current.next
	return arr
