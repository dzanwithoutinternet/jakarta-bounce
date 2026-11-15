extends CharacterBody2D

@export var speed = 230.0
@export var turn_speed = 9.0
@export var bounce_boost = 1.35
@export var max_speed = 480.0

var current_speed = 230.0
var facing_direction = Vector2.RIGHT
var timer_api_bumper = 0.0
var has_package = false
var total_cuan = 0
var sisa_waktu = 45.0
var game_selesai = false

func _ready():
	current_speed = speed
	if has_node("Api_bumper"):
		$Api_bumper.visible = false
	if has_node("Api_knalpot"):
		$Api_knalpot.visible = false
	if has_node("Api_knalpot2"):
		$Api_knalpot2.visible = false

	if has_node("../Paket"):
		var pkt = get_node("../Paket")
		if not pkt.body_entered.is_connected(_on_paket_body_entered):
			pkt.body_entered.connect(_on_paket_body_entered)
	if has_node("../Rumah_tujuan"):
		var rmh = get_node("../Rumah_tujuan")
		if not rmh.body_entered.is_connected(_on_rumah_tujuan_body_entered):
			rmh.body_entered.connect(_on_rumah_tujuan_body_entered)

	if has_node("../HUD/GameOverOverlay/TombolRetry"):
		$"../HUD/GameOverOverlay/TombolRetry".pressed.connect(_on_retry_pressed)
	if has_node("../HUD/AwardOverlay/TombolMainLagi"):
		$"../HUD/AwardOverlay/TombolMainLagi".pressed.connect(_on_retry_pressed)

func _physics_process(delta):
	if game_selesai:
		if Input.is_action_just_pressed("ui_accept"):
			get_tree().reload_current_scene()
		return

	var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input_vector != Vector2.ZERO:
		facing_direction = facing_direction.lerp(input_vector, turn_speed * delta).normalized()
	
	rotation = lerp_angle(rotation, facing_direction.angle(), 12.0 * delta)

	if timer_api_bumper > 0.0:
		timer_api_bumper -= delta
		if timer_api_bumper <= 0.0 and has_node("Api_bumper"):
			$Api_bumper.visible = false

	if current_speed > speed:
		current_speed = move_toward(current_speed, speed, 85.0 * delta)
		if has_node("Api_knalpot") and has_node("Api_knalpot2"):
			$Api_knalpot.visible = true
			$Api_knalpot2.visible = true
			var rasio = (current_speed - speed) / (max_speed - speed)
			var skala = lerp(0.02, 0.05, rasio)
			$Api_knalpot.scale = Vector2(skala, skala)
			$Api_knalpot2.scale = Vector2(skala, skala)
	else:
		if has_node("Api_knalpot") and has_node("Api_knalpot2"):
			$Api_knalpot.visible = false
			$Api_knalpot2.visible = false

	var target_vel = facing_direction * current_speed
	velocity = velocity.lerp(target_vel, 8.0 * delta)

	var collision = move_and_collide(velocity * delta)
	if collision:
		global_position += collision.get_normal() * 2.5
		velocity = velocity.bounce(collision.get_normal()) * bounce_boost
		current_speed = min(current_speed * bounce_boost, max_speed)
		
		if has_node("Api_bumper"):
			$Api_bumper.visible = true
			timer_api_bumper = 0.12

		if has_node("Suara_mantul"):
			$Suara_mantul.play()

	sisa_waktu -= delta
	if sisa_waktu <= 0.0:
		sisa_waktu = 0.0
		game_selesai = true
		if has_node("../HUD/GameOverOverlay"):
			$"../HUD/GameOverOverlay".visible = true
		if has_node("../HUD/GameOverOverlay/SuaraKalah"):
			$"../HUD/GameOverOverlay/SuaraKalah".play()

	if has_node("../HUD/Label_Waktu"):
		$"../HUD/Label_Waktu".text = "Waktu: " + str(int(sisa_waktu)) + "s"
	if has_node("../HUD/LabelCuan"):
		$"../HUD/LabelCuan".text = "SETORAN: Rp " + str(total_cuan)

func _on_paket_body_entered(body):
	if body == self:
		has_package = true
		if has_node("../Paket"):
			$"../Paket".queue_free()

func _on_paket_entered(body):
	_on_paket_body_entered(body)

func _on_rumah_tujuan_body_entered(body):
	if body == self and has_package:
		has_package = false
		total_cuan += 50000
		game_selesai = true
		if has_node("../HUD/AwardOverlay"):
			$"../HUD/AwardOverlay".visible = true
			if has_node("../HUD/AwardOverlay/LabelSkor"):
				$"../HUD/AwardOverlay/LabelSkor".text = "TOTAL CUAN: Rp " + str(total_cuan)

func _on_rumah_entered(body):
	_on_rumah_tujuan_body_entered(body)

func _on_retry_pressed():
	get_tree().reload_current_scene()
