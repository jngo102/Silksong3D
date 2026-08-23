class_name Projectile extends CharacterBody3D

signal collided()

func _process(delta: float) -> void:
	var collision: KinematicCollision3D =  move_and_collide(velocity)
	if is_instance_valid(collision):
		velocity = Vector3.ZERO
		collide()

func shoot(direction: Vector3, speed: float) -> void:
	velocity = direction.normalized() * speed
	look_at(velocity)

func collide() -> void:
	collided.emit()
