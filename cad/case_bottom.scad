use <MCAD/boxes.scad>

include <common.scad>

module case_bottom() {
	_size_cut = [
		size_case_display_outer.x + EPSILON,
		size_case_display_outer.y,
		sqrt((size_case_bottom_outer.z ^ 2) * 2),
	];
	_height_standoff_top = diameter_standoff/(2*tan((90-angle_screen)/2));
	_height_standoff_display_top = size_case_display_outer.z+_height_standoff_top;

	difference() {
		union() {
			case(size_case_bottom_inner, size_case_bottom_outer);
			transform_case_display() {
				// top one only needs the go as far as the pillar for the top
				screws_display(y=0) {
					cylinder(h=_height_standoff_display_top, d=diameter_standoff);
				}
				// extend the bottom one all the way
				mirror([0, 1, 0]) {
					screws_display(y=0) {
						cylinder(h=_size_cut.z+size_case_display_outer.z, d=diameter_standoff);
					}
				}
			}
			screws_case() {
				cylinder(h=size_case_bottom_outer.z, d=diameter_standoff);
			}
			screws_mcu() {
				cylinder(h=height_standoff_mcu, d=diameter_standoff_mcu);
			}
		}
		transform_case_display() {
			translate([0, 0, size_case_display_outer.z-(_size_cut.z/2)]) {
				cube(_size_cut, center=true);
			}
			screws_display(y=0) {
				cylinder(h=_height_standoff_display_top+diameter_standoff, d=diameter_thread_case);
			}
			mirror([0, 1, 0]) {
				screws_display(y=0) {
					cylinder(h=_size_cut.z+size_case_display_outer.z, d=diameter_thread_case);
				}
			}
		}
		// remove the protruding display screw standoffs
		translate([0, 0, _size_cut.z/-2]) {
			cube([size_case_bottom_outer.x+EPSILON, size_case_bottom_outer.y, _size_cut.z], center=true);
		}
		screws_case() {
			cylinder(h=size_case_bottom_outer.z+EPSILON, d=diameter_thread_case);
		}
		screws_mcu() {
			translate([0, 0, -thickness-EPSILON]) {
				cylinder(h=height_standoff_mcu+thickness+(EPSILON*2), d=diameter_thread_case);
			}
		}
		// mcu usb cutout
		translate([(size_case_inner.x+thickness)/2, position_mcu_y, size_cutout_usb_z/2]) {
			cube([thickness+EPSILON, 15, size_cutout_usb_z], center=true);
		}
		// grill back
		translate([0, (size_case_bottom_inner.y/-2)+EPSILON, thickness+(size_case_bottom_inner.z/2)]) {
			rotate([90, 0, 0]) {
				grill([size_case_bottom_inner.x-(diameter_standoff*2), size_case_bottom_inner.z, thickness+(EPSILON*2)], separation_grill, thickness_grill);
			}
		}
	}
}

case_bottom();
