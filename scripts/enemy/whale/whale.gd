extends EnemyTemplate
class_name Whale

func _ready() -> void:
	randomize()
	
	drop_list = {
		# Path, rng to Drop, Item Type, Item Value, Item Coin Value
		
		"Heal Potion": [
			"res://assets/item/consumable/health_potion.png",
			20,
			"Health",
			5,
			2
		],
		
		"Mana Potion": [
			"res://assets/item/consumable/mana_potion.png",
			15,
			"Mana",
			5,
			5
		],
		
		"Whale Mouth": [
			"res://assets/item/resource/whale/whale_mouth.png",
			45,
			"Resource",
			{},
			2
		],
		
		"Whale Eye": [
			"res://assets/item/resource/whale/whale_eye.png",
			15,
			"Resource",
			{},
			6
		],
		
		"Whale Tail": [
			"res://assets/item/resource/whale/whale_tail.png",
			3,
			"Resource",
			{},
			25
		],
		
		"Whale Mask": [
			"res://assets/item/equipment/whale_mask.png",
			3,
			"Equipment",
			{
				"Mana": 5,
				"Magic Attack": 3
			},
			30
		]
	}
