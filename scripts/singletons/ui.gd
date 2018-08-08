#------------------------------------------------------------------------------#
# Singleton for preparing UI and such
#
# \since 0.0.1
#------------------------------------------------------------------------------#
extends Node

#-#
# Nothing
#
# \since 0.0.1
#------------------------------------------------------------------------------#
func _ready():
	debug.log_it( "[" + get_name() + "] _ready() done" )

#-#
# Change size of a view node and put it in a center of a viewport (screen)
#
# \arg in_node Node that should be centered (main node of a view)
#
# \since 0.0.1
#------------------------------------------------------------------------------#
func put_view_on_center( in_node ):
	var i_height = vars.v_viewport_size.y - vars.int_view_margin_y
	var i_width = vars.v_viewport_size.x - vars.int_view_margin_x
	in_node.rect_size = Vector2( i_width, i_height )
	in_node.rect_position = Vector2( vars.int_view_margin_x / 2, vars.int_view_margin_y / 2 )

#-#
# Will hide all views. Call it when new scene is loaded
#
# \since 0.0.1
#------------------------------------------------------------------------------#
func hide_views():
	var arr_views = get_tree().get_nodes_in_group( "View" )

	for i in range( arr_views.size() ):
		arr_views[ i ].modulate.a = 0
		arr_views[ i ].hide()

#-#
# Free (remove) all node when view is changed
#
# \more
#	Some nodes need to be removed when tab is changed or view or modal closed 
#	or such. Call it on visibility change or whatever.
#
# \since 0.0.1
#------------------------------------------------------------------------------#
func free_on_view_change():
	var arr_n_to_free = get_tree().get_nodes_in_group( "FreeOnViewChange" )

	for i in range( arr_n_to_free.size() ):
		arr_n_to_free[ i ].queue_free()

#-#
# Calls deferred_add_highlights
#
# \see deferred_add_highlights
# \since 0.0.1
#------------------------------------------------------------------------------#
func add_highlights():
	call_deferred( "deferred_add_highlights" )

#-#
# Every node in AddHighlight group will
#
# \since 0.0.1
#------------------------------------------------------------------------------#
func deferred_add_highlights():
	debug.log_it( "[" + get_name() + "] Adding highlights" )
	var arr_highlights = get_tree().get_nodes_in_group( "AddHighlight" )

	for i in range( arr_highlights.size() ):
		# New panel node that will work as a highlight
		var n_highlight = Panel.new()
		n_highlight.set_name( arr_highlights[ i ].get_name() + "Highlight" )
		n_highlight.set_theme( load( "res://assets/themes/ui_theme.tres" ) )
		n_highlight.set_draw_behind_parent( true )

		n_highlight.connect( "mouse_entered", self, "_highlight_show", [ n_highlight ], 1 )
		n_highlight.connect( "mouse_exited", self, "_highlight_hide", [ n_highlight ], 1 )
		n_highlight.connect( "gui_input", self, "_highlight_pressed", [ arr_highlights[ i ] ], 1 )

		n_highlight.modulate.a = 0

		arr_highlights[ i ].add_child( n_highlight )
		arr_highlights[ i ].move_child( n_highlight, 0 )

		#-#
		# Because highlight is behid the parent but still we want to keep sliders 
		# operating we need to emit mouse enter signal when mouse is above slider to keep highlight visible.
		#------------------------------------------------------------------------------#

		# Check children for Slider type and if there is one then connect signal for mouse enter
		if arr_highlights[ i ].get_child( 1 ).get_child( 1 ).get_class() == "HSlider":
			arr_highlights[ i ].get_child( 1 ).get_child( 1 ).connect( "mouse_entered", self, "_highlight_show", [ n_highlight ], 1 )
			arr_highlights[ i ].get_child( 1 ).get_child( 1 ).connect( "mouse_exited", self, "_highlight_hide", [ n_highlight ], 1 )

		debug.log_it( "[" + get_name() + "] " + arr_highlights[ i ].get_name() + " added" )

