// tarot 680 pro plate - a OpenSCAD 
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

include <round_corners_cube.scad>
include <nutsnbolts/cyl_head_bolt.scad>;


module tarot680Pro_board( $fn=30)
{
	module hexaprismx(
		ri =  1.0,  // radius of inscribed circle
		h  =  1.0)  // height of hexaprism
	{ // -----------------------------------------------
	
		ra = ri*2/sqrt(3);
		cylinder(r = ra, h=h, $fn=6, center=true);
	}
	
	//color([2,0,0]) translate([0,0,13]) cube([220, 1, 1], center=true);
	module canopyHolder(type=0)
	{
		module holeScrew(d=4.73, h=10)
		{
			if (type==0) cylinder(d=d, h=10, center=true);
			if (type==1) {
				cylinder(d=d, h=h, center=false);
				translate([0, 0, h])  cylinder(d=2.5, h=2, center=false);
				translate([0, 0, h+2])  cylinder(h=4,r1=1.6,r2=0.5, center=false);
				translate([0, 0, 0])  cylinder(d=d+1, h=7.5, center=false, $fn=6);
				if (h>14)
					translate([0, 0, 12])  cylinder(d=d+1, h=7.5, center=false, $fn=6);
			}
		}
		translate([0, -(147+13.5)/2, 0]) holeScrew(h=26);
		for (r=[135, 45]) {
			for (x = [202-18]) { 
				rotate([0,0,r]) translate([(x/2), 0, 0]) holeScrew(h=14);
			}
		}
	}

	module canopy2D(type=0)
	{
		module halfCanopy()
		{
		
			pt1 = [0, -80.5]; 
			pt2 = [92*cos(45), 92*sin(135)];
			pt3 = [0, 92*sin(135)];
			//translate([0,0,-6]) color([.2,.2,.2]) polygon([pt1, pt2, pt3]);
			
			p1 = [0, -80.5-27]; 
			p2 = [7.5, -80.5-27]; 
			p3 = [7.5+32, -80.5-27-20]; 
			p4 = [96, -80.5-27-20+46]; 
			p5 = [92*cos(45)+34, 92*sin(135)-25];
			p6 = [92*cos(45)-9.4, 92*sin(135)+35];
			p7 = [20, -80.5+205];
			p8 = [0, -80.5+205];

			translate([0, 0, -0.5]) color([0.1, .1, 0.12]) polygon([p1, p2, p3, p4, p5, p6, p7, p8]);
			
		}
		halfCanopy();
		mirror([1, 0, 0]) halfCanopy();
	}

	module canopy3D(type=0)
	{
		module halfCanopy()
		{
			hexr = 40;
			hexh = 61;
			ph0 = [0, 0, hexh];
			ph1 = [0, hexr*sin(60), hexh];
			ph2 = [hexr*cos(60), hexr*sin(60), hexh];
			ph3 = [hexr, 0, hexh];
			ph4 = [hexr*cos(60), hexr*sin(-60), hexh];
			ph5 = [0, -hexr*sin(60), hexh];

			fah1 = [0, 1, 2];
			fah2 = [0, 2, 3];
			fah3 = [0, 3, 4];
			fah4 = [0, 4, 5];
			polyhedron
    		(points = [ ph0, ph1, ph2, ph3, ph4, ph5
	       
	       	], 
     		faces = [ fah1, fah2, fah3, fah4
     			
		  	]);
		
			pt1 = [0, -80.5]; 
			pt2 = [92*cos(45), 92*sin(135)];
			pt3 = [0, 92*sin(135)];
			//translate([0,0,-6]) color([.2,.2,.2]) polygon([pt1, pt2, pt3]);
			
			p1 = [0, -80.5-27]; 
			p2 = [7.5, -80.5-27]; 
			p3 = [7.5+32, -80.5-27-20]; 
			p4 = [96, -80.5-27-20+46]; 
			p5 = [92*cos(45)+34, 92*sin(135)-25];
			p6 = [92*cos(45)-9.4, 92*sin(135)+35];
			p7 = [20, -80.5+205];
			p8 = [0, -80.5+205];

			//translate([0, 0, -1]) color([0.1, .1, 0.12, 0.25]) polygon([p1, p2, p3, p4, p5, p6, p7, p8]);
			
			p1 = [0, -80.5-27, 0]; 
			pe12 = [0, -80.5-27+12, 29.5]; 
			p2 = [7.5, -80.5-27, 0]; 
			pe22 = [7.5+6, -80.5-27+12, 29.5]; 
			p3 = [7.5+32, -80.5-27-20, 0]; 
			pe32 = [7.5+32, -80.5-27-20+25, 46.2]; // 5 ?
			
			p4 = [96, -80.5-27-20+46, 0]; 
			pe42 = [96-22, -80.5-27-20+46, 34]; 

			p45 =[92*cos(45)+34, 92*sin(135)-25-34, 0];
			pe45 =[92*cos(45)+34-30, 92*sin(135)-25-55, 47];
			
			p5 =[92*cos(45)+34, 92*sin(135)-25, 0]; // 10
			pe52 =[92*cos(45)+34-15, 92*sin(135)-25-17, 30.5];
			pe53 =[92*cos(45)+34-9, 92*sin(135)-25+9, 15]; //?
			
			p6 = [92*cos(45)-9.4, 92*sin(135)+35, 0]; // 13 
			pe62 = [92*cos(45)-9.4-5, 92*sin(135)+35, 15]; // 14 ??
			
			p7 = [20, -80.5+205];
			p8 = [0, -80.5+205];
			
