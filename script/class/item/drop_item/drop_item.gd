
@tool
extends CharacterBody2D
class_name  DropItem



@export var item : Item :set = set_item #掉落的物品
@export var quantity : int : set = set_quantity #掉落的数量 y

@onready var item_icon: Sprite2D = $item_icon
@onready var quantity_label: Label = $Label
@onready var pick_area: Area2D = $pick_area
var direction:Vector2

func set_item(v:Item):
	if item_icon:
		item_icon.texture = v.item_icon
	item=v
func set_quantity(v):
	quantity = v
	if quantity_label:
		quantity_label.text = str(v)

func _ready() -> void:
	if item :
		item_icon.texture=item.item_icon
	quantity_label.text=str(quantity)
	if Engine.is_editor_hint():
		return
	pick_area.body_entered.connect(_on_body_entered)
	var direction = Vector2(randf_range(-1,1),randf_range(-1,1))
	var v = randf_range(100,500)
	velocity = v*direction
func _physics_process(delta: float) -> void:
	if velocity.length() == 0:
		return
	var collision_info = move_and_collide(velocity*delta)
	if collision_info :
		velocity=velocity.bounce(collision_info.get_normal())
	velocity -=velocity*delta*4
	if velocity.length() <= 5:
		velocity=Vector2.ZERO
func _on_body_entered(b):
	
	if not (b is Player):
		return 
	## 具体的逻辑
	GameSystem.data.current_player.inventory.add_pickedup_item(self)
	
	queue_free()