#-#
# Calls deferred_add_blurs. Deprecated. Don't use. Remove it.
#
# \see deferred_add_blurs
# \deprecated
# \since 0.0.1
#------------------------------------------------------------------------------#
func add_blurs():
	call_deferred( "deferred_add_blurs" )

#-#
# Add blur backgrounds to nodes that are in AddBlurBG group
#
# \see deferred_add_blurs
# \since 0.0.1
#------------------------------------------------------------------------------#
func deferred_add_blurs():
	var arr_blur = get_tree().get_nodes_in_group( "AddBlurBG" )
	
	for i in range( arr_blur.size() ):
		debug.log_it( "[" + get_name() + "] Adding blur to " + arr_blur[ i ].get_name() )
		# Texture frame that will work as a blur background
		var n_tex_blur = TextureRect.new()
		n_tex_blur.set_name( arr_blur[ i ].get_name() + "BlurBGTexture" )
		n_tex_blur.expand = true
		n_tex_blur.set_texture( load( "res://.import/white.png-5a24addff47c5cf030d8933848d133b0.stex" ) )
		n_tex_blur.set_material( load( "res://assets/materials/blur.shader" ) )
		n_tex_blur.show_behind_parent = true
		arr_blur[ i ].add_child( n_tex_blur )
		n_tex_blur.rect_size = arr_blur[ i ].rect_size
		debug.log_it( "[" + get_name() + "] Blur parent size: " + str( arr_blur[ i ].rect_size ) )
		debug.log_it( "[" + get_name() + "] Blur size: " + str( n_tex_blur.rect_size ) )

#-#
# Showing highlight emitted on mouse enter signal
#
# \arg in_node Highlight node to be shown
#
# \see _highlight_hide
# \since 0.0.1
#------------------------------------------------------------------------------#
func _highlight_show( in_node ):
	in_node.rect_position = Vector2( -10, -5 )
	in_node.rect_size = Vector2( in_node.get_parent().get_size().x + 20, in_node.get_parent().get_size().y + 10 )
	in_node.modulate.a = 1

#-#
# Hiding highlight emitted on mouse leave signal
#
# \arg in_node Highlight node to be hidden
#
# \see _highlight_show
# \since 0.0.1
#------------------------------------------------------------------------------#
func _highlight_hide( in_node ):
	in_node.modulate.a = 0

