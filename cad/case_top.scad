use <MCAD/boxes.scad>

include <common.scad>

module case_top() {
	_size_cut = [
		size_case_display_outer.x + EPSILON,
		size_case_display_outer.y + EPSILON,
		size_case_outer.y + EPSILON,
	];

	difference() {
		union() {
			case(size_case_top_inner, size_case_top_outer);
			// small join to avoid gap between the display case and the rest of the case at the top
			transform_case_top() {
				transform_case_display() {
					translate([0, (size_case_display_outer.y-radius_case_corner_outer)/2, size_case_display_outer.z/2]) {
						cube([size_case_display_outer.x, radius_case_corner_outer, size_case_display_outer.z], center=true);
					}
				}
			}
			screws_case() {
				cylinder(h=size_case_top_outer.z, d=diameter_standoff);
			}
		}
		transform_case_top() {
			transform_case_display() {
				translate([0, 0, size_case_display_outer.z-(_size_cut.z/2)+EPSILON]) {
					// TODO `roundedCube` in new version of MCAD
					roundedBox(_size_cut, radius_case_corner_outer, true);
				}
				translate([0, 0, _size_cut.z/-2]) {
					cube(_size_cut, center=true);
				}
			}
		}
		screws_case() {
			cylinder(h=size_case_top_outer.z+EPSILON, d=diameter_hole_case);
			translate([0, 0, -EPSILON]) {
				cylinder(h=size_z_screw_head_case, d=diameter_head_case);
			}
		}
	}
}

case_top();
