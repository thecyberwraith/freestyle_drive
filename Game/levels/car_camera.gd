extends Camera3D

class_name CarCamera

var car: PlayerVehicle = null

const speed_for_max: float = 150
const max_dist:float = 30
const min_dist:float = 3
const min_ratio:float = 1
const max_ratio:float = 2

func _process(_delta):
	if car == null:
		return

	var forward: Vector3 = car.transform.basis.z

	forward.y = 0.0
	
	if forward.length_squared() == 0.0:
		return
	
	forward = forward.normalized()
	
	var speed_ratio: float = clampf(car.linear_velocity.length(), 0, speed_for_max) / speed_for_max
	var view_ratio: float = lerp(min_ratio, max_ratio, speed_ratio)
	var distance: float = lerp(min_dist, max_dist, speed_ratio)
	
	var look_at_point: Vector3 = car.position + forward*distance
	var look_from_point: Vector3 = car.position - forward*distance + Vector3.UP*distance*view_ratio
	
	look_at_from_position(look_from_point, look_at_point)
