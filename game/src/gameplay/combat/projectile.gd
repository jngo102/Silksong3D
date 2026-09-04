class_name Projectile extends CharacterBody3D

signal collided()

func _process(delta: float) -> void:
	var collision: KinematicCollision3D = move_and_collide(velocity * delta)
	if is_instance_valid(collision):
		velocity = Vector3.ZERO
		collide()

func shoot(direction: Vector3, speed: float) -> void:
	velocity = direction.normalized() * speed
	look_at(global_position + direction)

func collide() -> void:
	collided.emit()
