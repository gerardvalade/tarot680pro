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

module PX4_case()
{
	color([0.4, 0.3, 0.8]) {
		translate([0, 0, 17/2]) {
			round_corners_cube(50, 80, 17, 1);
		}
	}
}


module controllerPlate(full_view=0, cut_view=0)
{
	controller_length = 82;
	controller_width = 50;
	plate_length = controller_length+4;
	plate_width = controller_width+1;
	damper_length = controller_length+5;
	damper_width = controller_width+5;
	
	module plates()
	{
		translate([0, 0, plate_tin/2]) {
			difference() {
				union() {
					round_corners_cube(plate_width, plate_length, plate_tin, 3);
					
				}
				round_corners_cube(plate_width/2, plate_length/2, plate_tin+5, 5);
			}
		}
	}
	
	difference() 
	{
		color(top_plate_color)
		union()
		{
			plates();
			translate([0, 0, 0]) damperEars(DAMPER_EARS_DRAW_TOP, plate_color=top_plate_color);
			
		}
		
		if (cut_view) {
			translate([-20, -20, 0]) cube([15,15,10], center=true);
		}

		translate([0, 0, 0]) damperEars(DAMPER_EARS_CUT_TOP, plate_color=top_plate_color);
		
	}
	if (full_view) {
		translate([0, 0, plate_tin/2]) damperEars(DAMPER_EARS_SHOW_DAMPER, plate_color=top_plate_color, viewModule=viewModule);
		translate([0, 0, plate_tin]) PX4_case();
		//else translate([0, 0, plate_tin+1.8]) controller_board();			
	}
	
}

controllerPlate(full_view=true);