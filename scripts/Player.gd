extends CharacterBody2D

@export var speed= 220.0
@export var turn_speed = 8.0 
@export var bounce_boost = 1.3
@export var max_speed = 450.0

var current_speed = 220.0
var move_direction = Vector2.RIGHT

func _ready() -> void:
	current_speed = speed

func _physics_process(delta: float) -> void:
	var input_vector: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input_vector != Vector2.ZERO:
		move_direction = move_direction.lerp(input_vector, turn_speed * delta).normalized()

	if current_speed > speed:
		current_speed = move_toward(current_speed, speed, 80.0 * delta)

	var target_velocity = move_direction * current_speed
	velocity = velocity.lerp(target_velocity, 12.0 * delta)

	var collision = move_and_collide(velocity * delta)
	if collision:
		global_position += collision.get_normal() * 2.5
		
		var bounce_dir = velocity.bounce(collision.get_normal())
		move_direction = bounce_dir.normalized()
		current_speed = min(current_speed * bounce_boost, max_speed)

	rotation = lerp_angle(rotation, move_direction.angle(), 14.0 * delta)



#line 12 buat tubruk dan mantul

#belajar gdscript sama kek python part 1: kita mesen tempat di RAM, pakai var karena sewaktu-waktu var dapat berubah, dan buat variable/wadah bernama speed dengan nilai float berdesimal 200.0, dan variable move_direction berisi Vector2 (bawaan yang ada 2 sumbu), bisa pakai akses ke dalam menggunakan titik / '.', atau Vector2.RIGHT, UPPERCASE karna itu pascalcase dan bertipe konstanta yang nilainya baku / gak bisa diubah. Itu semua bawaan Godot, tapi kalo mau manual bisa langsung tempelin ke koordinat kayak Vector2(1,0) (x, y) (x nilainya sama kayak matematika, y itu kebalikannya karena ini ialah standar koordinat layar komputer berada di layar pojok kiri atas)

#di atas cuman input pengguna atau data
