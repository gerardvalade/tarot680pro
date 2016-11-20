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


module gps_bracket(type=ViewGPS1Type, $fn=30)
{
	gps_board_width=39;
	gps_antenna_dia=55;
	gps_board_hole_width=31.5;
	
	module pillarFixing1()
	{
		translate([0, 0, plate_tin/2]) difference() 
		{
			color (gps_bracket_color)  union()
			{
				round_corners_cube(pillar_hole_length+6, pillar_hole_width+6, plate_tin, 3);
			}
			translate([0, 0, 0]) round_corners_cube(pillar_hole_length-6, pillar_hole_width-6, plate_tin+0.1, 3);
			for (x = [-1, 1]) { 
				for (y = [-1,1]) { 
					// pillar's hole
					translate([x*(pillar_hole_length/2), y*(pillar_hole_width/2), 3]) cylinder(d=M25_outer_dia, h=15, center=true, $fn=20);
				}
			}
			
			if (cut_view_debug) {
				translate([20, 20, 5]) cube([35, 35, 20], center=true);
			}
			
		}
		
	}

	module pillarFixing2(rot=45)
	{
		module arm(x, y, rot, dia1, dia2, length)
		{
			rotate(-y*rot, 0, 0) difference() {
				hull()
				{
					translate([0, 0, 0]) cylinder(d=dia1+3, h=plate_tin, center=false);
					translate([-x*length, 0, 0]) cylinder(d=dia2+2, h=plate_tin, center=false);
				}
				translate([0, 0, -0.1])	hull()
				{
					translate([0, 0, 0]) cylinder(d=dia1-2, h=plate_tin+2, center=false);
					translate([-x*length, 0, 0]) cylinder(d=dia2-2, h=plate_tin+2, center=false);
				}
			
			}
		}
		
		difference() 
		{
			color (gps_bracket_color)  union()
			{
				for (x = [-1, 1]) {
					for (y = [-1,1]) { 
						// pillar
						translate([x*(pillar_hole_length/2), y*(pillar_hole_width/2), 0]) {
							difference() {
								union() {
									arm(x, y, rot*-x, M25_head_dia, M25_head_dia*2.5, 55);
									cylinder(d=M25_head_dia+3, h=plate_tin, center=false);
								}
								// pillar's hole
								translate([0, 0, -0.1])	cylinder(d=M25_outer_dia, h=4, center=false);
								
							}
						}
					}
				}
			}
			if (cut_view_debug) {
				translate([20, 20, 5]) cube([35, 35, 20], center=true);
			}
			
		}
		
	}
	
	
	module base(h=1)
	{
		difference() {
			union() {
				color (gps_bracket_color) translate([0, 0, 3.5]) round_corners_cube(gps_board_width+2, gps_board_width+2, 7, 1);
				if (pillar_hole_length < gps_board_hole_width || pillar_hole_width < gps_board_hole_width)
					pillarFixing1();
				else
					pillarFixing2();
			}
			translate([0, 0, h+4]) round_corners_cube(gps_board_width, gps_board_width, 8, 1);
		}
		
	}
	
	module mountType2(heigth=10) {
		difference() 
		{
			union() {
				base(1);
				color (gps_bracket_color) translate([0, 0, 0])  cylinder(d=gps_antenna_dia+4, h=heigth, center=false, $fn=30);
			}
			translate([0, 0, 2])  cylinder(d=gps_antenna_dia, h=heigth, center=false, $fn=30);
			translate([0, 0, -2])  cylinder(d=19, h=heigth, center=false, $fn=30);
			translate([gps_antenna_dia/2, 0, 7])  cube([10, 9.45, 10], center=true);
		}
	}
	
	mountType2();
}
	
	
gps_bracket(type=ViewGPS1Type);	
