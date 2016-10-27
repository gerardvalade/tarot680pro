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
use <library/round-corners-cube.scad>
use <library/modules-utils.scad>
use <library/C3DRevo.scad>

module CC3DRevo_case()
{
	color([0.4, 0.3, 0.8]) {
		translate([0, 0, 1.9/2]) {
			roundCornersCube(38, 38, 1.9, 3);
			translate([0, 0, (1.9+5.4)/2]) {
				roundCornersCube(40.16, 40.16, 5.4, 3);
				translate([0, 0, (5.4+3.7)/2]) roundCornersCube(38, 38, 3.70, 3);
			}
		}
	}
}

module controller_board($fn=30)
{
	difference() {
		translate([0, 0, 1.24/2]) {
			color([0.9, 0.5, 0]) roundCornersCube(36.2, 36.2, 1.24, 3);
		}
		for (x = [-1, 1]) { 
			for (y = [-1, 1]) {
				translate([x*(cc3d_hole_width/2), y*(cc3d_hole_width/2), -4]) cylinder(d=3, h=10, center=false, $fn=20);
			} 
		}
	}
	for (x = [-1, 1]) { 
		for (y = [-1, 1]) {
			translate([x*(cc3d_hole_width/2), y*(cc3d_hole_width/2), 1]) screw("M3x5");
		} 
	}
}


module controllerPlate(full_view=0, cut_view=0, controller_case = 0)
{
	controller_length = controller_case ? 82 : 82;
	controller_width = controller_case ? 50 : 50;
	plate_length = controller_length+4;
	plate_width = controller_width+4;
	damper_length = controller_length+5;
	damper_width = controller_width+5;
	ear_length = 6;
	
	module plates()
	{
		translate([0, 0, plate_tin/2]) {
			difference() {
				union() {
					roundCornersCube(plate_width, plate_length, plate_tin, 3);
					
				}
				roundCornersCube(plate_width/2, plate_length/2, plate_tin+5, 5);
			}
		}
	}
	
	difference() 
	{
		color(top_plate_color)
		union()
		{
			plates();
			//color(top_plate_color)
			for (x = [-1, 1]) { 
				for (y = [-1, 1]) {
					// controller holder spacer ring 
					if (!controller_case) {
						translate([x*(cc3d_hole_width/2), y*(cc3d_hole_width/2), 0]) cylinder(d=5.5, h=6, center=false, $fn=20);
					
					} else {
						if (x==-1) {
							translate([x*0, y*(controller_length+2)/2, plate_tin]) cube([20, 2, 3], center=true);
						}
						if (y==1) {
							translate([x*(controller_width+2)/2, 0, plate_tin]) cube([2, 20, 3], center=true);
						}
						
					}
				}
			}
			
			translate([0, 0, 0]) damperEars(DAMPER_EARS_DRAW_TOP, plate_color=top_plate_color);
			
		}
		
		for (x = [-1, 1]) { 
			for (y = [-1,1]) {
				holeDia = controller_case ? 4 : M25_outer_dia;
				translate([x*(cc3d_hole_width/2), y*(cc3d_hole_width/2), -1]) cylinder(d=holeDia, h=plate_tin+10, center=false, $fn=20);
			}
		}
		
		if (cut_view) {
			translate([-20, -20, 0]) cube([15,15,10], center=true);
		}

		translate([0, 0, 0]) damperEars(DAMPER_EARS_CUT_TOP, plate_color=top_plate_color);
		
	}
	if (full_view) {
		#translate([0, 0, plate_tin/2]) damperEars(DAMPER_EARS_SHOW_DAMPER, plate_color=top_plate_color, viewModule=viewModule);
		if (controller_case) translate([0, 0, plate_tin]) CC3DRevo_case();
		else translate([0, 0, plate_tin+1.8]) controller_board();			
	}
	
}

controllerPlate();