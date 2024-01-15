extends VehicleBody3D

class_name PlayerVehicle

var input: InputProfile = InputProfile.new()
var reset_timer: float = 0.0
var mph: float:
	get:
		var rpm: float = ($rear_left.get_rpm() + $rear_right.get_rpm()) / 2
		return 2 * PI * $rear_left.wheel_radius * rpm * 60 * 3.28084 / 5280
		
@export var max_rpm = 400
@export var max_torque = 1000
@export var max_tire_angle = 0.6

func _physics_process(delta):
	steering = lerp(steering, input.get_steering() * (-max_tire_angle), 1.5*delta)
	var acceleration: float = input.get_forward() - input.get_brake()
	
	_set_wheel_force($rear_left, acceleration)
	_set_wheel_force($rear_right, acceleration)

func _set_wheel_force(wheel: VehicleWheel3D, acceleration: float):
	var rpm: float = wheel.get_rpm()
	var damper: float = (1-(abs(rpm)/max_rpm)) * (1-(abs(steering)/max_tire_angle))
	wheel.engine_force = acceleration * max_torque * damper

func _process(delta):
	var rel_up: Vector3 = transform.basis.y
	if rel_up.angle_to(Vector3.UP) >= PI/2:
		reset_timer += delta
		if reset_timer > 2.0:
			pass
	else:
		reset_timer = 0.0

func set_upright():
	var last_position: Vector3 = position
	var forward: Vector3 = transform.basis.z
	forward.y=0
	if forward.is_zero_approx():
		forward = Vector3.FORWARD

	transform = Transform3D(
			forward.rotated(Vector3.UP, PI/2),
			Vector3.UP,
			forward.normalized(), 
			last_position)
