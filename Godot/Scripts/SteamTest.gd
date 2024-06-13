extends Control

@onready var steam_power = $"SteamPower"
@onready var steam_avatar = $"ProfileCardPanel/SteamIcon"
@onready var steam_name = $"ProfileCardPanel/SteamName"

const steam_power_str = "Your Steam is currently... "

# Called when the node enters the scene tree for the first time.
func _ready():
	if Steam:
		var stats = Steam.steamInit(true,2145350)
		print_debug(stats)
		await get_tree().create_timer(3.0).timeout
		var steamRunning = Steam.isSteamRunning()
		if steamRunning:
			print("Steam is not running... Please start Steam first or run the game via Steam")
			steam_power.text = steam_power_str + "OFF"
			return

		steam_power.text = steam_power_str + "ON"

		var userID = Steam.getSteamID()
		var user_name = Steam.getFriendPersonaName(userID)

		steam_name.text = user_name

		Steam.avatar_loaded.connect(steam_user_avatar_loaded)

func steam_user_avatar_loaded(id, icon_size, buffer : PackedByteArray):
	var avatarImage = Image.create_from_data(icon_size, icon_size, false, Image.FORMAT_RGBA8, buffer)

	var texture = ImageTexture.create_from_image(avatarImage)
	steam_avatar.texture = texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
