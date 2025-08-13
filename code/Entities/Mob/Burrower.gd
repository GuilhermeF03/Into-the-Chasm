#extends Enemy
#
#func attack(attack_vector : Vector2):
	#super.attack(attack_vector)
		#
	#var dir_to_player = global_position.direction_to(
		##attack_waypoint
	#)
	#
	#var angle = Vector2.RIGHT.dot(dir_to_player)
	#global_rotation = angle
	#
	##sprite.texture.y =
#
#
#func chase(target_vector : Vector2):
	#super.chase(target_vector)
	#
	#var dir_to_player = global_position.direction_to(
		#attack_waypoint
	#)
	#
	#
	#var angle = Vector2.RIGHT.dot(dir_to_player)
	#print("[%s]angle: %s" % [name, angle])
	#global_rotation = angle
#
#
#func update_facing():
	#pass
	##sprite.scale.x = -1 if velocity.x < 0 else 1
	#sprite.scale.y = -1 if velocity.x < 0 else 1
#
#
#func burrow():
	#sprite.visible = false
	#hurtbox.process_mode = Node.PROCESS_MODE_DISABLED
	#
	#
#func unburrow():
	#sprite.visible = true
	#hurtbox.process_mode = Node.PROCESS_MODE_INHERIT
	#
	#
