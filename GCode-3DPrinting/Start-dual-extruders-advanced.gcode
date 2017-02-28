;- - - Custom G-code for dual extruder printing with FlashForge Creator Pro - - -
;- - - FOR USE IN COMBINATION WITH DUALSTRUSION POST-PROCESSING SCRIPT ONLY - - -
;- - - Using it without the script will result in the print failing horribly! - - -
;- - - by DrLex; 2016/09-2017/02. Released under Creative Commons Attribution License. - - -
; NOTE: it is advisable to ensure the left nozzle is clean (no oozed filament string)
; because the ‘chop’ operation might not work at the lower temperature.
;
;SUMMARY
;
;first layer temperature (right) = [first_layer_temperature_0]C
;first layer temperature (left) = [first_layer_temperature_1]C
;temperature (right) = [temperature_0]C
;temperature (left) = [temperature_1]C
;first layer bed temperature = [first_layer_bed_temperature]C
;bed temperature = [bed_temperature]C
;
;first layer height = [first_layer_height]mm
;layer height = [layer_height]mm
;z_offset = [z_offset]mm
;perimeters = [perimeters]
;fill density = [fill_density]
;infill every n layers = [infill_every_layers]
;skirts = [skirts]
;brim width = [brim_width]mm
;raft layers = [raft_layers]
;support material = [support_material]
;support material threshold = [support_material_threshold] degrees
;support material enforced for first n layers = [support_material_enforce_layers]
;support material extruder = [support_material_extruder]
;
;first layer speed = [first_layer_speed]
;perimeter speed = [perimeter_speed]mm/s
;small perimeter speed = [small_perimeter_speed]
;external perimeter speed = [external_perimeter_speed]
;infill speed = [infill_speed]mm/s
;solid infill speed = [solid_infill_speed]
;top solid infill speed = [top_solid_infill_speed]
;support material speed = [support_material_speed]mm/s
;gap fill speed = [gap_fill_speed]mm/s
;travel speed = [travel_speed]mm/s
;bridge speed = [bridge_speed]mm/s
;bridge flow ratio = [bridge_flow_ratio]
;slowdown if layer time is less than = [slowdown_below_layer_time]secs
;minimum print speed = [min_print_speed]mm/s
;
;bottom solid layers = [bottom_solid_layers]
;top solid layers = [top_solid_layers]
;
;
;EXTRUSION
;
;filament diameter (right) = [filament_diameter_0]mm
;nozzle diameter (right) = [nozzle_diameter_0]mm
;extrusion multiplier (right) = [extrusion_multiplier_0]
;filament diameter (left) = [filament_diameter_1]mm
;nozzle diameter (left) = [nozzle_diameter_1]mm
;extrusion multiplier (left) = [extrusion_multiplier_1]
;bridge flow ratio = [bridge_flow_ratio]
;extrusion axis = [extrusion_axis]
;extrusion width = [extrusion_width]mm
;first layer extrusion width = [first_layer_extrusion_width]mm
;perimeter extrusion width = [perimeter_extrusion_width]mm
;infill extrusion width = [infill_extrusion_width]mm
;solid infill extrusion width = [solid_infill_extrusion_width]mm
;top infill extrusion width = [top_infill_extrusion_width]mm
;support material extrusion width = [support_material_extrusion_width]mm
;
;
;SUPPORT
;
;raft layers = [raft_layers]
;brim width = [brim_width]mm
;support material = [support_material]
;support material threshold = [support_material_threshold] degrees
;support material enforced for first n layers = [support_material_enforce_layers]
;support material extruder = [support_material_extruder]
;support material extrusion width = [support_material_extrusion_width]mm
;support material interface layers = [support_material_interface_layers]
;support material interface spacing = [support_material_interface_spacing]mm
;support material pattern = [support_material_pattern]
;support material angle = [support_material_angle] degrees
;support material spacing = [support_material_spacing]mm
;support material speed = [support_material_speed]mm/s
;
;
;EVERYTHING ELSE
;
;complete objects = [complete_objects]
;cooling enabled = [cooling]
;default acceleration = [default_acceleration]mm/s/s
;disable fan for first layers = [disable_fan_first_layers]
;duplicate distance = [duplicate_distance]mm
;external perimeters first = [external_perimeters_first]
;extra perimeters = [extra_perimeters]
;extruder clearance height = [extruder_clearance_height]mm
;extruder clearance radius = [extruder_clearance_radius]mm
;extruder offset = [extruder_offset]mm
;fan always on = [fan_always_on]
;fan below layer time = [fan_below_layer_time]secs
;fill angle = [fill_angle] degrees
;fill pattern = [fill_pattern]
;gcode arcs = [gcode_arcs]
;gcode comments = [gcode_comments]
;gcode flavor = [gcode_flavor]
;infill acceleration = [infill_acceleration]mm/s/s
;infill extruder = [infill_extruder]
;infill first = [infill_first]
;infill only where needed = [infill_only_where_needed]
;minimum skirt length = [min_skirt_length]mm
;only retract when crossing perimeters = [only_retract_when_crossing_perimeters]
;perimeter acceleration = [perimeter_acceleration]mm/s/s
;perimeter extruder = [perimeter_extruder]
;seam position = [seam_position]
;resolution = [resolution]mm
;retract before travel (right) = [retract_before_travel_0]
;retract on layer change (right) = [retract_layer_change_0]
;retract length (right) = [retract_length_0]mm
;retract length on tool change (right) = [retract_length_toolchange_0]mm
;retract lift (right) = [retract_lift_0]
;retract extra distance on restart (right) = [retract_restart_extra_0]mm
;retract extra on tool change (right) = [retract_restart_extra_toolchange_0]mm
;retract speed (right) = [retract_speed_0]mm/s
;retract before travel (left) = [retract_before_travel_1]
;retract on layer change (left) = [retract_layer_change_1]
;retract length (left) = [retract_length_1]mm
;retract length on tool change (left) = [retract_length_toolchange_1]mm
;retract lift (left) = [retract_lift_1]
;retract extra distance on restart (left) = [retract_restart_extra_1]mm
;retract extra on tool change (left) = [retract_restart_extra_toolchange_1]mm
;retract speed (left) = [retract_speed_1]mm/s
;rotate = [rotate] degrees
;scale = [scale]
;skirt distance = [skirt_distance]mm
;skirt height = [skirt_height]mm
;top/bottom fill pattern = [external_fill_pattern]
;solid infill below area = [solid_infill_below_area]mm (sq)
;solid infill every n layers = [solid_infill_every_layers]
;
;
;- - - - - - - - - - - - - - - - - - - - - - - - -
;
;
T0; set primary extruder
; Although we will first initialise the left extruder, do not do a tool change until everything is ready to avoid all kinds of quirks.
M73 P0; enable show build progress
M140 S[first_layer_bed_temperature] T0; heat bed up to first layer temperature
M104 S140 T0; preheat right nozzle to 140 degrees, this should not cause oozing
M104 S140 T1; preheat left nozzle to 140 degrees, this should not cause oozing
M127; disable fan
G21; set units to mm
M320; acceleration enabled for all commands that follow
G162 X Y F9000; home XY axes maximum
G161 Z F1500; roughly home Z axis minimum
G92 X0 Y0 Z0 E0 B0; set (rough) reference point (also set E and B to make GPX happy)
G1 Z5 F1500; move the bed down again
G4 P0; Wait for command to finish
G161 Z F100; accurately home Z axis minimum
G92 Z0; set accurate Z reference point
M132 X Y Z A B; Recall stored home offsets
G90; set positioning to absolute
G1 Z20 F1500; move Z to waiting height
G1 X135 Y75 F1500; do a slow small move because the first move is likely not accelerated
G1 X-70 Y-81 F10000; move to waiting position (front left corner of print bed), also makes room for the tool change
G1 F6000; set speed for tool change (see ToolChange.gcode for explanation)
M18 Z E; disable Z and extruder steppers while heating
M6 T0; wait for bed (and right extruder) to heat up
M104 S[first_layer_temperature_0] T0; set 1st nozzle heater to first layer temperature
M6 T0; wait for right extruder to heat up
M17; re-enable all steppers
G4 P0; flush pipeline
; Initialise the left extruder partially. We won't prime it, that should happen through the priming tower.
; We leave it at 140 degrees so it won't ooze all across the first layer(s) while T0 is printing.
T1; Tool change to left extruder
G4 P0; flush pipeline
; I have tried to do a proper tool change retract on the nozzle, but this consistently resulted in unacceptable
; extrusion lag afterwards, maybe because the firmware performs an additional retraction?
G92 E-0.8; Therefore I simply gave up and use the same trick as for single extrusion, which proves to work best.
G1 F6000; set speed for tool change (see ToolChange.gcode for explanation)
T0; switch back to right extruder.
G4 P0; flush pipeline
G1 Z0 F1500
G1 X-70 Y-73 F4000; chop off any ooze on the front of the bed
G1 Z[first_layer_height] F1500; move to first layer height
G92 E0; set extrusion zero reference
G1 X121 Y-73 E24 F2000; extrude a line of filament across the front edge of the bed using right extruder
; Note how we extrude a little beyond the bed, this produces a tiny loop that allows to manually remove the extruded strip.
G1 Z0 F1500; lower nozzle height to 0
G1 X105 F4000; wipe nozzle on edge of bed
G92 E-0.6; should set reference to 0 here, but deliberately cause a little over-extrusion to combat typical extruder lag at the start of the actual print.
G1 Z[first_layer_height] F1500; set nozzle to first layer height
G1 F14000; in case Slic3r would not override this, ensure fast travel to first print move
M73 P1 ;@body (notify GPX body has started)
;- - - End custom G-code for dual extruder printing - - -
