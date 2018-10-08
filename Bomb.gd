extends RigidBody2D

export (int) var damage

func _ready():
    $AnimatedSprite.animation = "default"
    $AnimatedSprite.play()
    $ExplosionTimer.start()

func _on_ExplosionTimer_timeout():
    $AnimatedSprite.animation = "explosion"
    $AnimatedSprite.play()

func _on_AnimatedSprite_animation_finished():
    if $AnimatedSprite.animation == "explosion":
        var bodies = $ExplosionArea.get_overlapping_bodies()
        for i in bodies:
            if i.has_method("hit"):
                i.hit(damage)
        if bodies.size() > 0:
            queue_free()