// HML650 holder for 16mm tube - a OpenSCAD 
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

use <library/round-corners-cube.scad>
use <library/nutsnbolts/cyl_head_bolt.scad>;
//include <nutsnbolts/materials.scad>;


$fn=50;


M3_outer_dia=3.7; 
M3_inner_dia=3; 
M3_head_dia=5.4+0.8;

// SMA Thread
M6_outer_dia=6.6;

tube_dia=16.1;
plate_width=35;
plate_tin=10.4;
servo_lenght=25;
servo_width=27;
gps_width=22;
cut_view = false;
full_view = cut_view;

module hexaprismx(
	ri =  1.0,  // radius of inscribed circle
	h  =  1.0)  // height of hexaprism
{ // -----------------------------------------------

	ra = ri*2/sqrt(3);
	cylinder(r = ra, h=h, $fn=6, center=false);
}

module arc( height, depth, radius, degrees ) {
    // This dies a horible death if it's not rendered here 
    // -- sucks up all memory and spins out of control 
    render() {
        difference() {
            // Outer ring
            rotate_extrude($fn = 100)
                translate([radius - height, 0, 0])
                    square([height,depth]);
         
            // Cut half off
            translate([0,-(radius+1),-.5]) 
                cube ([radius+1,(radius+1)*2,depth+1]);
         
            // Cover the other half as necessary
            rotate([0,0,180-degrees])
            translate([0,-(radius+1),-.5]) 
                cube ([radius+1,(radius+1)*2,depth+1]);
         
        }
    }
}

module half_module(top, xtra=0)
{
	col = top ? [0.8, 0.8, 0.2] : [0.5, 0.5, 0.5];
	gap = 0.7;
	xtra_length= xtra == 3 ? 3 : 0; 
	translate([0, 0, plate_tin/2-(gap/2)]) difference() 
	{
		color(col) 
		union()
		{
			round_corners_cube(plate_width+xtra*2, plate_width, plate_tin-gap,3);
		}
		if (xtra==3){
			translate([xtra_length+2, 0, 0]) { 
				for(a=[45, -45, 135, -135]) {
					rotate([0,0,a]) translate([32/2, 0, 0]) cylinder(d=M3_inner_dia, h=20, center=true, $fn=50);
				}			
				cylinder(d=M3_inner_dia, h=20, center=true, $fn=50);
			}
		}
		if (xtra==1){
			for (y = [-1,0, 1]) { 
				translate([0, y*(servo_width/2), 0]) {
					cylinder(d=M3_inner_dia, h=20, center=true, $fn=50);
				}
			}
		}			
		translate([-xtra_length, 0, 0]) {
			for (x = [-1,1]) { 
				for (y = [-1,1]) { 
					translate([x*(servo_lenght/2), y*(servo_width/2), 0]) {
						cylinder(d=M3_outer_dia, h=20, center=true, $fn=50);
						if (top) translate([0, 0, -4]) cylinder(d=M3_head_dia, h=10, center=true, $fn=50);
					}
				}
			}
		}
		translate([0, 0, (plate_tin/2)]) rotate([0,90,0]) {
			cylinder(d=tube_dia, h=plate_width+5+xtra, center=true, $fn=50);
			//#cylinder(d=0.1, h=200, center=true, $fn=50);
		}
		if (cut_view) {
			y = top ? 1 : -1;
			translate([plate_width/2-xtra+3, y*plate_width/2, 0]) color([1,0,0]) cube([15, 10, 20], center=true);
		}
	}
	
}

module cross_bracket()
{
	heigth = 6;
	module cross(w=6.6, h=4, l=33.5) {		
		translate([0, 0, 0]) { 
			if (w==10) cylinder(d=24, h=h);
			else cylinder(d=20.5, h=h);
			for(a=[45, 135]) {
				rotate([0,0,a]) hull() {
					translate([-l/2, 0, 0]) cylinder(d=w, h=h, center=false, $fn=50);
					translate([l/2, 0, 0]) cylinder(d=w, h=h, center=false, $fn=50);
				}
			}			
		}
	}
	
