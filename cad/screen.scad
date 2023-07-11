use <MCAD/boxes.scad>

include <common.scad>

module _screen_case() {
	difference() {
		union() {
			case(size_case_display_inner, size_case_display_outer);
		}
		// lcd module cutout
		translate([0, 0, (size_display_module.z/2)-EPSILON]) {
			cube(size_display_module, center=true);
		}
		// remove unecessary wall at top
		translate([0, size_case_display_inner.y/2, ((size_case_display_outer.z+thickness)/2)+EPSILON]) {
			cube(size_case_display_inner, center=true);
		}
	}
}

module screen() {
	height_standoff = size_display_module.z;

	difference() {
		union() {
			_screen_case();
			screws_display() {
				cylinder(h=size_case_display_outer.z, d=diameter_standoff);
			}
			screws_screen() {
				cylinder(h=height_standoff, d=diameter_standoff);
			}
			// attach standoffs to case sides
			mirror([0, 1, 0]) {
				screws_screen(y=0) {
					length_cube_join = (size_case_display_inner.y - separation_holes_display_y) / 2;
					translate([0, length_cube_join/2, height_standoff/2]) {
						cube([diameter_standoff, length_cube_join, height_standoff], center=true);
					}
				}
			}
		}
		screws_display() {
			cylinder(h=size_case_display_outer.z+EPSILON, d=diameter_hole_case);
			translate([0, 0, -EPSILON]) {
				cylinder(h=size_z_screw_head_case, d=diameter_head_case);
			}
		}
		screws_screen() {
			translate([0, 0, thickness]) {
				cylinder(h=height_standoff, d=diameter_thread_case);
			}
		}
	}
}

screen();
