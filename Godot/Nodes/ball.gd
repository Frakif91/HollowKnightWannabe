extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	self.body_entered.connect(_on_body_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if is_instance_of(body,Col_Hit):
		apply_force(body)