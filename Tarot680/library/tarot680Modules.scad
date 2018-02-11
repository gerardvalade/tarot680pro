// tarot 680 pro mounting plate - a OpenSCAD 
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


include <nutsnbolts/cyl_head_bolt.scad>
use <tarot680pro.scad>
use <frsky.scad>
use <videotx.scad>

FullView			= 0;
ViewAllModule		= 1;
ViewBottomPlate     = 2;
ViewControllerPlate = 3;
ViewFrskyBracket    = 4;
ViewVideoBracket    = 5;
ViewGPS1Type 		= 6;
ViewGPSARKBIRD		= 7;
ViewGPSARKBIRD2		= 8;

function isFullView(n) = n==FullView;

bottom_plate_color = [0.3, 0.7, 0.7];
top_plate_color = [0.8, 0.8, 0.3];
damper_color = [0.8, 0.2, 0.3];
gps_bracket_color = [0.3, 0.8, 0.3, 1];
option_bracket_color = [0.8, 0.8, 0.3];
pillar_color = [0.8, 0.5, 0.3];
cut_color = [0.9, 0, 0];

cc3d_hole_width = 30.5;
cutView=true;

M25_outer_dia=2.8; 
M25_inner_dia=2.05; 
M25_head_dia=5;
M3_outer_dia=3.5; 
M3_inner_dia=2.8;
M3_head_dia=5.4+0.5;
// SMA Thread
M6_outer_dia=6.3;

