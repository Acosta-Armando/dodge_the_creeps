extends RichTextLabel

# Contenido para Windows/PC
const WINDOWS_CONTENT = "[b]WASD[/b]\nMove\n\n[b]Space / Enter[/b]\nStart Game\n\n[b]H[/b]\nHelp\n\n[b]ESC / Q[/b]\nClose Games"

# Contenido para Android/Táctil
const ANDROID_CONTENT = "[b]Joystick[/b]\nMove\n\n[b]Press Start[/b]\nStart Game\n\n[b]?[/b]\nHelp\n\n[b]Press Quit[/b]\nClose Game"


func _ready():
	var os_name = OS.get_name()
	if os_name == "Android" or os_name == "iOS":
		self.text = ANDROID_CONTENT
	else:
		self.text = WINDOWS_CONTENT
