extends Area2D

@export var speed: int = 500

@onready var visible_notifier = $VisibleNotifier

var facing_left = false

func _ready() -> void:
	visible_notifier.connect("screen_exited", _on_screen_exited)

func _physics_process(delta: float) -> void:
	if Global.direction == "right":
		global_position.x += speed * delta
	elif Global.direction == "left":
		global_position.x -= speed * delta
	elif Global.direction == "down":
		global_position.y += speed * delta
	else:
		global_position.y -= speed * delta

func _on_screen_exited() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	queue_free()
	area.die()
