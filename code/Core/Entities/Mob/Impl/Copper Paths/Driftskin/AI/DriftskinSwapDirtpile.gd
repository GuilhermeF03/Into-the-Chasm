@tool
extends BTAction


func _generate_name():
	return "Driftskin - swap dirtpile"


func _tick(_delta):
	var player = PlayerManager.player
	var dirtpiles : Array[Node] = agent.dirtpiles.filter(
		func(dirtpile): 
		return dirtpile != agent.curr_dirtpile
	)
	
	var target_pile : StaticBody2D = null
	var target_pile_player_distance : float = 0.0
	
	for dirtpile : StaticBody2D in dirtpiles:
		var player_distance = (
			dirtpile.global_position
			.distance_to(player.global_position)
		)
		if player_distance >= target_pile_player_distance:
			target_pile = dirtpile
			target_pile_player_distance = player_distance
			
	print("[Driftskin][BT] Swapping dirtpile to %s" % target_pile.name)
	agent.swap_dirtpile(target_pile)
	
	return SUCCESS