			fa1 = [0, 1, 2];
			fa2 = [1, 2, 3];
			fa3 = [2, 3, 4];
			fa4 = [3, 4, 5];
			fa5 = [4, 5, 6];
			fa6 = [5, 6, 7];
			fa7 = [6, 7, 8];
			fa8 = [7, 8, 9];
			fa9 = [8, 9, 10];
			fa10 = [9, 10, 11];
			fa11 = [10, 11, 12];
			fa12 = [10, 12, 13];
			fa13 = [12, 13, 14];
			
			polyhedron
    		(points = [p1, pe12, p2, pe22, p3, pe32, p4, pe42, p45, pe45, p5, pe52, pe53, p6, pe62
	       
	       	], 
     		faces = [
     			fa1, fa2, fa3, fa4, fa5, fa6, fa7, fa8, fa9, fa10, fa11, fa12, fa13
		  	]
     );
			
			
		}
		//translate([0,0,51]) hexaprismx(ri=67/2, h=1);
		halfCanopy();
		mirror([1, 0, 0]) halfCanopy();
	}
	

	module allHoles(type=0)
	{
		
		module hole(d)
		{
			if (type==0) cylinder(d=d, h=10, center=true);
		}
		module holeScrew(d)
		{
			if (type==0) cylinder(d=d, h=10, center=true);
			if (type==1) translate([0, 0, 0]) screw("M2.5x25");
		}

		module quater() {
			// holes
			for (x = [1]) { 
				translate([(x*42.5/2), (73.5/2), 0]) hole(d=M25_outer_dia);

				translate([(x*46/2), (146/2), 0]) hole(d=M25_outer_dia);
				translate([(x*74/2), (146/2), 0]) hole(d=M25_outer_dia);

				translate([(x*61/2), (178/2), 0]) hole(d=M25_outer_dia);
				translate([(x*77/2), (168/2), 0]) hole(d=M25_outer_dia);
			}
			
			// inner, middle, external holes
			for (x = [71.5, 148]) { 
				translate([(x/2), (22/2), 0]) hole(d=M25_outer_dia);
			}
			for (x = [159]) { 
				translate([(x/2), (41/2), 0]) hole(d=M25_outer_dia);
				translate([(x/2), (59.5/2), 0]) hole(d=M25_outer_dia);
			}
			for (x = [185]) { 
				translate([(x/2), (22/2), 0]) holeScrew(d=M25_outer_dia);
			}
			
		}
		module half() {
			quater();
			mirror([1,0,0]) quater();
		}
		half();
		mirror([0,1,0]) half();
	}
	
	module middle()
	{
		module quater()
		{
			linear_extrude(height = 10, center = true, convexity = 10)
			polygon(points=[[0, 0],
				[0, 57/2], [12/2, 57/2], [16/2, 61/2],	[35/2, 61/2], [47/2, 48.5/2], [47/2, 37/2],
				[58.3/2, 20/2], [58.3/2, 0]
			]);
		}
		quater();
//		mirror([1,0,0]) quater();
//		mirror([0,1,0]) quater();
//		mirror([1,0,0]) mirror([0,1,0]) quater();
		
	}
	
	module shapes()
	{
		module halfShape()
		{
			linear_extrude(height = 10, center = true, convexity = 10)
			polygon(points=[[0, 0],
				[0, 18], [18.23/2, 18], [21.48/2, 19.5], [28.5/2, 19.5],
				[37/2, 13], [23/2, 1.5], [11.5/2, 1.5], [10/2, 0],
			]);
			
		}
		module quater() {
			for (a=[0, -60]) {
				rotate([0,0,a]) translate([0, (119)/2, 0]) {
					halfShape();
					if (a) mirror([1,0,0]) halfShape();
				}
			}
			
		}
		quater();
	}
	
	module topBottom()
	{
		module half()
		{
			linear_extrude(height = 10, center = true, convexity = 10)
			polygon(points=[[0, 0],
				[30/2, 0], [30/2, 2], [46/2, 6.54], [59/2, 6.54], [59/2, 10],
				[0, 23] 
			]);
			
		}
		translate([0, 185/2, 0]) half();
	}
	
	module externalShape()
	{
		module half()
		{
			linear_extrude(height = 10, center = true, convexity = 10)
			polygon(points=[[0, 0],
				[40/2, 0], [47/2, 7], [59/2, 7], [59/2, 10],
				[0, 23] 
			]);
			
		}
		rotate([0,0,-60]) translate([0, 185/2, 0]) {
			half();
			mirror([1,0,0]) half();
		}
				
	}
	
	module holesShape(external=true) {
		module quater(){
			// middle hole
			middle();

			// holes shapes x 6
			shapes();
			
			if (external) {
				topBottom();
				externalShape();
			}
			
		}
		module half() 
		{
			mirror([1,0,0]) quater();
			quater();
		}
		
		half();
		mirror([0,1,0]) half();
	}

	module tube()
	{
		module half_tube()
		{
			translate([70, 0, -12]) rotate([0,90, 0]) difference()
			{
				cylinder(d = 16, h=150, $fn=30 , center=false);
				translate([0, 0, -1]) cylinder(d = 14, h=200, $fn=30 , center=false);
			}
			
		}		
		half_tube();
	}	
	module plate(viewAll=0) {
		difference() {
			rotate([0, 0, 15]) color([0.3, 0.3, 0.3])  cylinder(r = 100, h=1.9, $fn=12, center=true);

			holesShape();
			allHoles(0);
			canopyHolder(0);
		}
		if (viewAll) {
			allHoles(1);
			canopyHolder(1);
			for(rot=[0:60:360])
				rotate([0, 0, rot])tube();
		}
		
	}
	translate([0, 0, -0.5])  {
		plate(1);
		//translate([0, 0, -24])  plate();
	}
	translate([0, 0, 0])  
		difference() {
			canopy2D();
			
			holesShape(false);
		}
}

tarot680Pro_board();

