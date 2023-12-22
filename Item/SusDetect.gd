extends Node2D

signal hearing_collision_entered
signal hearing_collision_exited

func area_entered() -> void:
	hearing_collision_entered.emit()

func area_exited() -> void:
	hearing_collision_exited.emit()
