extends Node2D

export (PackedScene) var Demon
export (int) var count = 5
export (float) var spawntime = 0.5
export (bool) var rotated_right = true

func _ready():
    $AnimatedSprite.flip_h = not rotated_right
    $AnimatedSprite.animation = "create"
    $AnimatedSprite.play()
    $SpawnTimer.wait_time = spawntime

func _on_AnimatedSprite_animation_finished():
    if $AnimatedSprite.animation == "create":
        $AnimatedSprite.animation = "work"
        $AnimatedSprite.play()
        $SpawnTimer.start()

func _on_SpawnTimer_timeout():
    if $AnimatedSprite.animation == "work":
        spawn_demon()
        count -= 1
        if count == 0:
            $SpawnTimer.stop()
            $AnimatedSprite.animation = "remove"
            $AnimatedSprite.play()

func spawn_demon():
    var demon = Demon.instance()
    demon.rotated_right = rotated_right
    get_parent().add_child(demon)
    demon.set_position(get_position())
    