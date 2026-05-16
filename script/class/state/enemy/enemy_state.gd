extends State
class_name EnemyState

var player:Player
var enemy:Enemy
func Init():
	player=GameSystem.DataDataManager.current_player
	enemy=character
	
