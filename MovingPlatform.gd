extends KinematicBody2D

export (float) var move_force = 1
export (float) var side_move_time = 1

var movingright = true

func _ready():
    $MoveTimer.wait_time = side_move_time
    $MoveTimer.start()

func _physics_process(delta):
    if movingright:
        set_linear_velocity(Vector2(move_force, 0))
    else:
        set_linear_velocity(Vector2(-move_force, 0))

func _on_MoveTimer_timeout():
    movingright = not movingright