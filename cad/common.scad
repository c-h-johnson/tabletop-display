use <MCAD/multiply.scad>

include <parameters.scad>

// number of fragments
$fn = $preview ? 32 : 128;

// When a small distance is needed to overlap shapes for boolean cutting, etc.
EPSILON = $preview ? 0.02 : 0;

function outer(dim) = dim + [thickness*2, thickness*2, thickness];

diameter_standoff = diameter_thread_case + (thickness * 2);

size_display = size_display_pcb + [0, 0, size_display_module.z];

size_case_display_inner = [
	max(size_inner.x, size_display_pcb.x+(margin*2)),
	size_display_pcb.y+(margin*2),
	size_display.z-thickness
];
size_case_display_outer = outer(size_case_display_inner);

offset_case_display_y = (size_case_display_outer.y * sin(angle_screen) * 0.5) - (size_case_display_outer.z * cos(angle_screen));
_size_case_bottom_z = size_case_display_outer.y * cos(angle_screen);
_size_case_top_z = size_case_display_outer.z * sin(angle_screen);

size_case_top_inner_z = _size_case_top_z-thickness;

_size_case_bottom_adjusted_z = _size_case_bottom_z + _size_case_top_z - (thickness * 2) < size_inner.z ? (size_inner.z - _size_case_top_z) + (thickness * 2) : _size_case_bottom_z;

size_case_bottom_inner_z = _size_case_bottom_adjusted_z-thickness;

offset_screws_case_y = size_case_display_outer.y * sin(angle_screen);

size_case_inner = [
	size_case_display_inner.x,
	max(size_inner.y, offset_screws_case_y+((diameter_standoff+margin-thickness)*2)+size_mcu_y),
	size_case_bottom_inner_z + size_case_top_inner_z
];
size_case_outer = size_case_inner + [thickness*2, thickness*2, thickness*2];

size_case_top_inner = [size_case_inner.x, size_case_inner.y, size_case_top_inner_z];
echo("top height inner", size_case_top_inner.z);
size_case_top_outer = outer(size_case_top_inner);

size_case_bottom_inner = [size_case_inner.x, size_case_inner.y, size_case_bottom_inner_z];
echo("bottom height inner", size_case_bottom_inner.z);
size_case_bottom_outer = outer(size_case_bottom_inner);

radius_case_corner_inner = margin;
radius_case_corner_outer = radius_case_corner_inner + thickness;

position_mcu_y = (size_case_outer.y/2)-offset_screws_case_y-diameter_standoff-margin-(size_mcu_y/2);

size_cutout_usb_z = thickness + height_standoff_mcu + 5;

module mirror_copy(x=0, y=0, z=0) {
	children();
	mirror([x, y, z]) {
		children();
	}
}

module case(size_inner, size_outer) {
	difference() {
		union() {
			translate([0, 0, size_outer.z/2]) {
				// TODO `roundedCube` in new version of MCAD
				roundedBox(size_outer, radius_case_corner_outer, true);
			}
		}
		translate([0, 0, (size_outer.z/2)+thickness]) {
			// TODO `roundedCube` in new version of MCAD
			roundedBox([size_inner.x, size_inner.y, size_outer.z], radius_case_corner_inner, true);
		}
	}
}

module screws(separation_x, separation_y, x=1, y=1) {
	mirror_copy(x=x) {
		mirror_copy(y=y) {
			translate([separation_x/2, separation_y/2, 0]) {
				children();
			}
		}
	}
}

module screws_display(x=1, y=1) {
	screws(size_case_display_outer.x-diameter_standoff, size_case_display_outer.y-diameter_standoff, x=x, y=y) {
		children();
	}
}

module screws_screen(x=1, y=1) {
	screws(separation_holes_display_x, separation_holes_display_y, x=x, y=y) {
		children();
	}
}

module screws_case() {
	translate([0, offset_screws_case_y/-2, 0]) {
		screws(size_case_outer.x-diameter_standoff, size_case_outer.y-offset_screws_case_y-diameter_standoff) {
			children();
		}
	}
}

module screws_mcu() {
	translate([((size_case_inner.x-size_mcu_x)/2)-margin, position_mcu_y, thickness]) {
		screws(separation_holes_mcu_x, separation_holes_mcu_y) {
			children();
		}
	}
}

module transform_case_display() {
	translate([0, (size_case_bottom_outer.y/2)-offset_case_display_y, size_case_outer.z-(_size_case_bottom_z/2)]) {
		rotate([90+angle_screen, 0, 0]) {
			children();
		}
	}
}

module transform_case_top() {
	translate([0, 0, size_case_outer.z]) {
		mirror([0, 0, 1]) {
			children();
		}
	}
}

module _grill(size, separation, thickness) {
	_no = ceil(sqrt((max(size.x, size.y)^2)*2)/separation)+1;
	_size_hole = separation-thickness;
	rotate([0, 0, -45]) {
		linear_multiply(_no, separation, [0, 1, 0]) {
			linear_multiply(_no, separation, [1, 0, 0]) {
				translate([0, 0, size.z/2]) {
					cube([_size_hole, _size_hole, size.z], center=true);
				}
			}
		}
	}
	
}

module grill(size, separation, thickness) {
	translate([size.x/-2, size.y/-2, 0]) {
		intersection() {
			union() {
				_grill(size, separation, thickness);
				mirror([-1, 1, 0]) {
					_grill(size, separation, thickness);
				}
			}
			cube(size);
		}
	}
}
