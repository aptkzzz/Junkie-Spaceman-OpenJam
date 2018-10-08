extends KinematicBody2D

export (int) var hp
export (float) var bullet_speed
export (int) var damage
export (int) var max_drop
export (bool) var rotated_right

export (int) var gravity = 500
export (int) var walk_force = 600
export (int) var walk_min_speed = 10
export (int) var walk_max_speed = 200
export (int) var stop_force = 1300

export (PackedScene) var Drop
export (PackedScene) var Bullet

var player = self
var velocity = Vector2()

func _ready():
    $AnimatedSprite.flip_h = not rotated_right
    $ShootTimer.start()
    $WalkTimer.start()

func hit(damage):
    $HitSound.play(0)
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

func _on_ShootTimer_timeout():
    if player == self:
        player = get_tree().get_nodes_in_group("Players")[0]
    var playerpos = player.get_position()
    var mypos = get_position()
    $RayCast2D.cast_to = playerpos - mypos
    $RayCast2D.force_raycast_update()
    if $RayCast2D.is_colliding():
        if $RayCast2D.get_collider() == player:
            shoot(mypos, playerpos)

func shoot(mypos, playerpos):
    var direction = (playerpos - mypos).normalized()
    var bullet = Bullet.instance()
    $ShotSound.play(0)
    get_parent().add_child(bullet)
    bullet.damage = damage
    bullet.look_at(playerpos)
    bullet.set_position(get_position())
    bullet.look_at(playerpos)
    var velocity = Vector2(bullet_speed, 0).rotated(bullet.get_rotation())
    bullet.linear_velocity = velocity
    

func _on_WalkTimer_timeout():
    rotated_right = not rotated_right
    $AnimatedSprite.flip_h = not rotated_right
    $WalkTimer.wait_time = rand_range(0.2, 2.5)

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