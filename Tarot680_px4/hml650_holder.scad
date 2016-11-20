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
M6_outer_dia=6.5;

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
				#cylinder(d=M3_outer_dia, h=20, center=true, $fn=50);
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
//simple_antenna_bracket();
 