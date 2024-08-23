extends TextureProgressBar

var HP
var HP_MAX

func _ready():
	HP = $"../../../..".Total_Health
	HP_MAX = HP
	self.max_value = HP_MAX # drop value
	$Top_HP.max_value = HP_MAX # real value

func _process(_delta):
	HP = $"../../..".ENEMY_HEALTH
	$Top_HP.value = HP
	self.value = $"../../..".ENEMY_HEALTH_DROP
