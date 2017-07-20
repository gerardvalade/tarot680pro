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

module video_bracket($fn=30)
{
	base_length = 42;//36;
	base_width = 36;//42;
	frskyWidth = 23.5; 
	plate_tin=2.5;

	translate([0, 0, 0]) difference()
	{
		color(option_bracket_color)  
		union() {
			translate([0, 0, 1.3]) round_corners_cube(base_length, base_width, plate_tin, 3);
			ww = 10; 
			espacer=19;
			
			translate([(-base_length)/2+1, 0, plate_tin+7])  {
				difference() {
					cube([2, espacer,  14], center=true);
					rotate([0,-90,0]) translate([-7+5.8, -9.5+6.5,  -5]) cylinder(d=M6_outer_dia, h=15);
					//#rotate([0,-90,0]) translate([-7, -9.5, -5]) cylinder(d=0.5, h=15);
				}	
			}
			
			color(option_bracket_color) for (x = [-1, 1]) {
				for (y = [-1, 1]) {
					translate([x*(base_length-ww)/2, y*(espacer+2)/2,  plate_tin+7]) cube([ww, 2, 14], center=true);
				}
			}
		}

		translate([0, 0, 1.2]) round_corners_cube(base_length-15, base_width-21, plate_tin+1, 2);
		
		// fixing hole
		translate([-base_length/2+5.75, 0, -0.1]) draw_option_spacer(hole_dia=M3_outer_dia, center=false);
	}

	if (isfull_view(viewType))
	{
		translate([25, 2, plate_tin+13]) rotate([0,90,90]) videoTX();
		
		translate([5.75, 0, 2]) draw_option_spacer(drawType=2, hole_dia=M3_outer_dia, center=false);
	}
}

module double_bracket($fn=30)
{
	base_length = 42;//36;
	base_width = 42;//42;
	frskyWidth = 23.5; 
	plate_tin=2.5;

	translate([0, 0, 0]) difference()
	{
		//color(option_bracket_color)  
		union() {
			translate([0, 0, 1.3]) round_corners_cube(base_length, base_width, plate_tin, 3);
		
			espacer=19;
			
			translate([0, 0, 0])  {
				//translate([0, 9, 2]) cube([22, 6,  4], center=true);
				//translate([0, -12, 2]) cube([22, 6,  4], center=true);
			}
			
			translate([0, -4, plate_tin]) {
				wall_height=26;
				wall_width=24;
				for (y = [ 0, 19.5+2, -(10.5+2)]) {
					translate([0, y,  wall_height/2]) cube([wall_width, 2, wall_height], center=true);
					if (y < 0) { // >
						translate([0, y-2, 0])  cylinder(d=5, h=wall_height, center=false);
						translate([0, y/2, 0]) color("red") cube([30, 6,  1], center=true);
					} 
					if (y > 0) { 
						translate([0, y+2, 0]) cylinder(d=5, h=wall_height, center=false);
						translate([0, y/2, 0]) cube([30, 10,  1], center=true);
					}
				}
			}
		}
		translate([0, -4, 0]) for (y = [ 0, 19.5+2, -(10.5+2)]) {
			if (y < 0) translate([0, y-2, 0])  cylinder(d=2.5, h=40, center=false);
			if (y > 0) translate([0, y+2, 0])  cylinder(d=2.5, h=40, center=false);
		}

		//translate([0, 0, 1.2]) round_corners_cube(base_length-15, base_width-21, plate_tin+1, 2);
		
		// fixing hole
		translate([-base_length/2+5.75, 0, -0.1]) draw_option_spacer(hole_dia=M3_outer_dia, center=false);
		translate([-base_length/2+5.75, 0, 2]) draw_option_spacer(draw_type=1, hole_dia=M3_head_dia, center=false);
	}

	if (isfull_view(viewType))
	{
		translate([25, 2, plate_tin+13]) rotate([0,90,90]) videoTX();
		
		translate([5.75, 0, 2]) draw_option_spacer(drawType=2, hole_dia=M3_outer_dia, center=false);
	}
}

