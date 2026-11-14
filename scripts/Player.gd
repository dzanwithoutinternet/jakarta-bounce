extends CharacterBody2D

@export var turn_speed = 10.0
@export var speed = 220.0
@export var bounce_boost = 1.3
@export var max_speed = 450.0

var current_speed = 220.0
var move_direction = Vector2.RIGHT
var bounce_timer = 0.0

func _ready() -> void:
	current_speed = speed
	
func _physics_process(delta: float) -> void:
	if bounce_timer > 0.0:
		bounce_timer -= delta
	else:
		var input_vector: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		if input_vector != Vector2.ZERO:
			move_direction = input_vector
		
		
	if current_speed > speed:
		current_speed = move_toward(current_speed, speed, 90.0 * delta)
	
	velocity = move_direction * speed
	
	var collision =  move_and_collide(velocity * delta)
	if collision:
		global_position += collision.get_normal() * 2.0
		var bounce_direction = velocity.bounce(collision.get_normal())
		move_direction = bounce_direction.normalized()
		bounce_timer = 0.1
		current_speed = min(current_speed * bounce_boost, max_speed)
		
	rotation = move_direction.angle()




#line 12 buat tubruk dan mantul

#belajar gdscript sama kek python part 1: kita mesen tempat di RAM, pakai var karena sewaktu-waktu var dapat berubah, dan buat variable/wadah bernama speed dengan nilai float berdesimal 200.0, dan variable move_direction berisi Vector2 (bawaan yang ada 2 sumbu), bisa pakai akses ke dalam menggunakan titik / '.', atau Vector2.RIGHT, UPPERCASE karna itu pascalcase dan bertipe konstanta yang nilainya baku / gak bisa diubah. Itu semua bawaan Godot, tapi kalo mau manual bisa langsung tempelin ke koordinat kayak Vector2(1,0) (x, y) (x nilainya sama kayak matematika, y itu kebalikannya karena ini ialah standar koordinat layar komputer berada di layar pojok kiri atas)

#di atas cuman input pengguna atau data
