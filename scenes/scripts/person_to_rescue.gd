extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func rescued(boat, seat):
	# Notify parent the person has been rescued
	get_parent().person_rescued(self)
	# Change Parent and get in Boat
	boat.add_child(self)
	position = seat[0]
	rotation_degrees = seat[1]
	z_index = 0
	scale = Vector2(0.6, 0.6)
	# Remove collision
	self.get_child(1).queue_free()
	
	

