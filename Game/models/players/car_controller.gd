extends VehicleBody3D

class_name PlayerVehicle

@onready var interactor: Interactor = $Interactor

const MAX_FLIPPED_TIME_TILL_RIGHTED = 2.0
var reset_timer: float = 0.0
var mph: float:
	get:
		var rpm: float = ($rear_left.get_rpm() + $rear_right.get_rpm()) / 2
		return 2 * PI * $rear_left.wheel_radius * rpm * 60 * 3.28084 / 5280
		
@export_range(10,200) var max_mph: float = 50
@export_range(0,1) var max_damper_for_turning: float = 0.9
@export_range(500, 10000) var max_torque: float = 1000
@export_range(0, PI) var max_tire_angle: float = 0.4
@export_range(0.1,5) var steering_speed: float = 1.5

@export var player_info: PlayerInfo = null:
	set(value):
		if is_node_ready():
			interactor.player_info = value
			player_info = value

func _physics_process(delta):
	var input: InputProfile = player_info.input
	steering = lerp(steering, input.get_steering() * (-max_tire_angle), steering_speed*delta)
	var acceleration: float = input.get_forward() - input.get_brake()
	
	_set_wheel_force($rear_left, acceleration)
	_set_wheel_force($rear_right, acceleration)

func _set_wheel_force(wheel: VehicleWheel3D, acceleration: float):
	var damper: float = (1-(abs(mph)/max_mph))
	damper *= 1-min(max_damper_for_turning, abs(steering)/max_tire_angle)
	wheel.engine_force = acceleration * max_torque * damper

func _process(delta):
	var rel_up: Vector3 = transform.basis.y
	if rel_up.angle_to(Vector3.UP) >= PI/4:
		reset_timer += delta
		if reset_timer > MAX_FLIPPED_TIME_TILL_RIGHTED:
			set_upright()
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
