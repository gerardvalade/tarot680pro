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

module cable_holder($fn=30)
{
	length=85;
	width=13;
	
	module holder(w=55)
	{
		difference() {
			union() {
				color (gps_bracket_color) translate([0, 0, 3.5]) cube([6.5, w, 7], center =true);
			}
			for (y = [-60:10:60]) {
				 translate([-10, y, 3]) rotate([0,90,0]) hull()
				 {
	 			 	translate([0, 0, 0]) cylinder(d=1.5, h=20);
				 	translate([-10, 0, 0]) cylinder(d=0.5, h=20);
				 } 
			}
			for (y = [-20, 20]) {
				 translate([-10, y, 4.4]) rotate([0,90,0]) hull()
				 {
	 			 	translate([0, 0, 0]) cylinder(d=4.6, h=20);
				 	translate([-10, 0, 0]) cylinder(d=4, h=20);
				 } 
			}
		}
	}
	
	module base()
	{
		difference() {
			union() {
				color (gps_bracket_color) translate([0, 0, 1]) round_corners_cube(pillar_hole_width+width/2, length+width, 2, 1);
			}
			translate([0, 0, 0]) round_corners_cube(pillar_hole_width-width/2, length, 10, 1);
			for (x = [-1, 1]) {
				for (y = [-1,1]) { 
					// pillar
					translate([x*(pillar_hole_length/2), y*(pillar_hole_width/2), 0]) {
							// pillar's hole
						translate([0, 0, -0.1])	cylinder(d=M25_outer_dia, h=14, center=false);
					}
				}
			}
		}
		
	}
	
	base();
	for (x = [-1, 1]) {
		translate([x*pillar_hole_width/2, 0, 0]) holder();
	}
	translate([0, (length+width/2)/2, 0]) rotate([0, 0, 90]) holder(w=34);
}
	
	
cable_holder();	
