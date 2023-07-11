include <nopscadlib/core.scad> // VERY IMPORTANT
include <nopscadlib/vitamins/screws.scad>
include <nopscadlib/vitamins/displays.scad>

include <common.scad>

use <case_bottom.scad>
use <case_top.scad>
use <screen.scad>

module complete() {
	color("blue") case_bottom();
	transform_case_top() {
		color("red") case_top();
	}
	translate([0, 0, size_case_outer.z-size_z_screw_head_case]) {
		screws_case() {
			screw(M3_cap_screw, 8);
		}
	}
	transform_case_display() {
		screen();
		screws_display() {
			translate([0, 0, size_z_screw_head_case]) {
				mirror([0, 0, 1]) {
					screw(M3_cap_screw, size_display.z);
				}
			}
		}
		display(LCD1602A);
		screws_screen() {
			translate([0, 0, size_case_display_outer.z]) {
				screw(M3_cap_screw, size_display.z-thickness);
			}
		}
	}
}

complete();
