extends StaticBody2D

var resource := {}
@export var type: String = "Ore"
@export var amount: int = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	resource = {
		"type" : type,
		"amount" : amount
	}


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
