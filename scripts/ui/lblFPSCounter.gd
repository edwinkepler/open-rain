#------------------------------------------------------------------------------#
# FPS counter (can be added via debug console when app is running)
#
# \since 0.1.0
#------------------------------------------------------------------------------#
extends "res://scripts/singletons/ui.gd"

func _ready():
	var viewport_size = get_viewport_rect().size
	var size = self.rect_size
	self.rect_position = Vector2( viewport_size.x - size.x - 20, 20 )
	
	set_process( true )
	
	debug.log_it( "[" + get_name() + "] _ready() done" )

func _process( delta ):
	set_text( str( Engine.get_frames_per_second() ) )

#-#
# Will trigger when scene/node enter the tree
# \since 0.1.0
#------------------------------------------------------------------------------#
func _on_lblFPSCounter_enter_tree():
	debug.log_it( "[" + get_name() + "] _enter_tree() done" )

#-#
# Will trigger when scene/node exit the tree
# \since 0.1.0
#------------------------------------------------------------------------------#
func _on_lblFPSCounter_exit_tree():
	debug.log_it( "[" + get_name() + "] _exit_tree() done" )

