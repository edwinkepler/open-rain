#------------------------------------------------------------------------------#
# Button for accessing debug console on touch devices
#
# \since 0.1.0
#------------------------------------------------------------------------------#
extends Button

#-#
# Set it on center of a screen
#
# \since 0.1.0
#------------------------------------------------------------------------------#
func _ready():
	var v_viewport_size = get_viewport_rect().size
	set_position( Vector2( ( v_viewport_size.x / 2 ) - ( v_size.width / 2 ), 0 ) )  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
	
	debug.log_it( "[" + get_name() + "] _ready() done" )

#-#
# Toggle debug console when clicked and hide virtual keyboard when console is hidden
#
# \since 0.1.0
#------------------------------------------------------------------------------#
func _on_btnConsoleToggle_toggled( pressed ):
	if not is_pressed():
		OS.hide_virtual_keyboard()
		get_tree().set_pause( false )
	else:
		get_tree().set_pause( true )
	
	if get_parent().has_node( "panConsole" ):
		get_parent().get_node( "panConsole" ).toggle_sliding()

