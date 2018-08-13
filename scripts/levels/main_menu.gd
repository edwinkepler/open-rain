#------------------------------------------------------------------------------#
# Game main menu scene (level)
#
# \since 0.1.0
#------------------------------------------------------------------------------#
extends Node

#-#
# Add ui widgets, sound, music and background
#
# \since 0.1.0
#------------------------------------------------------------------------------#
func _ready():
	debug.log_it( "[" + get_name() + "] Creating UI" )
	# Add music
	add_child( load( "res://scenes/ui/musMusicPlayer.tscn" ).instance() )
	# Add sounds sampler
	add_child( load( "res://scenes/ui/sndUISampler.tscn" ).instance() )
	# Add main menu
	get_node( "UI" ).add_child( load( "res://scenes/ui/panMainMenu.tscn" ).instance() )
	get_node( "UI" ).add_child( load( "res://scenes/ui/panNewGame.tscn" ).instance() )
	get_node( "UI" ).add_child( load( "res://scenes/ui/panContinue.tscn" ).instance() )
	get_node( "UI" ).add_child( load( "res://scenes/ui/panSettings.tscn" ).instance() )
	get_node( "UI" ).add_child( load( "res://scenes/ui/panCredits.tscn" ).instance() )
	get_node( "UI" ).add_child( load( "res://scenes/ui/panExtras.tscn" ).instance() )
	get_node( "UI" ).add_child( load( "res://scenes/ui/panQuitModal.tscn" ).instance() )

	#get_node( "musMusicPlayer" ).play()
	
	debug.log_it( "[" + get_name() + "] _ready() done" )

#-#
# Will trigger when scene/node enter the tree
#
# \since 0.1.0
#------------------------------------------------------------------------------#
func _on_main_menu_enter_tree():
	debug.log_it( "[" + get_name() + "] _enter_tree() done" )

#-#
# Will trigger when scene/node exit the tree
#
# \since 0.1.0
#------------------------------------------------------------------------------#
func _on_main_menu_exit_tree():
	debug.log_it( "[" + get_name() + "] _exit_tree() done" )

