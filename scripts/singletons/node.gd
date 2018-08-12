#------------------------------------------------------------------------------#
# Singleton that is Node functionality, mainly animations and such
#
# \since 0.0.1
#------------------------------------------------------------------------------#
extends Node

# Flag indicating fading out
var f_fading_out = false
# Flag indicating fading in
var f_fading_in = false

# Flag indicating sliding out
var f_sliding_out = false
# Flag indicating sliding in
var f_sliding_in = false

# Node's name that called
var n_caller_name

# Fading speed constant
const FADING_SPEED = 0.15
# Sliding speed constant
const SLIDING_SPEED = 60

#-#
# Set if node should fade out
#
# \see set_fade_in
# \see process_fading
# \since 0.0.1
#------------------------------------------------------------------------------#
func set_fade_out( in_flag ):
	f_fading_out = in_flag

#-#
# Set if node should fade in
#
# \see set_fade_out
# \see process_fading
# \since 0.0.1
#------------------------------------------------------------------------------#
func set_fade_in( in_flag ):
	f_fading_in = in_flag

#-#
# Set if node should slide out
#
# \see set_slide_in
# \see process_sliding
# \since 0.0.1
#------------------------------------------------------------------------------#
func set_slide_out( in_flag ):
	f_sliding_out = in_flag

#-#
# Set if node should slide in
#
# \see set_slide_out
# \see process_sliding
# \since 0.0.1
#------------------------------------------------------------------------------#
func set_slide_in( in_flag ):
	f_sliding_in = in_flag

#-#
# Process fading accordingly to fading flags
#
# \see set_fade_in
# \see set_fade_out
# \since 0.0.1
#------------------------------------------------------------------------------#
func process_fading():
	if f_fading_out and self.modulate.a >= 0:
		self.modulate.a -= FADING_SPEED
		# Stop processing when opacity less/equal zero
		if self.modulate.a <= 0:
			self.modulate.a = 0
			self.visible = false
			debug.log_it( get_name() + " hidden" )
			set_fade_out( false )

	if f_fading_in and self.modulate.a < 1:
		self.visible = true
		self.modulate.a += FADING_SPEED
		# Stop processing when opacity less/equal 255
		if self.modulate.a >= 1:
			self.modulate.a = 1
			debug.log_it( get_name() + " shown" )
			set_fade_in( false )

#-#
# Process sliding accordingly to sliding flags
#
# \see set_slide_in
# \see set_slide_out
# \since 0.0.1
#------------------------------------------------------------------------------#
func process_sliding():
	var v_pos = self.rect_position
	var v_size = self.rect_size

	if f_sliding_out:
		if v_pos.y + v_size.x >= 0:
			self.rect_position = Vector2( 0, v_pos.y - SLIDING_SPEED )
		else:
			self.rect_position = Vector2( 0, -v_size.y )
			hide()
			f_sliding_out = false

	if f_sliding_in:
		show()
		if v_pos.y < 0:
			set_position( Vector2( 0, v_pos.y + SLIDING_SPEED ) )  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
		else:
			set_position( Vector2( 0, 0 ) )  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
			f_sliding_in = false

#-#
# If node is slade out then slade in and vice versa
#
# \see set_slide_in
# \see set_slide_out
# \see process_sliding
# \since 0.0.1
#------------------------------------------------------------------------------#
func toggle_sliding():
	var v_pos = get_position()  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
	var v_size = get_size()
	
	if v_pos.y == 0:
		f_sliding_out = true
	else:
		f_sliding_in = true

#-#
# Set callers name
#
# \since 0.0.1
#------------------------------------------------------------------------------#
func set_caller( in_node_name ):
	n_caller_name = in_node_name
