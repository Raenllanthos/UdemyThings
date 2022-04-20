extends KinematicBody2D

var motion = Vector2(0,0)
var lives = 3

const SPEED = 1000
const GRAVITY = 300
const UP = Vector2(0,-1)
const JUMP_SPEED = 3000
const WORLD_LIMIT = 3000

signal animate

func _physics_process(delta):
	applyGravity()
	jump()
	move()
	animate()
	move_and_slide(motion, UP)

func applyGravity():
	if position.y > WORLD_LIMIT:
		endGame()
	if is_on_floor():
		motion.y = 0
	elif is_on_ceiling():
		motion.y = 1
	else:
		motion.y += GRAVITY

func move():
	if Input.is_action_pressed("left") and not Input.is_action_pressed("right"):
		motion.x = -SPEED
	elif Input.is_action_pressed("right") and not Input.is_action_pressed("left"):
		motion.x = SPEED
	else:
		motion.x = 0

func animate():
	emit_signal("animate", motion)

func jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		motion.y -= JUMP_SPEED

func endGame():
	get_tree().change_scene("res://Levels/GameOver.tscn")
	
func hurt():
	lives -= 1
	position.y -= 1
	yield(get_tree(), "idle_frame")
	motion.y -= JUMP_SPEED
	if lives < 0:
		endGame()
	
