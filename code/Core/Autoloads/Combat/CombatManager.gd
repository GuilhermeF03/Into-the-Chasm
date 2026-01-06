extends Node


func resolve_attack(
	attack : CombatHitbox,
	target : CombatHurtbox
) -> DamageData.DamageInfo:
	# 1. Roll raw damage (intent)
	
	# NO DAMAGE DATA -> RETURN EMPTY REPRESETATION
	if attack.damage_data == null:
		return DamageData.DamageInfo.new()
	
	var info := attack.damage_data.roll()

	# 2. Apply elemental resistance
	info = apply_resistance(info, target.combatant_data)

	# 3. Final clamp
	info.damage = max(0, int(info.damage))
	return info


func apply_resistance(
	info : DamageData.DamageInfo,
	combatant : CombatantData
) -> DamageData.DamageInfo:
	if info.type != DamageData.DamageType.NORMAL:
		return info
		
	if combatant == null: return info

	var resistance = combatant.element_affinities.get(
		info.element,
		ElementData.ElementResistance.NORMAL
	)

	var multiplier := ElementData.get_element_resistance_multiplier(
		resistance
	)

	info.damage = int(info.damage * multiplier)

	if multiplier < 0.0:
		info.type = DamageData.DamageType.HEAL
		info.damage = abs(info.damage)

	return info