module hexaprismx(
	ri =  1.0,  // radius of inscribed circle
	h  =  1.0)  // height of hexaprism
{ // -----------------------------------------------

	ra = ri*2/sqrt(3);
	cylinder(r = ra, h=h, $fn=6, center=true);
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
module fillet(r, h) {
    translate([r / 2, r / 2, 0])

        difference() {
            cube([r + 0.01, r + 0.01, h], center = true);

            translate([r/2, r/2, 0])
                cylinder(r = r, h = h + 1, center = true);

        }
}


module CC3DRevo_case()
{
	color([0.4, 0.3, 0.8]) {
		translate([0, 0, 1.9/2]) {
			roundCornersCube(38, 38, 1.9, 3);
			translate([0, 0, (1.9+5.4)/2]) {
				roundCornersCube(40.16, 40.16, 5.4, 3);
				translate([0, 0, (5.4+3.7)/2]) roundCornersCube(38, 38, 3.70, 3);
			}
		}
	}
}

module controller_board($fn=30)
{
	difference() {
		translate([0, 0, 1.24/2]) {
			color([0.9, 0.5, 0]) roundCornersCube(36.2, 36.2, 1.24, 3);
		}
		for (x = [-1, 1]) { 
			for (y = [-1, 1]) {
				translate([x*(cc3d_hole_width/2), y*(cc3d_hole_width/2), -4]) cylinder(d=3, h=10, center=false, $fn=20);
			} 
		}
	}
	for (x = [-1, 1]) { 
		for (y = [-1, 1]) {
			translate([x*(cc3d_hole_width/2), y*(cc3d_hole_width/2), 1]) screw("M3x5");
		} 
	}
}

module powerBoard($fn=30)
{
	controller_board();
	translate([0, 0, (1.24+4)/2]) roundCornersCube(21.45, 24.33, 4, 3);
}

module GPS()
{
	gps_board_hole_width = 31.5;
	color([0.9, 0.5, 0]) difference() {
		translate([0, 0, 0.8]) roundCornersCube(38, 38, 1.6, 3);
		for (x = [-1, 1]) { 
			for (y = [-1, 1]) {
				translate([x*(gps_board_hole_width/2), y*(gps_board_hole_width/2), -4]) cylinder(d=3, h=10, center=false, $fn=20);
			} 
		}
	}
	color([0.8, 0.8, 0.8]) translate([0, 0, 1.6+2.15]) roundCornersCube(25, 25, 4.3, 3);
	//if (isFullView(viewType))
	for (x = [-1, 1]) { 
		for (y = [-1, 1]) {
			translate([x*(gps_board_hole_width/2), y*(gps_board_hole_width/2), 0]) rotate([0, 180, 0]) screw("M3x5");
		} 
	}
}

module T680Pro_holes(type=0, d=M25_outer_dia, $fn=30)
{
	module holeScrew(d)
	{
		if (type==0) cylinder(d=d, h=10, center=true);
		if (type==1) translate([0, 0, 1]) screw("M2.5x25");
	}
	for (r=[0, 180]) {
		// inner, middle, external holes
		for (x = [71.5, 148]) { 
			for (y = [-1,1]) { 
				rotate([0,0,r]) translate([(x/2), y*(22/2), 0]) holeScrew(d=d);
			}
		}
	}
	if (type==0)
	for (r=[90, -90]) {
		for (x = [73.5, 145]) { 
			for (y = [-1,1]) { 
				rotate([0,0,r]) translate([(x/2), y*(42.5/2), 0]) holeScrew(d=M25_head_dia);
			}
		}
	}
	
}

module tarot680Modules(viewType=1, cutView=0)
{
	plate_tin = 2.2;
	
	pillar_heigth = 34;
	
	pillar_hole_width = 64;
	pillar_hole_length = 64;
	
	option_hole_length = cc3d_hole_width;
	option_hole_width = cc3d_hole_width;

	viewModule = isFullView(viewType);
	cutViewDebug=0;
	
	module drawOptionSpacer(drawType=0, xaxis=[0,1], hole_dia=M25_inner_dia, heigth=10, center=true, $fn=30)
	{
		hole_dia = drawType == 0 ? hole_dia : 6;
		heigth = drawType == 0 ? 10 : 8;
		zaxis = drawType == 0 ? -1 : 0;
		for (x = xaxis) { 
			for (y = [-1,1]) {
				xpos = (center) ? (x*2-1) * option_hole_length/2 :  x * option_hole_length;
				ypos = y * option_hole_width/2;
				translate([xpos, ypos, zaxis])  rotate([0, 0, 0])  {
					if (drawType == 0) cylinder(d=hole_dia, h=heigth+2, center=false);
					if (drawType == 1) cylinder(d=hole_dia, h=heigth, center=false);
					if (drawType == 2) translate([0, 0, 0]) rotate([0, 0, 0]) screw("M2.5x10");
				}
			}
		}
	}

	module V_antenna(frskyWidth=23.5, $fn=30)
	{
		base_length = 32;
		base_width = 36;
		
		module Vsupport()
		{
			difference() { 
				union() {
					translate([0, 0, 4]) cube([6, 21, 8], center=true);
					for (y = [-1, 1]) {
						translate([0, y*(12/2), 8])  rotate([-y*45, 0, 0]) 
						{
							cylinder(d=6, h=20, center=true, $fn=20);
						}
					} 
				}
				translate([0, 0, 3]) cube([18, 8, 4], center=true);
			}
		}
		
		translate([0, 0, plate_tin/2]) difference()
		{
			color(option_bracket_color) union() {
				roundCornersCube(base_length, base_width, plate_tin, 3);
				translate([-(base_length-6)/2, 0, 0]) Vsupport();
			}
			
			translate([-2.1, 0, .6]) cube([base_length-8, 5, 2], center=true);
			translate([-(base_length-6)/2, 0, -0.1]) cube([6.1, 8, 3], center=true);
			
			for (y = [-1, 1]) {
				translate([-(base_length-6)/2, y*(12/2), 8])  rotate([-y*45, 0, 0]) {
					translate([0, 0, 0]) cylinder(d=2, h=16, center=true);
					translate([0, 0, 5.1]) cylinder(d=3, h=10, center=true);
				}
				
				// Head screw hole
				translate([(base_length-26)/2, y*11, 0]) cylinder(d=M25_head_dia, h=50, center=true);
			} 
			if (cutView) translate([-(base_length+5)/2,0,10]) color(cut_color) cube([10,30,20], center=true);
		}
		if (isFullView(viewType))
			color([0.2, 0.2, 0.2]) for (y = [-1, 1]) {
				translate([-(base_length-6)/2, y*(12/2), plate_tin+7])  rotate([-y*45, 0, 0]) 
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

	
	module frskyD4Rbracket()
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
				if (isFullView(viewType)) {
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
		
		translate([0, 0, plate_tin/2]) difference()
		{
			color(option_bracket_color) union() {
				roundCornersCube(base_length, base_width, plate_tin, 3);
				for (y = [-1, 1]) {
					translate([0, y*(frskyWidth+2)/2, 2.98]) cube([base_length-6, 2, 3.7], center=true);
					translate([-3.25, y*(frskyWidth+8)/2, 2.98]) cube([12, 4.5, 3.7], center=true);
				} 
				for (x = [-1, 1]) {
					translate([x*(base_length-1.5)/2, 0, plate_tin-0.5]) cube([1.5, (frskyWidth+2), 2], center=true);
				}
			}

			roundCornersCube(base_length-15, base_width-28, plate_tin+1, 2);

			// telemetry port
			translate([base_length/2-6, -14, 5.8]) cube([9, 6, 5], center=true);

			for (y = [-1, 1]) {
				translate([-7.5, y*11, -2.6]) cylinder(d=M25_head_dia, h=10, $fn=30);
				translate([-4, y*11, 1.3]) cylinder(d=6, h=10, $fn=30);
			}
			
			// fixing hole
			translate([-3.25, 0, -1]) drawOptionSpacer(xaxis=[0], hole_dia=7.5, center=false);
		}

		if (isFullView(viewType)) {

			translate([-28.5, 0, -plate_tin]) V_antenna();

			translate([0, 0, plate_tin-1.5]) frskyD4R();
			
			translate([-11.3, 0, plate_tin+3.3]) ufixing();
		
		
		} else {
			translate([-50, 0, 0]) V_antenna();
			
			translate([40, 0, -3.1]) rotate([0, -90, 0]) ufixing();
			
		}

		
	}

	module videoBracket($fn=30)
	{
		base_length = 42;//36;
		base_width = 36;//42;
		frskyWidth = 23.5; 
		plate_tin=2.5;

		translate([base_length/2, 0, 0]) difference()
		{
			color(option_bracket_color)  
			union() {
				translate([0, 0, 1.3]) roundCornersCube(base_length, base_width, plate_tin, 3);
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

			translate([0, 0, 1.2]) roundCornersCube(base_length-15, base_width-21, plate_tin+1, 2);
			
			// fixing hole
			translate([-base_length/2+5.75, 0, -0.1]) drawOptionSpacer(hole_dia=M3_outer_dia, center=false);
		}

		if (isFullView(viewType))
		{
			translate([25, 2, plate_tin+13]) rotate([0,90,90]) videoTX();
			
			translate([5.75, 0, 2]) drawOptionSpacer(drawType=2, hole_dia=M3_outer_dia, center=false);
		}
	}


	DAMPER_EARS_DRAW_TOP=[0,1];
	DAMPER_EARS_DRAW_BOTTOM=[0,0];
	DAMPER_EARS_SHOW_DAMPER=[1,1];
	DAMPER_EARS_CUT_BOTTOM=[2,0];
	DAMPER_EARS_CUT_TOP=[2,1];
	function is_damper_draw(n) = n[0]==0; 
	function is_damper_show(n) = n[0]==1;
	function is_damper_cut(n) = n[0]==2; 
	function is_damper_top(n) = n[1]==1; 
	function is_damper_bottom(n) = n[1]==0; 
	module damperEars(type, damper_widthx, ear_lengthx=4, damper_dia=10.5, damper_angle=40, plate_color, $fn=30)
	{
		cte=0.45;
		damper_width= is_damper_bottom(type) ? 47 : 36+5;
		damper_heigth= is_damper_bottom(type) ? 7.1 : 0;
		ear_length = is_damper_bottom(type) ? 7.9 : 6;
		
		module ear(x, tz=0, cte=0, ear_length, thick=plate_tin)
		{
			 hull() {
				translate([x*ear_length, 0, tz]) cylinder(d=13-cte, h=thick, center=true);
				translate([0, 0, tz]) cylinder(d=14-cte, h=thick, center=true);
			}
		}
		
		module drawEars() {
			//drawEars2();
			translate([0, 0, damper_heigth])
			for (x = [-1,1]) { 
				for (y = [-1,1]) {
					translate([(x*damper_width*cte), (y*damper_width*cte), 0]) rotate([0, 0, x*y*45]) { 
						if (is_damper_top(type)) translate([-x*5, 0, plate_tin/2]) cube([10, 14, plate_tin], center=true);
						if (is_damper_bottom(type)) translate([-x*1.3, 0, -damper_heigth/2]) cube([plate_tin*1.6, 13, damper_heigth], center=true);
					}
					translate([0,0,1]) difference() 
					{
						translate([(x*damper_width*cte), (y*damper_width*cte), 0]) rotate([0, 0, x*y*45]) rotate([0,-x*damper_angle, 0]) {  
							difference() 
							{
								union() {
									color(plate_color) ear(x, ear_length=ear_length);
								}
								ear(x, 1.5, 4, ear_length=ear_length);
								translate([x*ear_length, 0, 5])  rotate([0, 180, 0])  cylinder(d=6, h=40, center=false);
								if (cutView && x==1)
								{
									translate([x*ear_length, -10, -5]) color(cut_color) cube([10, 20, 20]);
								}
							} 
						}
				
						// vertical truncate
						translate([(x*damper_width*cte), (y*damper_width*cte), -(3/2*plate_tin)])  cube([20, 20, plate_tin*2], center=true);
					}
				}
			}
		}
		
		module showDamper()
		{
			module damper(heigth=13)
			{
				difference() {	
					union() {
						cylinder(d=6, h=heigth, center =true);
						cylinder(d=8.5, h=6.5, center =true);
						translate([0,0,(heigth-1.5)/2]) cylinder(d=8.5, h=1.5, center =true);
						translate([0,0,-(heigth-1.5)/2]) cylinder(d=8.5, h=1.5, center =true);
					}
					cylinder(d=4, h=heigth+0.1, center =true);
				}
			}

			for (x = [-1,1]) { 
				for (y = [-1,1]) {
					translate([(x*damper_width*cte), (y*damper_width*cte), damper_heigth]) rotate([0, 0, x*y*45]) rotate([0,-x*damper_angle, 0]) {  
								
						difference() 
						{
							translate([x*ear_length, 0, -4.5]) color(damper_color) damper();
							if (cutView && x==1)
							{
								translate([x*ear_length, -10, -15]) color(cut_color)  cube([10, 20, 25]);
							}
						}
					}
				}
			}
		}
		module cutDamper()
		{
			for (x = [-1,1]) { 
				for (y = [-1,1]) {
					translate([(x*damper_width*cte), (y*damper_width*cte), damper_heigth]) rotate([0, 0, x*y*45]) {// rotate([0,-x*damper_angle, 0]) {  
						if (is_damper_bottom(type)) translate([x*1.96, 0, -(damper_heigth+plate_tin+0.1)/2]) cube([3, 13, damper_heigth], center=true);
						if (is_damper_top(type)) 
						{
							rotate([0, -x*damper_angle, 0]) { 
								translate([x*2, 0, -plate_tin*3/2+0.2]) cube([5, 13, 4], center=true);
							}
						}
					}
				}
			}
		}
		if (is_damper_draw(type)) drawEars();
		if (is_damper_show(type) && viewModule) showDamper();
		if (is_damper_cut(type)) cutDamper();
	}

	module pillar(l=pillar_heigth, $fn=30)
	{
		color(pillar_color) difference() {
			translate([0, 0, l/2])  hexaprismx(ri=6/2, h=l);
			translate([0, 0, -1])  cylinder(d=M25_inner_dia, h=l+2);
		}
	}


	module GPSBracket(type=ViewGPS1Type, $fn=30)
	{
		gps_board_width=39;
		gps_antenna_width=27;
		gps_board_hole_width=31.5;
		
		module pillarFixing1()
		{
			translate([0, 0, plate_tin/2]) difference() 
			{
				color (gps_bracket_color)  union()
				{
					roundCornersCube(pillar_hole_length+6, pillar_hole_width+6, plate_tin, 3);
				}
				translate([0, 0, 0]) roundCornersCube(pillar_hole_length-6, pillar_hole_width-6, plate_tin+0.1, 3);
				for (x = [-1, 1]) { 
					for (y = [-1,1]) { 
						// pillar's hole
						translate([x*(pillar_hole_length/2), y*(pillar_hole_width/2), 3]) cylinder(d=M25_outer_dia, h=15, center=true, $fn=20);
					}
				}
				
				if (cutViewDebug) {
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
				if (cutViewDebug) {
					translate([20, 20, 5]) cube([35, 35, 20], center=true);
				}
				
			}
			
		}
		
		module pillarFixing3()
		{
			module arm(x, y, rot, dia1, dia2, length)
			{
				rotate(-y*rot,0,0) difference() {
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
					for (x = [-1,1]) {
						for (y = [-1,1]) { 
							// pillar
							translate([x*(pillar_hole_length/2), y*(pillar_hole_width/2), 0]) {
								difference() {
									union() {
										if (x==-1)
										{
											arm(x, y, 60, M25_head_dia, M25_head_dia*3, 40);
										} 
										if (x==1)
										{
											arm(x, y, -25, M25_head_dia, M25_head_dia*2, 40);
										} 
										cylinder(d=M25_head_dia+3, h=plate_tin, center=false);
									}
									// pillar's hole
									translate([0, 0, -0.1])	cylinder(d=M25_outer_dia, h=4, center=false);
									
								}
							}
						}
					}
				}
				if (cutViewDebug) {
					translate([20, 20, 5]) cube([35, 35, 20], center=true);
				}
				
			}
			
		}
		
		module base(h=1)
		{
			difference() {
				union() {
					color (gps_bracket_color) translate([0, 0, 3.5]) roundCornersCube(gps_board_width+2, gps_board_width+2, 7, 1);
					if (pillar_hole_length < gps_board_hole_width || pillar_hole_width < gps_board_hole_width)
						pillarFixing1();
					else
						pillarFixing2();
				}
				translate([0, 0, h+4]) roundCornersCube(gps_board_width, gps_board_width, 8, 1);
			}
			
		}
		
		module mountType1() {
			difference() 
			{
				base(4);
				translate([0, 0, 6]) roundCornersCube(gps_antenna_width, gps_antenna_width, 15.1, 1);
				for (x = [-1, 1]) { 
					for (y = [-1, 1]) {
						translate([x*(gps_board_hole_width/2), y*(gps_board_hole_width/2), -4]) cylinder(d=M3_inner_dia, h=10, center=false, $fn=20);
					} 
				}
				if (!cutViewDebug) {
					translate([15, 20, 5]) cube([20, 20, 20], center=true);
				}
			}
			if (isFullView(viewType)) {
				for (x = [-1, 1]) { 
					for (y = [-1,1]) { 
						// pillar's screw
						translate([x*(pillar_hole_length/2), y*(pillar_hole_width/2), 0]) rotate([0, 180, 0]) screw("M2.5x10");
					}
				}
				translate([0, 0, 6]) rotate([0, 180, 0]) GPS();
			}
		}
		module mountType2() {
			difference() 
			{
				union() {
					base(1);
					for (x = [-1, 1]) { 
						for (y = [-1, 1]) {
							translate([x*(gps_board_hole_width)/2, y*(gps_board_hole_width)/2, 2.5]) {
								 cube([8, 8, 5],center=true);
							 }
						} 
					}
				}
				translate([0, 0, 6]) roundCornersCube(gps_antenna_width, gps_antenna_width, 15.1, 1);
				for (x = [-1, 1]) { 
					for (y = [-1, 1]) {
						translate([x*(gps_board_hole_width/2), y*(gps_board_hole_width/2), -1]) {
							 cylinder(d=M3_inner_dia, h=10, center=false, $fn=20);
						 }
					} 
				}
				if (cutViewDebug) {
					translate([15, 26, 5]) color(cut_color) cube([60, 20, 20], center=true);
				}
			}
			if (isFullView(viewType)) {
				for (x = [-1, 1]) { 
					for (y = [-1,1]) { 
						// pillar's screw
						translate([x*(pillar_hole_length/2), y*(pillar_hole_width/2), 0]) rotate([0, 180, 0]) screw("M2.5x10");
					}
				}
				translate([0, 0, 6.6]) rotate([0, 180, 0]) GPS();
			}
		}
		
		
		module mountTypeArkBird()
		{
			module base(h=1)
			{
				difference() {
					union() {
						color (gps_bracket_color) translate([0, 0, 1.5]) roundCornersCube(34+2, 42+2, 3, 1);
						pillarFixing2(rot=40);
					}
				}
				
			}
			difference() 
			{
				union() {
					base(1);
				}
				if (cutViewDebug) {
					translate([15, 26, 5]) color(cut_color) cube([60, 20, 20], center=true);
				}
			}
			if (isFullView(viewType)) {
				for (x = [-1, 1]) { 
					for (y = [-1,1]) { 
						// pillar's screw
						translate([x*(pillar_hole_length/2), y*(pillar_hole_width/2), 0]) rotate([0, 180, 0]) screw("M2.5x10");
					}
				}
				translate([0, 0, 6.6]) rotate([0, 180, 0]) GPS();
			}
			
		}
		
		module mountTypeArkBird2()
		{
			module base(h=1)
			{
				difference() {
					union() {
						color (gps_bracket_color) translate([-10, 0, 1.5]) roundCornersCube(34+2, 42+2, 3, 1);
						pillarFixing3();
					}
				}
				
			}
			difference() 
			{
				union() {
					base(1);
				}
				if (cutViewDebug) {
					translate([15, 26, 5]) color(cut_color) cube([60, 20, 20], center=true);
				}
			}
			if (isFullView(viewType)) {
				for (x = [-1, 1]) { 
					for (y = [-1,1]) { 
						// pillar's screw
						translate([x*(pillar_hole_length/2), y*(pillar_hole_width/2), 0]) rotate([0, 180, 0]) screw("M2.5x10");
					}
				}
				translate([0, 0, 6.6]) rotate([0, 180, 0]) GPS();
			}
			
		}
		if(type==ViewGPS1Type) mountType2();
		if(type==ViewGPSARKBIRD) mountTypeArkBird();
		if(type==ViewGPSARKBIRD2) mountTypeArkBird2();
	}
	
	module controllerPlate(controller_case = 1)
	{
		controller_width = controller_case ? 38.8 : 36;
		plate_width = controller_width+4;
		damper_width = controller_width+5;
		ear_length = 6;
		
		module plates()
		{
			translate([0, 0, plate_tin/2]) {
				difference() {
					union() {
						roundCornersCube(plate_width, plate_width, plate_tin, 3);
						
					}
					roundCornersCube(plate_width/2, plate_width/2, plate_tin+5, 5);
				}
			}
		}
		
		difference() 
		{
			color(top_plate_color)
			union()
			{
				plates();
				//color(top_plate_color)
				for (x = [-1, 1]) { 
					for (y = [-1, 1]) {
						// controller holder spacer ring 
						if (!controller_case) {
							translate([x*(cc3d_hole_width/2), y*(cc3d_hole_width/2), 0]) cylinder(d=5.5, h=6, center=false, $fn=20);
						
						} else {
							if (x==-1) {
								translate([x*0, y*(controller_width+2)/2, plate_tin]) cube([20, 2, 3], center=true);
							}
							if (y==1) {
								translate([x*(controller_width+2)/2, 0, plate_tin]) cube([2, 20, 3], center=true);
							}
							
						}
					}
				}
				translate([0, 0, 0]) damperEars(DAMPER_EARS_DRAW_TOP, plate_color=top_plate_color);
				
			}
			for (x = [-1, 1]) { 
				for (y = [-1,1]) {
					holeDia = controller_case ? 4 : M25_outer_dia;
					translate([x*(cc3d_hole_width/2), y*(cc3d_hole_width/2), -1]) cylinder(d=holeDia, h=plate_tin+10, center=false, $fn=20);
				}
			}
			
			if (cutViewDebug) {
				translate([-20, -20, 0]) cube([15,15,10], center=true);
			}

			translate([0, 0, 0]) damperEars(DAMPER_EARS_CUT_TOP, plate_color=top_plate_color);
		}
		if (isFullView(viewType)) {
			translate([0, 0, plate_tin/2]) damperEars(DAMPER_EARS_SHOW_DAMPER, plate_color=top_plate_color, viewModule=viewModule);
			if (controller_case) translate([0, 0, plate_tin]) CC3DRevo_case();
			else translate([0, 0, plate_tin+1.8]) controller_board();			
		}
		
	}
	
	module bottomPlate()
	{
		
		module pillars($fn=30)
		{
			for (x = [-1, 1]) {
				for (y = [-1,1]) { 
					// pillar
					translate([x*pillar_hole_length/2, y*(pillar_hole_width/2), 0]) rotate([0, 0, 0]) {
						difference() {
							union() {
								color (bottom_plate_color) 
								{
									translate([0, 0, 0]) cylinder(d=M25_head_dia+3, h=6, center=false);
									hull()
									{
										translate([-x*10, -y*10, 0]) cylinder(d=M25_head_dia+8, h=plate_tin, center=false);
										translate([0, 0, 0]) cylinder(d=M25_head_dia+3, h=plate_tin, center=false);
									}
								}
								if (isFullView(viewType)) {
									translate([0, 0, 6]) pillar();
								}
							}
							// pillar's hole
							translate([0, 0, -0.1]) {
								//cylinder(d=M25_head_dia, h=4, center=false);
								cylinder(d=M25_inner_dia, h=16, center=false);
								hexaprismx(ri=5.3/2, h=6);
							}
							//if (cutView) color(cut_color) translate([-5, -0, 0]) cube([10,10,9]);
						}
					}
				}
			}
		}
		
		module plates($fn=30)
		{
			module fente(l=20, w=6)
			{
				translate([0, 0, 0]) hull()
				{
					translate([l/2, 0, 0]) cylinder(d=w, h=10, center=true);
					translate([-l/2, 0, 0]) cylinder(d=w, h=10, center=true);
				}
			}
			translate([0, 0, plate_tin/2]) {
				difference() {
					union() {
						roundCornersCube(157, option_hole_width+6, plate_tin, 3);
						roundCornersCube(36, 70, plate_tin, 2);
						//roundCornersCube(option_hole_width+6, 157, plate_tin, 5);
					}
					
					//roundCornersCube(30,35, plate_tin+0.1, 10);
					cube([22,26,plate_tin+2], center=true);
					roundCornersCube(31,31, plate_tin+0.1, 10);
					for(a=[0, 1]){
						rotate([0, 0, a*90]) roundCornersCube(16, 37, plate_tin+2, 3);
						ww=6;
						rotate([0, 0, a*180])  translate([0, 27, 0]) fente(w=7);
						rotate([0, 0, a*180+90])  translate([0, 26, 0]) fente(l=19);
						
						rotate([0, 0, a*180])  translate([55, 0, 0])  roundCornersCube(30,20, plate_tin+2, 3);
						
					}
				}
		
			}
			
		}
		module drawOptions(drawType=1){
			for (a = [0, 1]) {
				
				rotate([0, 0, a*180])   translate([(78.5)/2, 0, 0]) drawOptionSpacer(drawType=drawType, center=false);
				
				//rotate([0, 0, a*180+90])  translate([(78.5/2), 0, 0]) drawOptionSpacer(drawType=drawType, xaxis=[0], center=false);
			}
		}
		module powerModuleSpacer(d, h, center)
		{
			for (x = [-1, 1]) {
				
				for (y = [-1,1]) { 
					// power module spacer ring
					translate([x*(cc3d_hole_width/2), y*(cc3d_hole_width/2), 0]) cylinder(d=d, h=h, center=center, $fn=20);
				}
			}
			
		}
		
		difference() 
		{
			
			union()
			{
				color (bottom_plate_color) 
				{
					plates();
	
					translate([0, 0, 0]) damperEars(DAMPER_EARS_DRAW_BOTTOM);

					drawOptions(drawType=1);

					powerModuleSpacer(d=5.5, h=6, center=false);
					
				}
				// high pillars
				pillars();
			
			}
			
			T680Pro_holes();
			drawOptions(drawType=0);
			powerModuleSpacer(d=M25_inner_dia, h=20, center=true);
			
		}
		if (isFullView(viewType)) {
			T680Pro_holes(1);
			translate([0, 0, plate_tin+1.8+2]) powerBoard();
			
		}
		
	}
	
	module spacer(d=M25_outer_dia,$fn =30)
	{
		translate([0, 0, 1.5]) difference() {
			cube([10, 36, 3], center=true);
			for(y = [-11, 11]) {
				translate([0, y, -5]) cylinder(d=d, h=10);
			}
		}
	}

	if (viewType==FullView) {
		translate([0, 0, 0]) tarot680Pro_board();
		translate([0, 0, 15]) rotate([0,0,0])  controllerPlate();
		translate([0, 0, 0]) rotate([0,0,0])  bottomPlate();
		translate([-66.5, 0, 2.25]) rotate([0,0,0]) frskyD4Rbracket();
		translate([-35.6, 0, -3]) rotate([0,0,0]) spacer();
			
		translate([54.5, 21, plate_tin+5.8]) rotate([0,0,-90]) videoBracket();

		translate([0, 0, pillar_heigth+plate_tin+6]) rotate([180, 0, 0]) GPSBracket();

	}

	if (viewType==ViewAllModule) {
		translate([90, 80, 0]) rotate([0, 0, 0]) GPSBracket(ViewGPS1Type);
		translate([90, 170, 0]) rotate([0, 0, 0]) GPSBracket(ViewGPSARKBIRD);
		translate([80, 0, 0]) rotate([0,0,0])  controllerPlate();
		translate([140, 0, 0]) rotate([0,0,0])  controllerPlate(0);
		translate([0, 0, 0]) rotate([0,0,90])  bottomPlate();

		translate([180, 0, 0]) rotate([0,0,0])  videoBracket();
		
		translate([140, 80, 0]) rotate([0,0,0]) spacer();
		translate([160, 80, 0]) rotate([0,0,0]) spacer(M25_head_dia);
		translate([180, 60, 3]) rotate([-90,0,0])  pillar();

		translate([120, -70, 0]) rotate([0,0,0])  frskyD4Rbracket();
		
	} 
	if (viewType==ViewBottomPlate) {
		translate([0, 0, 0]) rotate([0,0,90])  bottomPlate();
	}
	
	if (viewType==ViewControllerPlate) {
		translate([0, 0, 0]) rotate([0,0,0])  controllerPlate();
		translate([70, 0, 0]) rotate([0,0,0])  controllerPlate(0);
	}
	if (viewType==ViewVideoBracket) {
		translate([0, 0, 0]) rotate([0,0,0])  videoBracket();
	}
	if (viewType==ViewFrskyBracket) {
		translate([0, 0, 0]) rotate([0,0,0])  frskyD4Rbracket();
		
	}
	
	if (viewType==ViewGPS1Type || viewType==ViewGPSARKBIRD || viewType==ViewGPSARKBIRD2) {
		translate([0, 0, 0]) rotate([0, 0, 0]) GPSBracket(viewType);
		for (x=[-1:2]) {
			translate([x*10, 50, 3]) rotate([-90,0,0])  pillar();
		}
	} 
	
}

 