extends EnemyTemplate
class_name PinkStar

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
		
		"Pink Star Mouth": [
			"res://assets/item/resource/pink_start_mouth.png",
			47,
			"Resource",
			{},
			5
		],
		
		"Pink Star Bow": [
			"res://assets/item/equipment/pink_star_bow.png",
			1,
			"Weapon",
			{
				"Attack": 5
			},
			60
		],
		
		"Pink Star Belt": [
			"res://assets/item/equipment/pink_star_belt.png",
			3,
			"Equipment",
			{
				"Health": 5,
				"Mana": 5
			},
			60
		],
		
		"Pink Star Shield": [
			"res://assets/item/equipment/pink_star_shield.png",
			1,
			"Weapon",
			{
				"Health": 3,
				"Defense": 2
			},
			75
		]
	}
	
