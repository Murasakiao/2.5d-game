extends KinematicBody

const MOVE_SPEED = 7
const JUMP_FORCE = 9
const GRAVITY = 20
const MAX_FALL_SPEED = 30
var y_velo = 0
var facing_right = true
var isJumping = false

onready var anim = $graphics/AnimationPlayer

func _physics_process(delta):
	var move_dir = 0
	if Input.is_action_pressed("move_left"):
		if !isJumping:
			anim.play("FastRun")
		move_dir -= 1
	if Input.is_action_pressed("move_right"):
		if !isJumping:
			anim.play("FastRun")
		move_dir += 1
	if Input.is_action_just_released("move_left") or move_dir == 0:
		if !isJumping:
			anim.play("Idle")
	if Input.is_action_just_released("move_right") or move_dir == 0:
		if !isJumping:
			anim.play("Idle")
	
	move_and_slide(Vector3(move_dir * MOVE_SPEED, y_velo, 0), Vector3(0, 1, 0))
	
	var just_jump = false
	var grounded = is_on_floor()
	y_velo -= GRAVITY * delta
	
	if y_velo < -MAX_FALL_SPEED:
		y_velo = -MAX_FALL_SPEED 
		
	if grounded:
		y_velo = 0.1
		if Input.is_action_pressed("jump"):
			anim.play("Jump")
			y_velo = JUMP_FORCE
			just_jump = true
			isJumping = true
			yield(anim, "animation_finished")
			isJumping = false
			
			
	if move_dir < 0 and facing_right:
		flip()
	if move_dir > 0 and !facing_right:
		flip()

func flip():
	$graphics.rotation_degrees.y *= -1
	facing_right = !facing_right
