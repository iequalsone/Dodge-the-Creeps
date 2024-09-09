extends Area2D

@export var speed: int = -2500

@onready var visible_notifier = $VisibleNotifier

var direction = Vector2.ZERO

func _ready() -> void:
	visible_notifier.connect("screen_exited", _on_screen_exited)
	
func set_direction(new_direction):
	direction = new_direction

func _physics_process(delta: float) -> void:
	if direction.x > 0:
		global_position.x += 80
	elif direction.x < 0:
		global_position.x -= 80
	elif direction.y > 0:
		global_position.y += 80
	else:
		global_position.y -= 80

	position += direction * speed * delta
	print(position)

func _on_screen_exited() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	queue_free()