#-#
# Handles interactions with controls
#
# \arg event Array of events
# \arg in_node Node (highlight) that have been evented
#
# \since 0.0.1
#------------------------------------------------------------------------------#
func _highlight_pressed( event, in_node ):
	if event is InputEventMouseButton:  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
		if event.button_index == BUTTON_LEFT and event.pressed:

			# Scan every child node and look for particular node types to control
			var n_child_to_control = in_node.get_child( 1 ).get_children()
			for i in range( n_child_to_control.size() ):

				# CheckButton
				if n_child_to_control[ i ].get_class() == "CheckButton":
					# Just toggle checkbox
					if n_child_to_control[ i ].is_pressed():
						n_child_to_control[ i ].set_pressed( false )
						n_child_to_control[ i ].emit_signal( "toggled", false )
					else:
						n_child_to_control[ i ].set_pressed( true )
						n_child_to_control[ i ].emit_signal( "toggled", true )
				
				# OptionButton
				elif n_child_to_control[ i ].get_class() == "OptionButton":
					# Hide highlight by emiting mouse exit signal to highlight panel node
					in_node.get_child( 0 ).emit_signal( "mouse_exit" )

					# OptionButton (dropdown combo) need a new panel to show list of options
					# and panel for area to close newly created dropdown panel

					# Panel for a list of OpetionButton content
					var n_dropdown_content = Panel.new()
					n_dropdown_content.set_name( "pan" + n_child_to_control[ i ].get_name() + "DropdownContent" )
					n_dropdown_content.set_theme( load( "res://assets/themes/ui_theme.tres" ) )
					n_dropdown_content.add_to_group( "FreeOnViewChange" )
					
					# Panel for a area that will close dropdown when clicked
					var n_dropdown_close = Panel.new()
					n_dropdown_close.set_name( "pan" + n_child_to_control[ i ].get_name() + "DropdownClose" )
					n_dropdown_close.set_theme( load( "res://assets/themes/ui_theme.tres" ) )
					n_dropdown_close.add_to_group( "FreeOnViewChange" )

					# Container for dropdown list
					var n_dropdown_container = VBoxContainer.new()
					n_dropdown_container.set_name( "VBox" + n_child_to_control[ i ].get_name() + "DropdownContainer" )
					n_dropdown_container.set_v_size_flags( 2 )
					n_dropdown_container.set_h_size_flags( 3 )
					n_dropdown_container.set( "custom_constants/separation", 0 )
					n_dropdown_content.add_child( n_dropdown_container )

					# Create list of OptionButton elements
					for j in range( n_child_to_control[ i ].get_item_count() ):
						# Label with list item from OptionButton
						var n_dropdown_list_item = Button.new()
						n_dropdown_list_item.set_name( "lbl" + n_child_to_control[ i ].get_item_text( j ) + "DropdownItem" )
						n_dropdown_list_item.set_text( n_child_to_control[ i ].get_item_text( j ) )
						n_dropdown_list_item.set_v_size_flags( 2 )
						n_dropdown_list_item.set_h_size_flags( 3 )
						n_dropdown_list_item.set_custom_minimum_size( Vector2( 200, 40 ) )

						n_dropdown_list_item.connect( "pressed", self, "_dropdown_item_pressed", [ n_child_to_control[ i ], j, n_dropdown_content, n_dropdown_close ], 1 )

						n_dropdown_container.add_child( n_dropdown_list_item )

					n_child_to_control[ i ].get_owner().add_child( n_dropdown_content )
					n_child_to_control[ i ].get_owner().add_child( n_dropdown_close )
					
					# Search for a node where dropdown should be placed
					var arr_dropdown_space = get_tree().get_nodes_in_group( "ComboDropdownSpace" )
					# Node to which dropdown will be fixed
					var n_dropdown_space
					for j in range( arr_dropdown_space.size() ):
						if arr_dropdown_space[ j ].get_owner() == n_child_to_control[ j ].get_owner():
							n_dropdown_space = arr_dropdown_space[ j ]
					
					n_dropdown_content.rect_size = Vector2( 200, n_dropdown_space.get_size().y )
					n_dropdown_content.rect_position = Vector2( n_dropdown_space.get_global_position().x + n_dropdown_space.get_size().x - n_dropdown_content.get_size().x, n_dropdown_space.get_global_position().y )

					n_dropdown_close.rect_size = Vector2( n_dropdown_space.get_size().x - n_dropdown_content.get_size().x, n_dropdown_space.get_size().y )
					n_dropdown_close.rect_position = n_dropdown_space.get_global_position()

					n_dropdown_close.connect( "input_event", self, "_dropdown_close_pressed", [ n_dropdown_content, n_dropdown_close ], 1 )

#-#
# Method for killing dropdown menu created by highlight panel
#
# \more Dropdown will be killed and removed from tree
#
# \see _highlight_show
# \since 0.0.1
#------------------------------------------------------------------------------#
func _dropdown_close_pressed( event, in_node_content, in_node_close ):
	if event is InputEventMouseButton:  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
		if event.button_index == BUTTON_LEFT and event.pressed:
			in_node_content.queue_free()
			in_node_close.queue_free()

#-#
# Method for handling dropdown item click
#
# \more
#	After dropdown item click whole dropdown will be removed from tree and 
#	OptionButton will change its selected item.
#
# \arg in_node_optionbutton OptionButton node that will change its selected value
# \arg in_int Integer value for OptionButton to be changed
# \arg in_node_content Dropdown content node (node with dropdown)
# \arg in_node_close Node that works as area to close dropdown
#
# \see _highlight_pressed
# \since 0.0.1
#------------------------------------------------------------------------------#
func _dropdown_item_pressed( in_node_optionbutton, in_int, in_node_content, in_node_close ):
	in_node_optionbutton.select( in_int )
	in_node_optionbutton.emit_signal( "item_selected", in_int )
	in_node_content.queue_free()
	in_node_close.queue_free()
