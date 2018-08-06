#------------------------------------------------------------------------------#
# Singleton for debug build functions
#
# \see scenes/ui/panConsole
# \since 0.0.1
#------------------------------------------------------------------------------#
extends Node

# Array with strings store when scenes/ui/panConsole is not avaible
var arr_buffer = []

#-#
# Nothing
#
# \since 0.0.1
#------------------------------------------------------------------------------#
func _ready():
	if OS.is_debug_build() == true:
		log_it( "[" + get_name() + "] You are running debug build" )
	
	log_it( "[" + get_name() + "] _ready() done" )

#-#
# Print to stdout and in-game console
#
# \more If scenes/ui/panConsole is not avaible then store string in arr_buffer
#
# \arg in_string String that will be printed
#
# \see log_it
# \since 0.0.1
#------------------------------------------------------------------------------#
func log_it( in_string ):
	if OS.is_debug_build() == true:
		# To avoid crash while changing scene
		if get_tree().get_current_scene() != null:
			if get_tree().get_current_scene().has_node( "panConsole" ) == true:
				var i_line_count = get_tree().get_current_scene().get_node( "panConsole/GridContainer/txtOutput" ).get_line_count()
				# Offset needed for console output show its output without empty lines
				var i_line_offset
				
				if OS.get_name() == "Android" or OS.get_name() == "iOS":
					i_line_offset = 6
				else:
					i_line_offset = 20
				
				get_tree().get_current_scene().get_node( "panConsole/GridContainer/txtOutput" ).cursor_set_line( i_line_count )
				get_tree().get_current_scene().get_node( "panConsole/GridContainer/txtOutput" ).insert_text_at_cursor( "\n" + in_string )
				get_tree().get_current_scene().get_node( "panConsole/GridContainer/txtOutput" ).cursor_set_line( i_line_count - i_line_offset )
			else:
				arr_buffer.push_back( in_string )
		else:
			arr_buffer.push_back( in_string )
	print( in_string )

#-#
# Print to scenes/ui/panConsole strings outputted when console wasn't avaiable
#
# \since 0.0.1
#------------------------------------------------------------------------------#
func print_buffer_to_console():
	for i in range( arr_buffer.size() ):
		var i_line_count = get_tree().get_current_scene().get_node( "panConsole/GridContainer/txtOutput" ).get_line_count()
		# Offset needed for console output show its output without empty lines
		var i_line_offset
		
		if OS.get_name() == "Android" or OS.get_name() == "iOS":
			i_line_offset = 6
		else:
			i_line_offset = 20
		
		get_tree().get_current_scene().get_node( "panConsole/GridContainer/txtOutput" ).cursor_set_line( i_line_count )
		get_tree().get_current_scene().get_node( "panConsole/GridContainer/txtOutput" ).insert_text_at_cursor( "\n" + arr_buffer[ i ] )
		get_tree().get_current_scene().get_node( "panConsole/GridContainer/txtOutput" ).cursor_set_line( i_line_count - i_line_offset )

#-#
# Log out pressed action for a node
#
# \arg in_parent Parent node of pressed node
# \arg in_node Node object that have been pressed
#
# \since 0.0.1
#------------------------------------------------------------------------------#
func print_pressed( in_parent, in_node ):
	log_it( "[" + in_parent + "] " + in_node + " pressed" )
