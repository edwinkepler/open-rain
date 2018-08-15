#------------------------------------------------------------------------------#
# Dropdown debug console
#
# \since 0.1.0
#------------------------------------------------------------------------------#
extends "res://scripts/singletons/node.gd"

var arr_commands = []
var s_unknown = "unknown command: "
var s_cmd_dcfg = "del_cfg" #delete config file
var s_cmd_dmem = "dump_mem" #save memory dump
var s_cmd_dout = "dump_out" #save output
var s_cmd_dres = "dump_res" #save resources dump
var s_cmd_mouse_pos = "mouse_pos" #prints current mouse position
var s_cmd_fps = "fps" #shows fps counter
var s_cmd_gresolutions = "get_res"
var s_cmd_help = "help" #prints out all commands
var s_cmd_playground = "playground" #start up playground env
var s_cmd_print_tree = "print_tree" #print_tree()
var s_cmd_screenshot = "screenshot" #saves screenshot
var s_cmd_quit = "quit" #terminating application

func _ready():
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		set_size( Vector2( vars.v_viewport_size.x, vars.v_viewport_size.y * 0.30 ) )
	else:
		set_size( Vector2( vars.v_viewport_size.x, vars.v_viewport_size.y * 0.75 ) )

	var v_con_size = self.rect_size
	get_node( "BlurBG" ).rect_size = self.rect_size

	find_node( "txtOutput" ).set_readonly( true )
	find_node( "txtOutput" ).set_focus_mode( 1 )
	find_node( "txtOutput" ).insert_text_at_cursor( "Debug console" )

	set_process( true )
	set_process_input( true )
	self.rect_position = Vector2( 0, -v_con_size.x )
	hide()

	debug.print_buffer_to_console()

	find_node( "txtOutput" ).cursor_set_line( find_node( "txtOutput" ).get_line_count(), true, true )

	arr_commands.push_back( s_cmd_dcfg )
	arr_commands.push_back( s_cmd_dmem )
	arr_commands.push_back( s_cmd_dout )
	arr_commands.push_back( s_cmd_dres )
	arr_commands.push_back( s_cmd_mouse_pos )
	arr_commands.push_back( s_cmd_fps )
	arr_commands.push_back( s_cmd_gresolutions )
	arr_commands.push_back( s_cmd_help )
	arr_commands.push_back( s_cmd_playground )
	arr_commands.push_back( s_cmd_print_tree )
	arr_commands.push_back( s_cmd_screenshot )
	arr_commands.push_back( s_cmd_quit )

func _process( delta ):
	process_sliding()

func _input( event ):
	if OS.is_debug_build() == true and event.is_action_pressed( "debug_console" ) and not event.is_echo():
		if get_tree().is_paused():
			get_tree().set_pause( false )
		else:
			get_tree().set_pause( true )
		
		toggle_sliding()

	if event.is_action_pressed( "ui_accept" ) and find_node( "ledCommand" ).has_focus() and find_node( "ledCommand" ).get_text() != '':
		parse_command( find_node( "ledCommand" ).get_text() )
		find_node( "ledCommand" ).clear()

