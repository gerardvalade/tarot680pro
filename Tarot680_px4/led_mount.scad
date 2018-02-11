// XT90Holder for Tarot 680 - a OpenSCAD 
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


module led_holder()
{
	tube_dia=16.1;
	plate_width=36;
	plate_tin=13;
	module plain()
	{
		translate([0, 0, (plate_tin)/2]) cube([10, plate_width, plate_tin], center=true);
	}

	module hole2()
	{
		difference()
		{
			cylinder(d=tube_dia+25, h=3, center=true, $fn=50);
			cylinder(d=tube_dia+4, h=5, center=true, $fn=50);
		
		}
		
	}		

	module hole()
	{
		translate([0, 0, 2]) rotate([0,90,0]) {
			cylinder(d=tube_dia, h=plate_width+5, center=true, $fn=50);
			hole2();
		}
		for(x = [-1, 1]) {
			translate([0, x*(14), plate_tin-6.5]) rotate([0,90,0]) 
			hull()
				{
					translate([1.5, 0, 0])  cylinder(d=4, h=15, center=true, $fn=50);
					translate([-1.5, 0, 0])  cylinder(d=4, h=15, center=true, $fn=50);
					
				}
				//cylinder(d=4, h=plate_width+5, center=true, $fn=50);
				
			
		}
	}		
	module led_plate(x)
	{ 
		difference()
		{
			translate([0, 0, plate_tin/2]) cube([75, 5.5, plate_tin], center=true);
			#translate([0, x*(-1+2.5), 11/2+2]) cube([54.8, 3.5, 12], center=true);
			for(xx = [-1, 1]) {
				translate([xx*25.4, 0, 7]) rotate([90,0,0]) hull()
				{
					translate([0, 1.5, 0])  cylinder(d=4, h=15, center=true, $fn=50);
					translate([0, -1.5, 0])  cylinder(d=4, h=15, center=true, $fn=50);
					
				}
			}
		}
		//cube([46, 3, plate_tin], center=true);
	}
	
	module holder()
	{
		difference()
		{
			plain();
			hole();
		}
		
	}
	for(x = [-1, 1]) {
		translate([(x*65/2), 0, 0]) holder();
		translate([0, x*(19), 0]) led_plate(x);// cube([46, 3, plate_tin], center=true);
	}
	
}

module led_holder2()
{
	tube_dia=16.1;
	led_plate_w=46;
	led_plate_h=21;
	plate_width=36;
	plate_tin=11;
	module plain()
	{
		translate([0, 0, (plate_tin+led_plate_h)/2]) cube([15, plate_width, plate_tin+led_plate_h], center=true);
	}

	module hole2()
	{
		difference()
		{
			cylinder(d=tube_dia+55, h=3, center=true, $fn=50);
			cylinder(d=tube_dia+5, h=5, center=true, $fn=50);
		
		}
		
	}		

	module hole()
	{
		translate([0, 0, 2]) rotate([0,90,0]) {
			cylinder(d=tube_dia, h=plate_width+5, center=true, $fn=50);
			hole2();
		}
		for(x = [-1, 1]) {
			translate([0, x*(14), plate_tin-6]) rotate([0,90,0]) cylinder(d=4, h=plate_width+5, center=true, $fn=50);
		}
	}		
	
	module holder()
	{
		difference()
		{
			plain();
			hole();
		}
		
	}
	for(x = [-1, 1]) {
		translate([(0*36/2), 0, 0])  rotate([0, 0, 0]) holder();
		//translate([0, x*(18), plate_tin+led_plate_h/2]) rotate([0, 0, 60]) cube([led_plate_w, 3, led_plate_h], center=true);
	 	rotate([0, 0, 60])	{
	 		translate([0, x*(14), plate_tin+led_plate_h/2]) rotate([0, 0, 0]) cube([led_plate_w, 3, led_plate_h], center=true);
	 		translate([x*18, 0, plate_tin+led_plate_h/2]) rotate([0, 0, 0]) cube([3.5, 25, led_plate_h], center=true);
	 	}
	}
	
}

translate([0, 0, 0]) led_holder();
//translate([-0, 0, 0]) rotate([0, 0, -0]) led_holder2();
mirror([0, 0, 1])  translate([-100, 0, 0]) rotate([0, 0, -60]) led_holder2();
mirror([0, 0, 1]) mirror([0, 1, 0])  translate([100, 0, 0]) rotate([0, 0, -60]) led_holder2();
