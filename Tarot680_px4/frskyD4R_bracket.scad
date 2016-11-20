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

module V_antenna(full_view=false, frskyWidth=23.5, $fn=30)
{
	base_length = 33;
	base_width = 36;
	
	module Vsupport()
	{
		difference() { 
			union() {
				translate([0, 0, 4]) cube([8, 21, 8], center=true);
				for (y = [-1, 1]) {
					translate([0, y*(12/2), 8])  rotate([-y*45, 0, 0]) 
					{
						translate([0, 0, 5]) cylinder(d=8, h=20, center=true, $fn=20);
					}
				} 
			}
			translate([0, 0, 3]) cube([18, 8, 4], center=true);
		}
	}
	
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

	
	
module frskyD4R_bracket(full_view=true)
{
	base_length = 36;
	base_width = 36;
	frskyWidth = 23.5; 
	plate_tin=2.5;
	
	module ufixing($fn=30)
	{	translate([3, -base_width/2, 0]) {
			difference() {
				cube ([10, base_width, 6], center=false);
				translate([5, (base_width)/2, 0]) {
					translate([0, 0, 0]) cube([12, 24, 7.2], center=true);
					for(y=[-1,1]) {
						translate([0, y*((base_width-5.5)/2), -1]) {
							cylinder(d=M25_outer_dia, h=10);
							translate([0, 0, 3.5]) cylinder(d=M3_head_dia, h=10);
							translate([0, y*3, 5.3]) cube([11, 5, 3.7], center=true);
						}
					}
				
				}
			}
			if (isfull_view(viewType)) {
				translate([5, (base_width)/2, 0]) {
					for(y=[-1,1]) {
						translate([0, y*((base_width-5.5)/2), 2.5]) {
							//#cylinder(d=M25_outer_dia, h=10);
							screw("M2.5x10");
						}
					}
				}
			}
		}
	}
	
	translate([-12, 0, plate_tin/2]) difference()
	{
		color(option_bracket_color) union() {
			round_corners_cube(base_length, base_width, plate_tin, 3);
			for (y = [-1, 1]) {
				translate([0, y*(frskyWidth+2)/2, 2.98]) cube([base_length-6, 2, 3.7], center=true);
				translate([-3.25, y*(frskyWidth+8)/2, 2.98]) cube([12, 4.5, 3.7], center=true);
			} 
			for (x = [-1, 1]) {
				translate([x*(base_length-1.5)/2, 0, plate_tin-0.5]) cube([1.5, (frskyWidth+2), 2], center=true);
			}
		}

		round_corners_cube(base_length-15, base_width-28, plate_tin+1, 2);

		// telemetry port
		translate([base_length/2-6, -14, 5.8]) cube([9, 6, 5], center=true);

		for (y = [-1, 1]) {
			translate([-7.5, y*11, -2.6]) cylinder(d=M25_head_dia, h=10, $fn=30);
			translate([-4, y*11, 1.3]) cylinder(d=6, h=10, $fn=30);
		}
		
		// fixing hole
		translate([-3.25, 0, -1]) draw_option_spacer(xaxis=[0], hole_dia=7.5, center=false);
	}

	if (full_view) {

		translate([-41.5, 0, -plate_tin]) V_antenna(full_view=full_view);

		translate([0, 0, plate_tin-1.5]) frskyD4R();
		
		translate([-23.3, 0, plate_tin+3.3]) ufixing();
	
	
	} else {
		translate([-50, 0, 0]) V_antenna(full_view=full_view);
		
		translate([40, 0, -3.1]) rotate([0, -90, 0]) ufixing();
		
	}
	
}

frskyD4R_bracket(false);