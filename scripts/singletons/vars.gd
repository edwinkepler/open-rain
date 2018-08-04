#------------------------------------------------------------------------------#
# Singleton for variables avaible for every part of a application
# \more
#	Also containes functions to access/alter variables and config file.
#
# \since 0.0.1
#------------------------------------------------------------------------------#
extends Node

# Array of resolutions
const arr_res = []

# Array of languages avaible
const arr_languages = []

# Array of UI scale modificators
const arr_ui_scale = []

# Size of a view x margin
var int_view_margin_x

# Size of a view y margin
var int_view_margin_y

# Configuration file
var cfg = ConfigFile.new()

# Size of the host's screen
var v_screen_size

# Size of viewport (application window in practice)
var v_viewport_size = { "x": 0, "y": 0 }

#-#
# Prepare variables on loading of this singleton
#
# \since 0.0.1
#------------------------------------------------------------------------------#
func _ready():
	# Populate array of resolutions
	arr_res.push_back( "1024x768" )
	arr_res.push_back( "1280x720" )
	arr_res.push_back( "1280x768" )
	arr_res.push_back( "1280x800" )
	arr_res.push_back( "1280x1024" )
	arr_res.push_back( "1360x768" )
	arr_res.push_back( "1366x768" )
	arr_res.push_back( "1440x900" )
	arr_res.push_back( "1536x864" )
	arr_res.push_back( "1600x900" )
	arr_res.push_back( "1680x1050" )
	arr_res.push_back( "1920x1080" )
	arr_res.push_back( "1920x1200" )
	arr_res.push_back( "2560x1080" )
	arr_res.push_back( "2560x1440" )
	arr_res.push_back( "3440x1440" )
	arr_res.push_back( "3840x2160" )
	
	# Populate array of avaible languages
	arr_languages.push_back( "English" )
	arr_languages.push_back( "Polski" )
	
	# Populate array of UI scale modificators
	arr_ui_scale.push_back( 1 )
	arr_ui_scale.push_back( 1.25 )
	arr_ui_scale.push_back( 1.5 )
	arr_ui_scale.push_back( 1.75 )
	arr_ui_scale.push_back( 2 )

	# Get a screen size
	v_screen_size = OS.get_screen_size()

	# Set view x margin
	int_view_margin_x = 200

	# Set view y margin
	int_view_margin_y = 100

	# Load configuration file (engine.cfg) and check if success
	if cfg.load( "user://settings.cfg" ) != OK:
		create_default_cfg()
	else:
		debug.log_it( "[" + get_name() + "] Configuration (user://settings.cfg) file loaded successfully." )

	debug.log_it( "[" + get_name() + "] _ready() done" )

#-#
# Load configuration file (user://settings.cfg) and check if success
#
# \since 0.0.1
#------------------------------------------------------------------------------#
func reload_cfg():
	# Load configuration file (engine.cfg) and check if success
	if cfg.load( "user://settings.cfg" ) != OK:
		create_default_cfg()
		vars.reload_cfg()
	else:
		debug.log_it( "[" + get_name() + "] Configuration (user://settings.cfg) file loaded successfully." )

#-#
# Create config file and set def values
#
# \since 0.0.1
#------------------------------------------------------------------------------#
func create_default_cfg():
	debug.log_it( "[" + get_name() + "] Creating default config file (user://settings.cfg)." )

	if OS.get_locale() == "pl_PL":
		cfg.set_value( "game", "language", "pl" )
	else:
		cfg.set_value( "game", "language", "en" )
	
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		cfg.set_value( "game", "show_shortcuts", false )
		cfg.set_value( "display", "width", v_screen_size.width )
		cfg.set_value( "display", "height", v_screen_size.height )
		cfg.set_value( "display", "fullscreen", true )
		cfg.set_value( "display", "fps", 30 )
		cfg.set_value( "display", "blur_shaders", false )
		cfg.set_value( "display", "ui_scale", 1 )
	else:
		cfg.set_value( "game", "show_shortcuts", true )
		cfg.set_value( "display", "width", 1280 )
		cfg.set_value( "display", "height", 720 )
		cfg.set_value( "display", "fullscreen", false )
		cfg.set_value( "display", "fps", 60 )
		cfg.set_value( "display", "blur_shaders", true )
		cfg.set_value( "display", "ui_scale", 1 )
	
	cfg.set_value( "display", "vsync", false )
	cfg.set_value( "audio", "stream_volume_scale", 0.8 )
	cfg.set_value( "audio", "fx_volume_scale", 0.8 )
	cfg.save( "user://settings.cfg" )

#-#
# Update viewport size variable
#
# \since 0.0.1
#------------------------------------------------------------------------------#
func update_viewport_size_var( in_width, in_height ):
	v_viewport_size.x = in_width
	v_viewport_size.y = in_height
