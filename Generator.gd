extends Area2D

export (PackedScene) var Priest
export (int) var enemy_count

func _on_Area2D_body_entered(body):
    if not body.has_method("successful_end"):
        return false
    for i in range(enemy_count):
        var priest = Priest.instance()
        get_parent().add_child(priest)
        priest.set_position(get_position())
    queue_free()