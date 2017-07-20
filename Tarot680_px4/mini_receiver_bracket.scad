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
use <library/videotx.scad>

wall_height = 8;
wall_width = 20;
pow_width= 22.5;

module power_bracket($fn=30)
{
	base_length = 42;//36;
	base_width = 42;//42;
	//frskyWidth = 23.5; 
	plate_tin=2;


	translate([0, 0, 0]) difference()
	{
		//color(option_bracket_color)  
		union() {
			translate([0, 0, plate_tin/2]) round_corners_cube(base_length, base_width, plate_tin, 3);
		
			espacer=19;
			
			translate([0, 0, plate_tin]) {
				for (y = [1, -1]) {
					translate([0, y*(pow_width+2)/2,  wall_height/2]) cube([wall_width, 2, wall_height], center=true);
					
					translate([0, y*(pow_width+6)/2, 0])  cylinder(d=5, h=wall_height, center=false);
				}
			}
		}
		translate([0, 0, 0]) for (y = [ 1, -1]) {
			translate([0, y*(pow_width+6)/2, -0.1])  cylinder(d=2.5, h=wall_height*2, center=false);
		}

		// fixing hole
		translate([-base_length/2+5.75, 0, -0.1]) draw_spacer(d=2.5, h=10);
		translate([-base_length/2+5.75, 0, 2]) draw_spacer(d=4, h=10);
	}

}

module fixing($fn=50)
{
	plate_tin = 2;
	translate([0, 0.5, 0]) {
		difference()
		{
			union()
			{
				hull()
				{
					translate([0, (pow_width+6)/2, 0])  cylinder(d=8, h=plate_tin, center=false);
					translate([0, -(pow_width+6)/2, 0])  cylinder(d=8, h=plate_tin, center=false);
				}
			}
			translate([0, 0, 0]) for (y = [ 1, -1]) {
				translate([0, y*(pow_width+6)/2, -0.1])  cylinder(d=2.5, h=wall_height*2, center=false);
			}
		}
	}	
}


module mini_receiver_bracket(full_view=false, frskyWidth=23.5, $fn=30)
{
	base_length = 18;
	base_width = 36;
	
	translate([0, 0, plate_tin/2]) difference()
	{
		//color(option_bracket_color) 
		union() {
			translate([0, 0, 0])  round_corners_cube(base_length, base_width, plate_tin, 3);
			translate([-4, 0, 0])  round_corners_cube(20, 10, plate_tin, 3);
		}
		
		translate([-7, 0, .6]) cube([base_length-3, 5, 2], center=true);
		
		for (y = [-1, 1]) {
			// Head screw hole
			translate([(base_length-26)/2, y*11, 0]) cylinder(d=M25_head_dia, h=50, center=true);
		} 
	}
	
}


	
translate([0, 0, 0]) power_bracket();	
translate([0, 50, 0])  mini_receiver_bracket();

translate([0, -50, 0]) fixing();