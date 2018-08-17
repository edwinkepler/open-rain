#------------------------------------------------------------------------------#
# Game settings view
#
# \since 0.1.0
#------------------------------------------------------------------------------#
extends "res://scripts/singletons/node.gd"

#-#
# Prepare everything
#
# \since 0.1.0
#------------------------------------------------------------------------------#
func _ready():
	set_process( true )
	set_process_input( true )
	
	debug.log_it( "[" + get_name() + "] _ready() done" )

#-#
# Handle processing
#
# \since 0.1.0
#------------------------------------------------------------------------------#
func _process( delta ):
	process_fading()

#-#
# Will trigger when scene/node enter the tree
#
# \since 0.1.0
#------------------------------------------------------------------------------#
func _on_panContinue_enter_tree():
	debug.log_it( "[" + get_name() + "] _enter_tree() done" )

#-#
# Will trigger when scene/node exit the tree
#
# \since 0.1.0
#------------------------------------------------------------------------------#
func _on_panContinue_exit_tree():
	debug.log_it( "[" + get_name() + "] _exit_tree() done" )