	difference() {
		union() {
			cross(w=10, h=heigth+1);
			translate([-5, -plate_width/2, 0]) cube([10, plate_width, 3]);
		}
		translate([0,0,5]) cross(w=7, h=heigth);
		translate([0, 0, -1]) cylinder(d=M3_inner_dia, h=heigth+2, center=false, $fn=50);
		for (y = [-1, 1]) { 
			translate([0, y*(servo_width/2), 0]) {
				cylinder(d=M3_outer_dia, h=20, center=true, $fn=50);
				translate([0, 0, 3.05]) cylinder(d=M3_head_dia, h=heigth, center=false, $fn=50);
			}
		}
		for(a=[45, 135, -45, -135]) {
			rotate([0,0,a]) {
				translate([-32/2, 0, -1]) cylinder(d=M3_inner_dia, h=heigth+2, center=false, $fn=50);
			}
		}			
	}
	if (full_view) {
		for (y = [-1, 1]) { 
			translate([0, y*(servo_width/2), 3]) {
				screw("M3x10");
			}
		}
	}
	
}

/**
 * Riht angle antenna bracket
 */
module rh_antenna_bracket(full_view)
{
	
	difference() {
		union() {
			translate([-5, -plate_width/2, 0]) cube([10, plate_width, 3]);
			translate([-7, -plate_width/2, 0]) cube([3, plate_width, 18]);
			translate([-4, 0, 3]) rotate([90,0,0])
				linear_extrude(height = 1.8, center = true, convexity = 10, twist = 0)
					polygon( points=[[0,0],[9,0],[0,15]] ); 
		}
		
		for (y = [-1, 1]) { 
			translate([0, y*(servo_width/2), 0]) {
				cylinder(d=M3_inner_dia, h=20, center=true, $fn=50);
			}
			
			translate([-5, y*((plate_width/2)-9), 11]) {  
				rotate([0,90,0]) cylinder(d=M6_outer_dia, h=10, center=true, $fn=50);
			}
		}
	}
	if (full_view) {
		for (y = [-1, 1]) { 
			translate([0, y*(servo_width/2), 3]) {
				screw("M3x10");
			}
		}
	}
}

/**
 * antenna bracket
 */
module simple_antenna_bracket(full_view)
{
	bracket_length = 55;
	bracket_width = 16;
	difference() {
		union() {
			//translate([-8, -plate_width/2, 0]) cube([3, plate_width, 18]);
			translate([-6.5, 0, 9.5]) rotate([0, 90, 0])  round_corners_cube(19, plate_width+15, 3, 3);
			hull()
			{
				translate([0, 	bracket_length/2, 0]) cylinder(d=bracket_width, h=6, center=false, $fn=50);
				translate([0, 	-bracket_length/2, 0]) cylinder(d=bracket_width, h=6, center=false, $fn=50);
			}
		}
		
		translate([0, 0, 3]) hull()
		{
			hh =1;
			translate([0, 	bracket_length/2, 0]) cylinder(d=12.5, h=10, center=false, $fn=50);
			translate([0, 	-bracket_length/2, 0]) cylinder(d=12.5, h=10, center=false, $fn=50);
		}
		for (y = [-1, 1]) { 
			translate([0, y*(servo_width/2), 0]) {
				cylinder(d=M3_outer_dia, h=20, center=true, $fn=50);
			}
			translate([-5, y*((plate_width/2)-1), 11]) {  
				rotate([0,90,0]) cylinder(d=M6_outer_dia, h=10, center=true, $fn=50);
			}
			
			translate([0, y*((plate_width/2)+9), 0]) {  
				rotate([0, 0, 0]) cylinder(d=M6_outer_dia, h=10, center=true, $fn=50);
			}
		}
	}
	translate([-5, 0, 3]) rotate([90,0,0])
				linear_extrude(height = 1.8, center = true, convexity = 10, twist = 0)
					polygon( points=[[0,0],[9,0],[0,15]] ); 
	if (full_view) {
		for (y = [-1, 1]) { 
			translate([0, y*(servo_width/2), 3]) {
				screw("M3x10");
			}
		}
	}
}

/**
 * antenna bracket
 */
