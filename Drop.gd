extends Area2D

export (int) var value

func _on_Drop_body_entered(body):
    if body.has_method("add_score"):
        body.add_score(value)
        queue_free()