module fixing($fn=50)
{
	width = 19.5+2 +(10.5+2) + 4;
	plate_tin = 2;
	translate([0, 0.5, 1]) {
		difference()
		{
			union()
			{
				hull()
				{
					translate([0, 	width/2, 0]) cylinder(d=8, h=plate_tin, center=true, $fn=50);
					translate([0, 	-width/2, 0]) cylinder(d=8, h=plate_tin, center=true, $fn=50);
				}
				translate([0, -11, 1]) color("red") cube([30, 6,  4], center=true);
				translate([0, 6, 0]) color("red") cube([30, 6,  2], center=true);
			}
			translate([0, width/2, -2]) cylinder(d=2.5, h=20, center=false);
			translate([0, -width/2, -2]) cylinder(d=2.5, h=20, center=false);
		}
	}	
}



module double_bracket3($fn=30)
{
	base_length = 42;//36;
	base_width = 42;//42;
	frskyWidth = 23.5; 
	plate_tin=2.5;

	translate([0, 0, 0]) difference()
	{
		color(option_bracket_color)  
		union() {
			translate([0, 0, 1.3]) round_corners_cube(base_length, base_width, plate_tin, 3);
			ww = 15; 
			espacer=19;
			
			/*#translate([(0)/2+1, 0, plate_tin+7])  {
				difference() {
					cube([2, espacer,  14], center=true);
					rotate([0,-90,0]) translate([-7+5.8, -9.5+6.5,  -5]) cylinder(d=M6_outer_dia, h=15);
				}	
			}*/

			translate([0, 0, 0])  {
				translate([0, 9, 2]) cube([22, 6,  4], center=true);
				translate([0, -12, 2]) cube([22, 6,  4], center=true);
				difference() {
					translate([(0)/2+1, 0, 9]) cube([2, base_width,  18], center=true);
					rotate([0,-90,0]) translate([-7+5.8+plate_tin+7+2, -9.5+6.5-5-3.5,  -7]) {
						cylinder(d=M6_outer_dia, h=15);
						translate([0, 20.5, 0]) cylinder(d=M6_outer_dia, h=15);
					}
					//rotate([0,-90,0]) translate([-7+5.8+plate_tin+7, -9.5+6.5-5,  -5]) cylinder(d=M6_outer_dia, h=15);
					//rotate([0,-90,0]) translate([-7+5.8+plate_tin+7, -9.5+6.5-5-3.5,  -5]) cylinder(d=M6_outer_dia, h=15);
				}	
			}
			
			color(option_bracket_color) for (x = [0]) {
				for (y = [0, espacer+2, espacer+2+19]) {
					translate([x*(base_length-ww)/2, y-base_width/2+1,  plate_tin+7]) cube([ww, 2, 14], center=true);
				}
			}
		}

		//translate([0, 0, 1.2]) round_corners_cube(base_length-15, base_width-21, plate_tin+1, 2);
		
		// fixing hole
		translate([-base_length/2+5.75, 0, -0.1]) draw_option_spacer(hole_dia=M3_outer_dia, center=false);
	}

	if (isfull_view(viewType))
	{
		translate([25, 2, plate_tin+13]) rotate([0,90,90]) videoTX();
		
		translate([5.75, 0, 2]) draw_option_spacer(drawType=2, hole_dia=M3_outer_dia, center=false);
	}
}

module double_bracket2($fn=30)
{
	base_length = 42;//36;
	base_width = 42;//42;
	frskyWidth = 23.5; 
	plate_tin=2.5;