module simple_antenna_bracket_old(full_view)
{
	bracket_length = 55;
	bracket_width = 16;
	difference() {
		union() {
			translate([-8, -plate_width/2, 0]) cube([3, plate_width, 18]);
			translate([-5, 0, 3]) rotate([90,0,0])
				linear_extrude(height = 1.8, center = true, convexity = 10, twist = 0)
					polygon( points=[[0,0],[9,0],[0,15]] ); 
			hull()
			{
				translate([0, 	bracket_length/2, 0]) cylinder(d=bracket_width, h=3, center=true, $fn=50);
				translate([0, 	-bracket_length/2, 0]) cylinder(d=bracket_width, h=3, center=true, $fn=50);
			}
		}
		
		for (y = [-1, 1]) { 
			translate([0, y*(servo_width/2), 0]) {
				cylinder(d=M3_outer_dia, h=20, center=true, $fn=50);
			}
			translate([-5, y*((plate_width/2)-9), 11]) {  
				rotate([0,90,0]) cylinder(d=M6_outer_dia, h=10, center=true, $fn=50);
			}
			
			translate([0, y*((plate_width/2)+9), 0]) {  
				rotate([0, 0, 0]) cylinder(d=M6_outer_dia, h=10, center=true, $fn=50);
			}
		}
	}
	if (full_view) {
		for (y = [-1, 1]) { 
			translate([0, y*(servo_width/2), 3]) {
				screw("M3x10");
			}
		}
	}
}

module simple_antenna_bracket_gps(full_view)
{
	bracket_length = 55;
	bracket_width = 16;
	
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
			//translate([0, 0, 3]) cube([18, 8, 4], center=true);
		}
	}
	module Vsupport_hole()
	{
			for (y = [-1, 1]) {
				translate([0, y*(12/2), 8])  rotate([-y*45, 0, 0]) 
				{
					translate([0, 0, 11]) cylinder(d=3.8, h=30, center=true, $fn=20);
					translate([0, 0, 5]) cylinder(d=2, h=30, center=true, $fn=20);
				}
			} 
			translate([0, 0, 2]) cube([9, 8, 6], center=true);
	}	
	difference() {
		union() {
			//translate([-8, -plate_width/2, 0]) cube([3, plate_width, 18]);
			translate([-6.5, 0, 9.5]) rotate([0, 90, 0])  round_corners_cube(19, plate_width+20, 3, 3);
			/*translate([-5, 0, 3]) rotate([90,0,0])
				linear_extrude(height = 1.8, center = true, convexity = 10, twist = 0)
					polygon( points=[[0,0],[9,0],[0,15]] );*/

			hull()
			{
				translate([0, 	bracket_length/2, 0]) cylinder(d=bracket_width, h=3, center=false, $fn=50);
				translate([0, 	-bracket_length/2, 0]) cylinder(d=bracket_width, h=3, center=false, $fn=50);
			}
			translate([7, 0, 0])  Vsupport();
			translate([-5, 0, 0]) {
				cylinder(d=8, h=40, center=false); 
				translate([0, 0, 30])  
				hull()
				{
					translate([0, 	0, -0.1])cylinder(d=8, h=0.1, center=false, $fn=50);
					translate([0, 	0, 10]) cylinder(d=14, h=0.1, center=false, $fn=50);
				}
				
			}
		}
		translate([-5, 0, -3]) cylinder(d=3, h=55, center=false);
		
		for (y = [-1, 1]) { 
			translate([0, y*(servo_width/2), 0]) {
				cylinder(d=M3_outer_dia, h=20, center=true, $fn=50);
			}
			
			translate([0, y*((plate_width/2)+9), 0]) {  
				rotate([0, 0, 0]) cylinder(d=M6_outer_dia, h=10, center=true, $fn=50);
			}
		}
		translate([-5, -20, 10]) {  
			rotate([0,90,0]) cylinder(d=9, h=40, center=true, $fn=50);
			translate([-2-1.5, 0, 0]) rotate([0,90,0]) cylinder(d=13, h=4, center=true, $fn=50);
		}
		
		translate([7, 0, 0])  Vsupport_hole();
	}
	if (full_view) {
		for (y = [-1, 1]) { 
			translate([0, y*(servo_width/2), 3]) {
				screw("M3x10");
			}
		}
	}
}

module gps_bracket(full_view)
{
	tin = 3;
	module v()
	{
		difference() {
		union() {
			 translate([0, 0, 0]) rotate([0,0,0]) cylinder(d=60, h=13+tin, center=false); 
		}
		translate([0, 0, tin]) rotate([0,0,0]) cylinder(d=55, h=10, center=false); 
		translate([0, 0, 2]) rotate([0,0,0]) cylinder(d=40, h=5, center=false); 
		translate([0, 0, 9+tin])  
			hull()
			{
				translate([0, 	0, -0.1])cylinder(d=55, h=0.1, center=false, $fn=50);
				translate([0, 	0, 4]) cylinder(d=53, h=0.1, center=false, $fn=50);
			}
		for (r = [0, 60, 120]) {
			translate([0, 0, 8+tin]) rotate([0,0,r]) cube([60, 15, 16], center=true);
			rotate([0,0,r]) translate([14.5, 0, -1]) cylinder(d=10, h=10);
			rotate([0,0,r-180]) translate([14.5, 0, -1]) cylinder(d=10, h=10);
		}
	}		
		
	}
	difference() {
		union() {
			v();	
		 	translate([0, 0, 0])  cylinder(d=17.5, h=1.8+tin, center=false);
		}
		translate([0, 0, -0.1])  cylinder(d=3, h=14, center=false);
		translate([0, 0, 2])  cylinder(d=5.5, h=14, center=false);
		
	}
		
}

