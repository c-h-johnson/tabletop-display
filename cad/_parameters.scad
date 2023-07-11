margin = 1;

thickness = 2;

angle_screen = 45;

// aka internal volume
// considered as a minimum
size_inner = [
	120,
	70,
	40,
];

// does not include pcb
// ideally slightly larger (+2mm) x + y than the actual measurements because it might be off-center
size_display_module = [73, 26, 6.8];

// does not include lcd display or pins
size_display_pcb = [80, 36, 1.6];

separation_holes_display_x = 75;
separation_holes_display_y = 31;

size_mcu_x = 57;
size_mcu_y = 30.5;

height_standoff_mcu = 4;
diameter_standoff_mcu = 5;

separation_holes_mcu_x = 51.5;
separation_holes_mcu_y = 25;

// case screws
// M3 (socket cap)
diameter_head_case = 5.5;
diameter_hole_case = 3;
diameter_thread_case = 2.85;
size_z_screw_head_case = 3;

// minimum distance between the same points on the pattern
separation_grill = 10;
// width of the connecting struts
thickness_grill = 5;
