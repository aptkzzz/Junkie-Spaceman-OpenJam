extends RigidBody2D

export (int) var damage = 5

func _on_body_entered(body):
    if body.has_method("hit"):
        body.hit(damage)
    queue_free()