func parse_command( cmd ):
	if s_cmd_dcfg.is_subsequence_ofi( cmd ):
		var dir = Directory.new()
		dir.remove_and_collide( "user://settings.cfg" )  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
		debug.log_it( "Settings file deleted" )
	elif s_cmd_dmem.is_subsequence_ofi( cmd ):
		prepare_debug_dir()
		save_memory_dump()
	elif s_cmd_dout.is_subsequence_ofi( cmd ):
		prepare_debug_dir()
		save_console_output()
	elif s_cmd_dres.is_subsequence_ofi( cmd ):
		prepare_debug_dir()
		save_res_dump()
	elif s_cmd_mouse_pos.is_subsequence_ofi( cmd ):
		var v_mouse_pos = get_viewport().get_mouse_position()  #-- NOTE: Automatically converted by Godot 2 to 3 converter, please review
		debug.log_it( "Current mouse position (" + str( v_mouse_pos.x ) + ", " + str( v_mouse_pos.y ) + ")" )
	elif s_cmd_fps.is_subsequence_ofi( cmd ):
		if get_parent().get_node( "UI" ).has_node( "lblFPSCounter" ):
			get_parent().get_node( "UI" ).get_node( "lblFPSCounter" ).free()
		else:
			get_parent().get_node( "UI" ).add_child( load( "res://scenes/ui/lblFPSCounter.tscn" ).instance() )
	elif s_cmd_gresolutions.is_subsequence_ofi( cmd ):
		var arr_res = OS.get_fullscreen_mode_list( 0 )
		for i in arr_res:
			print( str( i ) )
	elif s_cmd_help.is_subsequence_ofi( cmd ):
		debug.log_it( "available commands: " )
		for i in arr_commands:
			debug.log_it( "\t" + i )
	elif s_cmd_playground.is_subsequence_ofi( cmd ):
		app.change_scene( "res://scenes/levels/playground.scn" )
	elif s_cmd_print_tree.is_subsequence_ofi( cmd ):
		# @TODO make it possible to pass it to debug.log_it() 
		get_parent().print_tree()
	elif s_cmd_screenshot.is_subsequence_ofi( cmd ):
		get_parent().get_node( "panConsole" ).hide()
		get_viewport().queue_screen_capture()
		yield( get_tree(), "idle_frame" )
		yield( get_tree(), "idle_frame" )
		var img_scr = get_viewport().get_screen_capture()
		get_parent().get_node( "panConsole" ).show()
		img_scr.save_png( "user://" + "screenshot_" + get_datetime_string() + ".png" )
		debug.log_it( "Screenshot saved in " + OS.get_data_dir() + "/screenshot_" + get_datetime_string() + ".png" )
	elif s_cmd_quit.is_subsequence_ofi( cmd ):
		app.force_quit()
	else:
		debug.log_it( s_unknown + cmd )

func get_datetime_string():
	var datestamp	= OS.get_datetime()
	var hour		= str( datestamp.hour )
	if hour.length() < 2:
		hour = "0" + hour
	var minute		= str( datestamp.minute )
	if minute.length() < 2:
		minute = "0" + minute
	var second		= str( datestamp.second )
	if second.length() < 2:
		second = "0" + second
	var day			= str( datestamp.day )
	if day.length() < 2:
		day = "0" + day
	var month		= str( datestamp.month )
	if month.length() < 2:
		month = "0" + month
	var year		= str( datestamp.year )
	return hour + minute + second + "_" + day + month + year

func prepare_debug_dir():
	var dir = Directory.new()
	if dir.dir_exists( "user://debug" ) == false:
		if dir.make_dir( "user://debug" ) != OK:
			debug.log_it( "Can't create user://debug dir. Error code: " + str( Directory.make_dir( "user://debug" ) ) )

func save_memory_dump():
	OS.dump_memory_to_file( "user://debug/mem_" + get_datetime_string() + ".txt" )

func save_res_dump():
	OS.dump_resources_to_file( "user://debug/res_" + get_datetime_string() + ".txt" )

func save_console_output():
	var file_out = File.new()
	file_out.open( "user://debug/out_" + get_datetime_string() + ".txt", file_out.WRITE )
	file_out.store_string( find_node( "txtOutput" ).get_text() )

	if file_out.get_error() != 0:
		debug.log_it( "Can't save file. Error code: " + str ( file_out.get_error() ) )
	else:
		debug.log_it( "Console output saved in " + OS.get_data_dir() + "/debug/out_" + get_datetime_string() + ".txt" )

	file_out.close()

func _on_txtOutput_text_changed():
	find_node( "txtOutput" ).cursor_set_line( find_node( "txtOutput" ).get_line_count(), true, true )

func _on_panConsole_visibility_changed():
	#Set focus on line edit when console is shown
	if is_visible():
		find_node( "ledCommand" ).clear()
		find_node( "ledCommand" ).grab_focus()

func _on_btnEnter_pressed():
	if find_node( "ledCommand" ).get_text() != '':
		parse_command( find_node( "ledCommand" ).get_text() )
		find_node( "ledCommand" ).clear()

func _on_txtOutput_focus_entered():
	find_node("ledCommand").grap_focus();
