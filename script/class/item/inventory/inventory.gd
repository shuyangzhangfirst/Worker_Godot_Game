extends Resource
class_name Inventory

## 物品槽数据集
@export var item_slot_datas: Array[ItemSlotData] = []

## 是否有空的槽位
func has_empty_slot() -> bool:
	for data in item_slot_datas:
		if data.slot_item == null:
			return true
	return false
func add_pickedup_item(pickup:DropItem):
	var _item_slot_data: ItemSlotData = ItemSlotData.new()
	_item_slot_data.item_count=pickup.quantity
	_item_slot_data.slot_item = pickup.item
	append_item_to_inventory(_item_slot_data)
## 根据物品id返回物品栏中对应物品的总数
func get_item_count_by_id(_item_id: int) -> int:
	var count: int = 0
	for data in item_slot_datas:
		if data.slot_item == null:
			continue
		if data.slot_item.item_id == _item_id:
			count += data.item_count
	return count

## 根据物品id检查是否有相同物品可以进行堆叠
func has_same_item_able_stack_by_id(_item_id: int) -> bool:
	for data in item_slot_datas:
		if data != null and data.slot_item != null and data.slot_item.item_id == _item_id:
			if data.item_count < data.slot_item.max_stack:
				return true
	return false

## 将物品加入物品栏
func append_item_to_inventory(_item_slot_data: ItemSlotData) -> void:
	if _item_slot_data.item_count == null or _item_slot_data.item_count == 0:
		push_error("添加物品失败：无效的物品数据")

	if _item_slot_data.item_count > _item_slot_data.slot_item.max_stack:
		push_error("将物品加入物品栏时,该物品超过最大堆叠")

	var remaining_count: int = _item_slot_data.item_count
	## 有未堆叠满的相同物品
	if has_same_item_able_stack_by_id(_item_slot_data.slot_item.item_id):
		# 遍历数组
		for data in item_slot_datas:
			# 跳过空槽位和不相同物品
			if data.slot_item == null or data.slot_item.item_id != _item_slot_data.slot_item.item_id:
				continue
			# 相同物品处理
			if data.slot_item.item_id == _item_slot_data.slot_item.item_id:
				# 相同物品槽位满时通过
				if data.item_count >= data.slot_item.max_stack:
					continue
				# 相同物品槽位未满时补充到该槽位
				else:
					var available_space: int = data.slot_item.max_stack - data.item_count
					var to_add: int = min(available_space, remaining_count)
					data.item_count += to_add
					remaining_count -= to_add

	## 堆叠后还有剩余物品
	if remaining_count > 0:
		# 加入到空槽位中
		if has_empty_slot():
			for data in item_slot_datas:
				if data.slot_item == null:
					data.slot_item = _item_slot_data.slot_item
					data.item_count = remaining_count
					break
		# 没有空槽位时
		else:
			pass

## 获取空槽位数量
func get_empty_slot_count() -> int:
	var count = 0
	for data in item_slot_datas:
		if data == null or data.slot_item == null:
			count += 1
	return count