module showScrew(xtra=0)
{
	if (cut_view) {
		for (x = [-1,1]) { 
			for (y = [-1,1]) { 
				translate([x*(servo_lenght/2)-xtra, y*(servo_width/2), 6]) rotate([0, 180, 0]) screw("M3x20");
			}
		}
	}
	
}
module top_plateAntennaBracket()
{
	
	holderPosX = 0;
	difference() {
		half_module(top=1);
		
		for (x = [-1,1]) { 
			translate([0, x*15, -1]) rotate([0,90,0]) rotate([0,0,90]) cylinder(d=tube_dia, h=plate_width+5, center=true, $fn=6);
		}
	}
	
	difference() {
		union() {
			for (y = [-1,1]) { 
				translate([holderPosX, y*((plate_width/2)-7), -3]) difference() 
				{
					translate([0, 0, 2]) cube([2.5, 13, 15], center=true);
					rotate([0,90,0]) cylinder(d=M6_outer_dia, h=5, center=true, $fn=50);
				}
			}
			
		}
		translate([holderPosX, 0, (plate_tin)]) rotate([0,90,0]) {
			cylinder(d=tube_dia+1, h=6, center=true, $fn=50);
		}
	
	}
	showScrew();
}

module top_plate_GPS_bracket(xtra=3)
{
	half_module(top=1, xtra=xtra);

	showScrew(xtra);

}

module top_plate(xtra=0)
{
	half_module(top=1, xtra=xtra);
	
	showScrew(xtra);
}

module bottom_plate(xtra=0)
{
	half_module(xtra=xtra);
}


module all_modules()
{
//			translate([-50, 50, plate_tin]) rotate([0, 180, 0])  top_plateAntennaBracket();
//			translate([-50, 0, 0]) rotate([0, 0, 0])  bottom_plate();
			
			translate([0, 100, 0]) rotate([0, 0, 0])  cross_bracket();
			translate([0, 150, 0]) rotate([0, 0, 0])  rh_antenna_bracket();
			translate([50, 150, 0])  simple_antenna_bracket();
			translate([0, 50, 0]) rotate([0, 0, 0])  top_plate(1);
			translate([0, 0, 0]) rotate([0, 0, 0])  bottom_plate(1);
			
			translate([60, 0, 0]) rotate([0, 0, 0])  bottom_plate(3);
			translate([60, 50, 0]) rotate([0, 0, 0])  top_plate_GPS_bracket(3);
	
translate([-50, 80, 0]) simple_antenna_bracket_gps();
translate([-60, 0, 0]) gps_bracket();
}
module antenna_bracket()
{
			translate([0, 0, plate_tin*2]) rotate([0, 180, 180])  top_plate(1);
			translate([0, 0, 0]) rotate([0, 0, 0])  bottom_plate(1);
			translate([0, 0, 20]) rotate([0, 0, 0])  cross_bracket();

			translate([60, 0, plate_tin*2]) rotate([0, 180, 180])  top_plate(1);
			translate([60, 0, 0]) rotate([0, 0, 0])  bottom_plate(1);
			translate([60, 0, 20]) rotate([0, 0, 180])  rh_antenna_bracket();
			
//			translate([0, 100, plate_tin*2]) rotate([0, 180, 180])  top_plateAntennaBracket();
//			translate([0, 100, 0]) rotate([0, 0, 0])  bottom_plate();

			translate([0, 50, plate_tin*2]) rotate([0, 180, 180])  top_plate_GPS_bracket(3);
			translate([0, 50, 0]) rotate([0, 0, 0])  bottom_plate(3);

	
}

translate([0, 0, 0]) all_modules();
//translate([150, 0, 0]) antenna_bracket();
//translate([0, 100, 0]) simple_antenna_bracket_gps();
//translate([0, 0, 0])  simple_antenna_bracket();
//translate([-50, 100, 0]) gps_bracket();