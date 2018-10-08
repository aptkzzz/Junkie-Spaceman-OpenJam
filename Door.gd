extends Area2D

func _on_Door_body_entered(body):
    if body.has_method("successful_end"):
        body.successful_end()