extends Node
class_name BulletPool


#region Nodes
@export_group("Nodes")
@export var bullet_scene: PackedScene
var enemy : Enemy ## Reference to the enemy that owns this pool
#endregion

#region Data
@export_group("Data")
var bullet_attack_speed := 100.0 ## Will be filled by the enemy

var pool : Dictionary[Bullet, bool] = {}
#endregion

#region helpers
#region Signal Handlers
func reset_bullet(bullet: Bullet):
	bullet.reset()

	bullet.sprite.visible = false

	bullet.call_deferred("set_process_mode", PROCESS_MODE_DISABLED)
	bullet.set_deferred("global_position", enemy.global_position)

	pool[bullet] = false  # mark as reusable
#endregion

#region Aux
func get_next_free_bullet() -> Bullet:
	for bullet in pool.keys():
		if not pool[bullet]:
			return bullet

	await instance_new_bullet()

	# Try again after creating
	for bullet in pool.keys():
		if not pool[bullet]:
			return bullet

	push_error("[Driftskin] No arrow available after instancing")
	return null


func instance_new_bullet():
	## Instantiate and append bullet on Level's bullet pool
	var instanced_bullet: Bullet = bullet_scene.instantiate()
	LevelManager.call_deferred(
		"spawn_bullet", 
		instanced_bullet, 
		enemy.global_position
	)

	await instanced_bullet.ready
	## Add it to the arrow pool
	pool[instanced_bullet] = false
	## Configure info and initial state
	instanced_bullet.sprite.set_deferred("scale", Vector2.ONE * 5)
	instanced_bullet.MOVEMENT_SPEED = bullet_attack_speed
	instanced_bullet.on_destruction.connect(reset_bullet)
	call_deferred("reset_bullet", instanced_bullet)


func clean_pool():
	for bullet in pool.keys():
		# Disconnect the destruction signal to avoid memory leaks
		bullet.on_destruction.disconnect(reset_bullet) 
		# If the bullet is not in use, free it
		if not pool[bullet]:
			bullet.queue_free()
			pool.erase(bullet)
		else:
		   	# If the bullet is in use, queue it on next "on_destruction" signal
			bullet.on_destruction.connect(func(_bullet):
				bullet.queue_free()
				pool.erase(bullet)
			)
#endregion
