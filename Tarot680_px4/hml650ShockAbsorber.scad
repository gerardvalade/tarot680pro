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

include <library/roundCornersCube.scad>
include <library/nutsnbolts/cyl_head_bolt.scad>;
//include <nutsnbolts/materials.scad>;

ViewAllModule		= 0;
ViewAntennaBracket	= 1;


$fn=50;

	M3_outer_dia=3.7; 
	M3_inner_dia=3; 
	M3_head_dia=5.4+0.8;
	
	// SMA Thread
	M6_outer_dia=6.3;
	
	tube_dia=16.1;
	plate_width=35;
	plate_tin=10.4;
	servo_lenght=25;
	servo_width=27;


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

module tube_clamp(viewType, cutView = 0)
{
	gap = 0.7;
	plate_tin = 10;
	xtra = 0;
	xtra_length= xtra == 3 ? 3 : 0; 
	clamp_width=plate_width;
	clamp_length=20;
	clamp_tin=15;
	
	module module_bottom()
	{
		translate([0, 0, 0])  
		{
			roundCornersCube(clamp_length, clamp_width, clamp_tin-gap, 3);
			
		}
		
	}
	module module_top()
	{
		translate([0, 0, 0])  
		{
			roundCornersCube(clamp_length, clamp_width, clamp_tin-gap, 3);
			
		}
		
	}

	module module_hole()
	{
		translate([0, 0, 0])  
		{
			translate([0, 0, (clamp_tin/2)]) rotate([0,90,0]) {
				cylinder(d=tube_dia, h=clamp_width+5+xtra, center=true, $fn=50);
			}
			translate([-xtra_length, 0, 0]) {
				for (x = [0]) { 
					for (y = [-1,1]) { 
						translate([x*(servo_lenght/2), y*(servo_width/2), 0]) {
							cylinder(d=M3_outer_dia, h=20, center=true, $fn=50);
							if (top) translate([0, 0, -4]) cylinder(d=M3_head_dia, h=10, center=true, $fn=50);
						}
					}
				}
			}
			
		}
		
	}
	module clamp_bottom()
	{
		//translate([0, 0, plate_tin/2-(gap/2)])  
		difference() {
		module_bottom();
		module_hole();
		}
	}
	module clamp_top()
	{
		//translate([0, 0, plate_tin/2-(gap/2)])  
		difference() {
		module_bottom();
		module_hole();
		}
	}
	translate([0,0,-10])clamp_bottom();
	translate([0,0,10]) rotate([180, 0, 0])clamp_top();
}
module holder(viewType, cutView = 0)
{
	gps_width=22;
	fullView = cutView;
	
	gap = 0.7;
	xtra = 0;
	xtra_length= xtra == 3 ? 3 : 0; 
	
	module module_plain()
	{
		translate([0, 0, 0])  
		{
			roundCornersCube(plate_width+xtra*2, plate_width, plate_tin-gap,3);
			
		}
		
	}

	module module_hole()
	{
		translate([0, 0, 0])  
		{
			translate([0, 0, (plate_tin/2)]) rotate([0,90,0]) {
				cylinder(d=tube_dia, h=plate_width+5+xtra, center=true, $fn=50);
				//#cylinder(d=0.1, h=200, center=true, $fn=50);
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
			
		}
		
	}
	module halfModule(top, xtra=0)
	{
		//translate([0, 0, plate_tin/2-(gap/2)])  
		difference() {
		module_plain();
		module_hole();
		}
	}
	module halfModuleOld(top, xtra=0)
	{
		gap = 0.7;
		xtra_length= xtra == 3 ? 3 : 0; 
		translate([0, 0, plate_tin/2-(gap/2)]) difference() 
		{
			union()
			{
				roundCornersCube(plate_width+xtra*2, plate_width, plate_tin-gap,3);
			}
			translate([-xtra_length, 0, 0]) {
				for (x = [-1,1]) { 
					for (y = [-1,1]) { 
						translate([x*(servo_lenght/2), y*(servo_width/2), 0]) {
							#cylinder(d=M3_outer_dia, h=20, center=true, $fn=50);
							if (top) translate([0, 0, -4]) cylinder(d=M3_head_dia, h=10, center=true, $fn=50);
						}
					}
				}
			}
			translate([0, 0, (plate_tin/2)]) rotate([0,90,0]) {
				cylinder(d=tube_dia, h=plate_width+5+xtra, center=true, $fn=50);
				//#cylinder(d=0.1, h=200, center=true, $fn=50);
			}
			if (cutView) {
				y = top ? 1 : -1;
				translate([plate_width/2-xtra+3, y*plate_width/2, 0]) color([1,0,0]) cube([15, 10, 20], center=true);
			}
		}
		
	}


	
	module showScrew(xtra=0)
	{
		if (cutView) {
			for (x = [-1,1]) { 
				for (y = [-1,1]) { 
					translate([x*(servo_lenght/2)-xtra, y*(servo_width/2), 6]) rotate([0, 180, 0]) screw("M3x20");
				}
			}
		}
		
	}
	
	module topPlate(xtra=0)
	{
		halfModule(top=1, xtra=xtra);
		
		showScrew(xtra);
	}

	module bottomPlate(xtra=0)
	{
		halfModule(xtra=xtra);
	}
	
	
	translate([0, 0, 0]) {
		
		if (viewType == ViewAllModule) {
			//translate([0, 0, 0]) rotate([0, 0, 0]) color([0.5, 0.5, 0.5]) bottomPlate(1);
			translate([0, 100, 0]) rotate([0, 0, 0])  halfModuleOld();
			translate([0, 0, 0]) rotate([0, 0, 0]) tube_clamp();
			translate([50, 0, 0]) rotate([0, 0, 0])  color([0.8, 0.8, 0.2]) topPlate(1);
		}
	}
	
}




translate([0, 0, 0]) holder(ViewAllModule);
//translate([130, 0, 0]) holder(ViewAntennaBracket, 0);
 