	translate([0, 0, 0]) difference()
	{
		color(option_bracket_color)  
		union() {
			translate([0, 0, 1.3]) round_corners_cube(base_length, base_width, plate_tin, 3);
			ww = 15; 
			espacer=19;
			
			/*#translate([(0)/2+1, 0, plate_tin+7])  {
				difference() {
					cube([2, espacer,  14], center=true);
					rotate([0,-90,0]) translate([-7+5.8, -9.5+6.5,  -5]) cylinder(d=M6_outer_dia, h=15);
				}	
			}*/

			translate([-10, 0, 0])  {
				translate([0, 9, 2]) cube([22, 6,  4], center=true);
				translate([0, -12, 2]) cube([22, 6,  4], center=true);
				difference() {
					translate([(0)/2+1, 0, 9]) cube([2, base_width,  18], center=true);
					rotate([0,-90,0]) translate([-7+5.8+plate_tin+7+2, -9.5+6.5-5-3.5,  -7]) {
						cylinder(d=M6_outer_dia, h=15);
						translate([0, 20.5, 0]) cylinder(d=M6_outer_dia, h=15);
					}
					//rotate([0,-90,0]) translate([-7+5.8+plate_tin+7, -9.5+6.5-5,  -5]) cylinder(d=M6_outer_dia, h=15);
					//rotate([0,-90,0]) translate([-7+5.8+plate_tin+7, -9.5+6.5-5-3.5,  -5]) cylinder(d=M6_outer_dia, h=15);
				}	
			
			}
				for (x = [0]) {
					for (y = [0, espacer+2, espacer+2+19]) {
						translate([x*(base_length-ww)/2, y-base_width/2+1,  plate_tin+7]) cube([ww, 2, 14], center=true);
					}
				}
			
		}

		//translate([0, 0, 1.2]) round_corners_cube(base_length-15, base_width-21, plate_tin+1, 2);
		
		// fixing hole
		translate([-base_length/2+5.75, 0, -0.1]) draw_option_spacer(hole_dia=M3_outer_dia, center=false);
	}

	if (isfull_view(viewType))
	{
		translate([25, 2, plate_tin+13]) rotate([0,90,90]) videoTX();
		
		translate([5.75, 0, 2]) draw_option_spacer(drawType=2, hole_dia=M3_outer_dia, center=false);
	}
}


module antenna_backet(full_view=false, frskyWidth=23.5, $fn=30)
{
	base_length = 33;
	base_width = 36;
	
	
	translate([0, 0, plate_tin/2]) difference()
	{
		color(option_bracket_color) union() {
			round_corners_cube(base_length, base_width, plate_tin, 3);
			translate([-(base_length-8)/2, 0, 0]) Vsupport();
		}
		
		translate([-2.1, 0, .6]) cube([base_length-8, 5, 2], center=true);
		translate([-(base_length-8)/2, 0, -0.1]) cube([6.1+2, 8, 3], center=true);
		
		for (y = [-1, 1]) {
			translate([-(base_length-8)/2, y*(12/2), 8])  rotate([-y*45, 0, 0]) {
				translate([0, 0, 0]) cylinder(d=2, h=16, center=true);
				translate([0, 0, 8.5]) cylinder(d=3.8, h=20, center=true);
			}
			
			// Head screw hole
			translate([(base_length-26)/2, y*11, 0]) cylinder(d=M25_head_dia, h=50, center=true);
		} 
		if (cut_view) translate([-(base_length+3)/2,0,10]) color(cut_color) cube([10,40,25], center=true);
	}
	if (full_view)
		color([0.9, 0.9, 0.9]) for (y = [-1, 1]) {
			translate([-(base_length-8)/2, y*(12/2), plate_tin+7])  rotate([-y*45, 0, 0]) 
			{
				translate([0, 0, 25]) {
					difference() {
						cylinder(d=3, h=50, center=true);
						cylinder(d=1, h=55, center=true);
					}
				}
			}
		} 
	
	
}



	
//translate([0, 100, 0]) video_bracket();	
//translate([0, 50, 0]) double_bracket3();	
//translate([0, 150, 0]) double_bracket2();	
translate([0, 0, 0]) double_bracket();	
//translate([0, 0, 26+4.5]) holder();	
translate([0, -50, 0]) fixing();	
//translate([-50, 0, 0]) antenna_backet();
