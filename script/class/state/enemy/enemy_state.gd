extends State
class_name EnemyState

var player:Player
var enemy:Enemy
func Init():
	player=GameSystem.data.current_player
	enemy=character
	
