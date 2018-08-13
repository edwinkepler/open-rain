#------------------------------------------------------------------------------#
# Starting scene
#
# \since 0.1.0
#------------------------------------------------------------------------------#
extends Node

#-#
# Prepare everything and load main menu or given scene
#
# \since 0.1.0
#------------------------------------------------------------------------------#
func _ready():	
	debug.log_it( "[" + get_name() + "] Godot version " + str( Engine.get_version_info().major ) + "." + str( Engine.get_version_info().minor ) + "." + str( Engine.get_version_info().patch ) + "." + str( Engine.get_version_info().status ) )
	debug.log_it( "[" + get_name() + "] Game version " + str( ProjectSettings.get_setting( "application/v_major" ) ) + "." + str( ProjectSettings.get_setting( "application/v_minor" ) ) + "." + str( ProjectSettings.get_setting( "application/v_patch" ) ) + "." + str( ProjectSettings.get_setting( "application/v_status" ) ) )
	debug.log_it( "[" + get_name() + "] OS.environment " + OS.get_name() )
	debug.log_it( "[" + get_name() + "] OS.name " + OS.get_model_name() )
	debug.log_it( "[" + get_name() + "] OS.executable_path " + OS.get_executable_path() )
	debug.log_it( "[" + get_name() + "] OS.locale " + OS.get_locale() )
	debug.log_it( "[" + get_name() + "] OS.screen_dpi " + str( OS.get_screen_dpi() ) )
	debug.log_it( "[" + get_name() + "] OS.screen_orientation " + str( OS.get_screen_orientation() ) )
	debug.log_it( "[" + get_name() + "] OS.screen_posititon " + str( OS.get_screen_position() ) )
	debug.log_it( "[" + get_name() + "] OS.screen_size " + str( OS.get_screen_size() ) ) 
	debug.log_it( "[" + get_name() + "] OS.static_memory_usage " + str( OS.get_static_memory_usage() ) )
	debug.log_it( "[" + get_name() + "] OS.is_vsync_enabled " + str( OS.is_vsync_enabled() ) )
	
	debug.log_it( "[" + get_name() + "] CFG.display_width " + str( vars.cfg.get_value( "display", "width" ) ) )
	debug.log_it( "[" + get_name() + "] CFG.display_height " + str( vars.cfg.get_value( "display", "height" ) ) )
	debug.log_it( "[" + get_name() + "] CFG.display_fullscreen " + str( vars.cfg.get_value( "display", "fullscreen" ) ) )
	debug.log_it( "[" + get_name() + "] CFG.display_vsync " + str( vars.cfg.get_value( "display", "vsync" ) ) + " (Enabled: " + str( OS.is_vsync_enabled() ) + ")" )
	debug.log_it( "[" + get_name() + "] CFG.display_blur_shaders " + str( vars.cfg.get_value( "display", "blur_shaders" ) ) )
	debug.log_it( "[" + get_name() + "] CFG.display_fps " + str( vars.cfg.get_value( "display", "fps" ) ) )
	debug.log_it( "[" + get_name() + "] CFG.display_ui_scale " + str( vars.cfg.get_value( "display", "ui_scale" ) ) )
	
	var arr_joys = Input.get_connected_joypads()
	for i in arr_joys:
		debug.log_it( "[" + get_name() + "] Input.get_joy_name " + str( i ) + ":" + Input.get_joy_name( i ) )
		debug.log_it( "[" + get_name() + "] Input.is_joy_known " + str( i ) + ":" + str( Input.is_joy_known( i ) ) )
		debug.log_it( "[" + get_name() + "] Input.get_joy_guid " + str( i ) + ":" + Input.get_joy_guid( i ) )
	
	debug.log_it( "[" + get_name() + "] Settings application locale to " + vars.cfg.get_value( "game", "language" ) )
	TranslationServer.set_locale( vars.cfg.get_value( "game", "language" ) )
	debug.log_it( "[" + get_name() + "] Settings target fps to " + str( vars.cfg.get_value( "display", "fps" ) ) )
	Engine.target_fps = vars.cfg.get_value( "display", "fps" )
	
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		# You can't change size of window on mobile devices so just set it to device's screen size
		OS.set_window_size( Vector2( vars.v_screen_size.width, vars.v_screen_size.height ) )
		get_viewport().set_size_override( true, Vector2( vars.v_screen_size.width, vars.v_screen_size.height ), Vector2( 0, 0 ) )
		# Hide mouse pointer. Normaly mouse pointer is not shown but when using custom mouse pointer it will appear on mobile
		Input.set_mouse_mode( 1 )
	else:
		if vars.cfg.get_value( "display", "fullscreen" ):
			OS.set_window_fullscreen( true )
			OS.set_window_size( Vector2( vars.v_screen_size.x, vars.v_screen_size.y ) )
			get_viewport().set_size_override( true, Vector2( vars.v_screen_size.x, vars.v_screen_size.y ), Vector2( 0, 0 ) )
			vars.update_viewport_size_var( vars.v_screen_size.x, vars.v_screen_size.y )
		else:
			OS.set_window_size( Vector2( vars.cfg.get_value( "display", "width" ), vars.cfg.get_value( "display", "height" ) ) )
			get_viewport().set_size_override( true, Vector2( vars.cfg.get_value( "display", "width" ), vars.cfg.get_value( "display", "height" ) ), Vector2( 0, 0 ) )
			vars.update_viewport_size_var( vars.cfg.get_value( "display", "width" ), vars.cfg.get_value( "display", "height" ) )

	app.change_scene( "res://scenes/levels/main_menu.scn" )
	debug.log_it( "[" + get_name() + "] _ready() done" )

#-#
# Will trigger when scene/node enter the tree
#
# \since 0.1.0
#------------------------------------------------------------------------------#
func _on_init_enter_tree():
	debug.log_it( "[" + get_name() + "] _enter_tree() done" )

#-#
# Will trigger when scene/node exit the tree
#
# \since 0.1.0
#------------------------------------------------------------------------------#
func _on_init_exit_tree():
	debug.log_it( "[" + get_name() + "] _exit_tree() done" )

