extends Resource
class_name Item

@export_category("物品属性")
@export var item_id: int = -1										## 物品id
@export var item_name: String = ""									## 物品名称
@export var item_icon: Texture2D = preload("uid://obhgnhthjh6r")	## 物品图标
@export var max_stack: Stack = Stack.SMALL							## 最大堆叠量
@export_multiline() var description: String = "" 	 				## 物品描述
@export var item_type: ItemType = ItemType.MATERIALS	## 物品种类
#@export var rarity: Rarity = Rarity.COMMON				## 物品稀有度

@export_category("价格属性")
@export var buy_price: int = 1		## 购买参考价格
@export var sell_price: int = 1		## 出售参考价格

## 物品种类
enum ItemType {
	MATERIALS,		## 材料
	CONSUMABLE,		## 消耗品
	KEY_ITEM,		## 关键物品
	QUEST_ITEM,		## 任务物品
}

## 稀有度枚举
#enum Rarity {
	#COMMON,			## 普通
	#UNCOMMON,		## 稀有
	#RARE,			## 精良
	#EPIC,			## 史诗
	#LEGENDARY,		## 传说
#}

enum Stack {
	SMALL = 99,		## 99个
	MEDIUM = 20,	## 20个
	SINGLE = 1,		## 1个
}
