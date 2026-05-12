extends Resource
class_name Item

@export_category("物品属性")
@export var item_id: int = -1							## 物品id
@export var item_name: String = ""						## 物品名称
@export var item_icon: Texture2D						## 物品图标
@export var max_stack: int = 1							## 最大堆叠量
@export var item_type: ItemType = ItemType.MATERIALS	## 物品种类
@export_multiline() var description: String = "" 	 	## 物品描述

@export_category("价格属性")
@export var buy_price: int = 1		## 购买参考价格
@export var sell_price: int = 1		## 出售参考价格

## 物品种类
enum ItemType {
	MATERIALS,     # 材料
	CONSUMABLE,    # 消耗品
	EQUIPMENT,     # 装备
	WEAPON,       # 武器
	ARMOR,        # 防具
	KEY_ITEM,     # 关键物品
	QUEST_ITEM,   # 任务物品
}
