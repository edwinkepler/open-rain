#------------------------------------------------------------------------------#
# Singleton for managing how application works.
#
# \more Handling opening, closing and changing scenes
#
# \since 0.0.1
#------------------------------------------------------------------------------#
extends Node

# That variable hold current scene. Needed for freeing resources while changing scenes.
var s_current = null

#-#
# Nothing
#
# \since 0.0.1
#------------------------------------------------------------------------------#
func _ready():
	var root = get_tree().get_root()
	s_current = root.get_child( root.get_child_count() - 1 )
	debug.log_it( "[" + get_name() + "] Current scene: " + get_tree().get_current_scene().get_name() )

	debug.log_it( "[" + get_name() + "] _ready() done" )

#-#
# Calls deferred function to avoid crashing while switching scenes
#
# \since 0.0.1
#------------------------------------------------------------------------------#
func change_scene( path ):
    call_deferred( "_deferred_change_scene", path )

#-#
# Change scene. You need to provide full path to next scene
#
# \see change_scene
# \since 0.0.1
#------------------------------------------------------------------------------#
func _deferred_change_scene( path ):	
	debug.log_it( "[" + get_name() + "] freeing current scene (" + get_tree().get_current_scene().get_name() + ")" )
	# Free the current scene, there is no risk here
	s_current.free()
	
	# Load new scene
	var s_instance = ResourceLoader.load( path )
	# Instance new scene
	s_current = s_instance.instance()
	# Add it to active scene ad child of root
	
	get_tree().get_root().add_child( s_current )
	# Optional, to make it compatible with the SceneTree.change_scene() API
	get_tree().set_current_scene( s_current )
	
	ui.hide_views()
	#ui.add_blurs()
	#ui.add_highlights()
	
	# Dev console toggle button for touch devices
	# It's instanced here because viewport size need to be known
	if OS.is_debug_build() and OS.has_touchscreen_ui_hint():
		s_current.add_child( load( "res://scenes/ui/btnConsoleToggle.tscn" ).instance() )
	
	if OS.is_debug_build():
		# Dev console
		s_current.add_child( load( "res://scenes/ui/panConsole.tscn" ).instance() )

#-#
# Will close the application without asking
#
# \since 0.0.1
#------------------------------------------------------------------------------#
func force_quit():
	get_tree().quit()
