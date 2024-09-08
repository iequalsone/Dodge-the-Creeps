extends Area2D

signal hit

@export var speed = 400 
var screen_size

var projectile_speed = 600
var projectile_scene = preload("res://scenes/projectile.tscn")

@onready var projectile_container = $ProjectileContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO # The player's movement vector.
	
	if Input.is_action_just_pressed("shoot_projectile"):
		shoot_projectile(velocity.x < 0)

	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation  = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0


func _physics_process(delta: float) -> void:
	var screen_size = get_viewport_rect().size
	global_position = global_position.clamp(Vector2(0,0), screen_size)

func shoot_projectile(forward: bool) -> void:
	var projectile_instance = projectile_scene.instantiate()
	projectile_container.add_child(projectile_instance)
	projectile_instance.global_position = global_position
	if forward:
		projectile_instance.global_position.x += 80
	else:
		projectile_instance.global_position.x -= 80
	# play projectile sound here

func _on_body_entered(body: Node2D) -> void:
	Global.camera.shake(0.2, 6)
	hide() # Player disappears after being hit
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
