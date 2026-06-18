class_name Tilt
extends Control

const MAX_TILT = 25

# percent is value between -1 and 1
func set_tilt(percent: float):
	rotation = deg_to_rad(percent * MAX_TILT)
