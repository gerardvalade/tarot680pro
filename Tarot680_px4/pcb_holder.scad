// tarot 680 pro - a OpenSCAD 
// Copyright (C) 2015  Gerard Valade

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.


include <library/params.scad>
use <library/modules-utils.scad>
use <library/round-corners-cube.scad>
use <videotx.scad>

module pcb_holder1(full_view, $fn=30)
{
	base_length = 42;//36;
	base_width = 42;//42;
	plate_tin=2.5;
	ww = 20; 
	espacer = 19;
	pcb_width=30;

	translate([0, 0, 0]) difference()
	{
		color(option_bracket_color)  
		union() {
			translate([0, 0, 1.3]) round_corners_cube(base_length, base_width, plate_tin, 3);
			
			translate([0, 20,  plate_tin+5]) cube([15, 2, 10], center=true);
			translate([0, 18,  plate_tin+2.5]) cube([15, 4, 7], center=true);
			
			color(option_bracket_color) for (x = [-1, 1]) {
				for (y = [0]) {
					translate([x*(pcb_width+1)/2, 1,  plate_tin+6]) cube([5, ww, 12], center=true);
				}
			}
		}
		for (x = [-1, 1]) {
			for (y = [0]) {
				if (debug) #translate([x*(pcb_width)/2, 0,  plate_tin+8]) rotate([90, 0, 0]) cylinder(d=0.2, h=50, center=true);
				hull() {
					translate([x*((pcb_width+0.4)/2), 0,  plate_tin+8]) rotate([90, 0, 0]) cylinder(d=2, h=30, center=true);
					translate([x*((pcb_width-5)/2), 0,  plate_tin+8]) rotate([90, 0, 0]) cylinder(d=2, h=30, center=true);
				}
			}
		}

		hull() {
			translate([0, -15,  0]) rotate([0, 0, 0]) cylinder(d=7, h=50, center=true);
			translate([0, -20,  0]) rotate([0, 0, 0]) cylinder(d=7, h=50, center=true);
		}
		translate([0, 4, 1.2]) round_corners_cube(base_length-18, base_width-18, plate_tin+1, 2);
		
		// fixing hole
		translate([-base_length/2+5.75, 0, -0.1]) draw_option_spacer(hole_dia=M3_outer_dia, center=false);
	}

	if (full_view)
	{
		translate([0, 5, plate_tin+8]) color([0., 0.2, 0.])  cube([30, 28, 1.5], center=true);
	}
}

module pcb_holder2(full_view, $fn=30)
{
	base_length = 42;//36;
	base_width = 42;//42;
	plate_tin=2;
	ww = 9; 
	espacer = 19;
	pcb_width=30;

	translate([0, 0, 0]) difference()
	{
		//color(option_bracket_color)  
		union() {
			translate([0, 0, 1.3]) round_corners_cube(base_length, base_width, plate_tin, 3);
			
			//translate([0, 20,  plate_tin+5]) cube([20, 2, 10], center=true);
			//translate([0, 18,  plate_tin+2.5]) cube([15, 4, 7], center=true);
			
			for (x = [-1, 1]) {
				for (y = [7.5]) {
					translate([x*(pcb_width+2)/2, y,  plate_tin+7]) cube([6, ww, 14], center=true);
				}
			}
		}
		for (x = [-1, 1]) {
			for (y = [7.5]) {
				if (debug) #translate([x*(pcb_width)/2, 0,  plate_tin+8]) rotate([90, 0, 0]) cylinder(d=0.2, h=50, center=true);
				hull() {
					translate([x*((pcb_width+0.4)/2), y,  plate_tin+8]) rotate([0, 0, 0]) cylinder(d=2.4, h=30, center=true);
					translate([x*((pcb_width-5)/2), y,  plate_tin+8]) rotate([0, 0, 0]) cylinder(d=2.4, h=30, center=true);
				}
			}
		}

		hull() {
			translate([0, -15,  0]) rotate([0, 0, 0]) cylinder(d=7, h=50, center=true);
			translate([0, -20,  0]) rotate([0, 0, 0]) cylinder(d=7, h=50, center=true);
		}
		translate([0, 2, 1.2]) round_corners_cube(base_length-16, base_width-20, plate_tin+1, 2);
		
		// fixing hole
		translate([-base_length/2+5.75, 0, -0.1]) draw_option_spacer(hole_dia=M3_outer_dia, center=false);
		translate([-base_length/2+5.75, 0, plate_tin]) draw_option_spacer(draw_type=1, hole_dia=M3_head_dia, heigth=15, center=false);
	}

	if (full_view)
	{
		translate([0, 5, plate_tin+8]) color([0.5, 0.2, 0.8])  cube([30, 28, 1.5], center=true);
	}
}
	
translate([0, 0, 0]) pcb_holder2();
translate([0, 70, 0]) pcb_holder1();	
	
