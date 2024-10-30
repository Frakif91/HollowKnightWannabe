extends Control

@onready var steam_power = $"SteamPower"
@onready var steam_avatar = $"ProfileCardPanel/SteamIcon"
@onready var steam_name = $"ProfileCardPanel/SteamName"

const steam_power_str = "Your Steam is currently... "

# Called when the node enters the scene tree for the first time.
func _ready():
	if Steam:
		var stats = Steam.steamInit(true,480)
		await get_tree().create_timer(5.0).timeout
		var steamRunning = Steam.isSteamRunning()

		if not steamRunning:
			print("Steam is not running... Please start Steam first or run the game via Steam")
			print_debug(steamRunning)
			steam_power.text = steam_power_str + "OFF"
			return
		else:
			print("Steamworks finally works !")
			print(Steam.getAppID()," <-> ",Steam.getSteamID())

		steam_power.text = steam_power_str + "ON"

		var userID = Steam.getSteamID()
		var user_name = Steam.getFriendPersonaName(userID)
		
		steam_name.text = user_name

		print("Ready to get avatar")
		Steam.avatar_loaded.connect(steam_user_avatar_loaded)
		Steam.getPlayerAvatar(Steam.AVATAR_LARGE,userID)

		print("Discord RPC time")
	
	if DiscordRPC:
		# Application ID
		DiscordRPC.app_id = 1099618430065324082
		# this is boolean if everything worked
		print("Discord working: " + str(DiscordRPC.get_is_discord_working()))
		# Set the first custom text row of the activity here
		DiscordRPC.details = """A demo activity by vaporvee|1231"""
		# Set the second custom text row of the activity here
		DiscordRPC.state = "Checkpoint 23/23"
		# Image key for small image from "Art Assets" from the Discord Developer website
		DiscordRPC.large_image = "game"
		# Tooltip text for the large image
		DiscordRPC.large_image_text = "Try it now!"
		# Image key for large image from "Art Assets" from the Discord Developer website
		DiscordRPC.small_image = "boss"
		# Tooltip text for the small image
		DiscordRPC.small_image_text = "Fighting the end boss! D:"
		# "02:41 elapsed" timestamp for the activity
		DiscordRPC.start_timestamp = int(Time.get_unix_time_from_system())
		# "59:59 remaining" timestamp for the activity
		DiscordRPC.end_timestamp = int(Time.get_unix_time_from_system()) + 3600
		# Always refresh after changing the values!
		DiscordRPC.refresh()

func steam_user_avatar_loaded(id, icon_size, buffer : PackedByteArray):
	var avatarImage = Image.create_from_data(icon_size, icon_size, false, Image.FORMAT_RGBA8, buffer)

	var texture = ImageTexture.create_from_image(avatarImage)
	steam_avatar.texture = texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
