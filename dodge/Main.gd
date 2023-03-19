extends Node

@export var mob_scene: PackedScene
var score
var screen_size
var isWindOn = false
var winds # dictionary of wind arrays [name, direction, min_x, max_x, min_y, max_y]
var wind  # currently selected wind

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = $Player.get_viewport_rect().size
	# fill dictionary in accordance with screen size by defining x/y range for spawn
	winds = {
		0: ["East",  PI,       screen_size.x, screen_size.x, 0, screen_size.y],
		1: ["North", PI/2,     0, screen_size.x, 0, 0],
		2: ["West",  2*PI,     0, 0, 0, screen_size.y],
		3: ["South", (3*PI)/2, 0, screen_size.x, screen_size.y, screen_size.y]
	}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$DeathSound.play()
	$Music.stop()
	$HUD.show_game_over()
	
func new_game():
	score = 0
	get_tree().call_group("mobs", "queue_free")
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$Music.play()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$HUD/WindTimer.start()
	
func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
	
func _on_mob_timer_timeout():
	# init
	var mob = mob_scene.instantiate()
	var new_position_x # if isWindOn - generate new spawn boundaries (x)
	var new_position_y # if isWindOn - generate new spawn boundaries (y)
	var velocity # mob velocity
	
	# find random location on path2d
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()
	
	
	# more consistent behavior with assigning value inside if
	var direction
	
	# make direction bit more random
	if isWindOn:
		# fixed direction, spawn range and high velocity
		new_position_x = randf_range(wind[2], wind[3])
		new_position_y = randf_range(wind[4], wind[5])
		direction = wind[1]
		mob.position = Vector2(new_position_x, new_position_y)
		velocity = Vector2(randf_range(250.0, 350.0), 0.0)
		$HUD/WindLabel.show()
		$HUD.update_wind(wind[0])
	else:
		# random direction, position and low velocity
		# set rotation to be perpendicular to path
		direction = (mob_spawn_location.rotation + PI / 2) + randf_range(-PI / 4, PI / 4)
		mob.position = mob_spawn_location.position
		velocity = Vector2(randf_range(150.0, 250.0), 0.0)
		$HUD/WindLabel.hide()
		
	# assign the rotation and velocity for the mob
	mob.rotation = direction
	mob.linear_velocity = velocity.rotated(direction)
	
	# spawn
	add_child(mob)

func _on_hud_wind_starts():
	isWindOn = not isWindOn
	$HUD/WindTimer.wait_time = randf_range(2, 8)
	wind = winds[int(randf_range(0,3))]


func _on_hud_noclip():
	if $HUD/NoClip.is_pressed():
		$Player.collision_mask = 2
	else:
		$Player.collision_mask = 1
