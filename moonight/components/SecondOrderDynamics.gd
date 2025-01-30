# components/SecondOrderDynamics.gd
# if confused wtf is going on in here, rewatch
# https://www.youtube.com/watch?v=KPoeNZZ6H4s
class_name SecondOrderDynamics extends RefCounted

var _k1: float
var _k2: float
var _k3: float
var _xp: float = 0.0      # Previous input
var _y: float = 0.0       # Current output
var _yd: float = 0.0      # Current velocity

# Initialize system with parameters
func initialize(f: float, zeta: float, r: float, y0: float):
	# Convert intuitive parameters to stiffness coefficients
	_k1 = zeta / (PI * f)
	_k2 = 1.0 / ((2 * PI * f) ** 2)
	_k3 = r * zeta / (2 * PI * f)
	_y = y0

# Update system with new input and delta time
func update(x: float, xd: float, delta: float) -> float:
	# Estimate velocity if not provided
	if xd == 0.0 && delta > 0:
		xd = (x - _xp) / delta
	_xp = x
	
	# Clamp k2 to prevent instability (from video's stability analysis)
	var critical_k2: float = (delta * delta + _k1 * delta) / 4.0
	var safe_k2: float = max(_k2, critical_k2)
	
	# Semi-implicit Euler integration
	var y_next: float = _y + _yd * delta
	var yd_next: float = _yd + delta * (x + _k3 * xd - _y - _k1 * _yd) / safe_k2
	
	_y = y_next
	_yd = yd_next	
	return _y
