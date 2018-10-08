extends KinematicBody2D

export (int) var gravity = 500
export (int) var walk_force = 600
export (int) var walk_min_speed = 10
export (int) var walk_max_speed = 200
export (int) var stop_force = 1300

export (int) var hp = 20
export (int) var damage = 5
export (int) var max_drop = 10
export (PackedScene) var Drop

var velocity = Vector2()
var rotated_right = bool(randi()%2)

func _ready():
    $AnimatedSprite.flip_h = not rotated_right
    $AnimatedFaces.flip_h = not rotated_right
    $AnimatedEyes.flip_h = not rotated_right
    $AnimatedFaces.animation = str(randi()%3)
    $AnimatedEyes.animation = str(randi()%3)
    $HitTimer.start()
    $WalkTimer.start()

func hit(damage):
    hp -= damage
    if hp <= 0:
        die()

func die():
    drop_bonus()
    queue_free()

func drop_bonus():
    var drop_value = randi() % max_drop
    if drop_value == 0:
        return false
    var drop = Drop.instance()
    drop.value = drop_value
    get_parent().add_child(drop)
    drop.set_position(get_position())
    

func _on_HitTimer_timeout():
    var bodies = $Area2D.get_overlapping_bodies()
    for i in bodies:
        if i.has_method("hit"):
            i.hit(damage)

func _physics_process(delta):
    var force = Vector2(0, gravity)
    var stop = true
    if not rotated_right:
        if velocity.x <= walk_min_speed and velocity.x > -walk_max_speed:
            force.x -= walk_force
            stop = false
    elif rotated_right:
        if velocity.x >= -walk_min_speed and velocity.x < walk_max_speed:
            force.x += walk_force
            stop = false
    if stop:
        var vsign = sign(velocity.x)
        var vlen = abs(velocity.x)
        vlen -= stop_force * delta
        if vlen < 0:
            vlen = 0
        velocity.x = vlen * vsign
    velocity += force * delta
    velocity = move_and_slide(velocity, Vector2(0, -1))

func _on_WalkTimer_timeout():
    rotated_right = not rotated_right
    $AnimatedSprite.flip_h = not rotated_right
    $AnimatedFaces.flip_h = not rotated_right
    $AnimatedEyes.flip_h = not rotated_right
    $WalkTimer.wait_time = rand_range(0.2, 2.5)