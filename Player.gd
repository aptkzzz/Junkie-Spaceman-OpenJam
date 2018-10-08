extends KinematicBody2D

signal update_score(score)
signal update_health(hp)
signal death
signal success_end

export (int) var level = 1

export (int) var health = 200

export (int) var gravity = 500
export (int) var floor_angle_tolerance = 50
export (int) var walk_force = 600
export (int) var walk_min_speed = 10
export (int) var walk_max_speed = 200
export (int) var stop_force = 1300
export (int) var jump_speed = 200
export (float) var jump_max_airborne_time = 0.2

export (int) var slide_stop_velocity = 1
export (int) var slide_stop_min_travel = 1

export (int) var bullet_damage = 5
export (int) var bomb_damage = 100
export (int) var bullet_speed = 10
export (int) var bomb_force = 10

export (PackedScene) var Bullet
export (PackedScene) var Bomb

var velocity = Vector2()
var on_air_time = 100
var jumping = false
var prev_jump_pressed = false

var current_weapon = 0
var facing_right = true
var weapons = ["lasergun", "bomb"]
var score = 0

func _process(delta):
    var movement = Vector2()
    if Input.is_action_just_released("weapon_prev") and current_weapon != 0:
        current_weapon -= 1
    if Input.is_action_just_released("weapon_next") and current_weapon < (weapons.size() - 1):
        current_weapon += 1

func _physics_process(delta):
    var force = Vector2(0, gravity)
    var walk_left = Input.is_action_pressed("ui_left")
    var walk_right = Input.is_action_pressed("ui_right")
    var jump = Input.is_action_pressed("ui_up")
    var stop = true
    $AnimatedSprite.animation = "idle"
    if walk_left:
        if velocity.x <= walk_min_speed and velocity.x > -walk_max_speed:
            force.x -= walk_force
            stop = false
        $AnimatedSprite.animation = "run"
        $AnimatedSprite.flip_h = true
    elif walk_right:
        if velocity.x >= -walk_min_speed and velocity.x < walk_max_speed:
            force.x += walk_force
            stop = false
        $AnimatedSprite.animation = "run"
        $AnimatedSprite.flip_h = false
    if stop:
        var vsign = sign(velocity.x)
        var vlen = abs(velocity.x)
        vlen -= stop_force * delta
        if vlen < 0:
            vlen = 0
        velocity.x = vlen * vsign
    velocity += force * delta
    velocity = move_and_slide(velocity, Vector2(0, -1))
    if is_on_floor():
        on_air_time = 0
    if jumping and velocity.y > 0:
        jumping = false
    if on_air_time < jump_max_airborne_time and jump and not prev_jump_pressed and not jumping:
        velocity.y = -jump_speed
        jumping = true
    on_air_time += delta
    prev_jump_pressed = jump
    if Input.is_action_just_pressed("shoot"):
        if current_weapon == 0:
            shoot()
        elif current_weapon == 1:
            drop_bomb()

func hit(damage):
    health -= damage
    emit_signal("update_health", health)
    if health <= 0:
        die()

func die():
    hide()
    emit_signal("death")

func add_score(value):
    score += value
    emit_signal("update_score", score)

func successful_end():
    emit_signal("success_end")

func shoot():
    var mousepos = get_global_mouse_position()
    var mypos = get_global_position()
    var bullet = Bullet.instance()
    get_parent().add_child(bullet)
    bullet.set_position(get_position())
    bullet.damage = bullet_damage
    bullet.look_at(mousepos)
    var velocity = Vector2(bullet_speed, 0).rotated(bullet.get_rotation())
    bullet.linear_velocity = velocity

func drop_bomb():
    var mousepos = get_global_mouse_position()
    var mypos = get_global_position()
    var bomb = Bomb.instance()
    get_parent().add_child(bomb)
    bomb.set_position(get_position())
    bomb.damage = bomb_damage
    bomb.look_at(mousepos)
    var velocity = Vector2(bomb_force, 0).rotated(bomb.get_rotation())
    bomb.linear_velocity = velocity