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

$fn=30;
length = 27+8;
width = 30;
heigth = 13;

module XT90Base()
{
	translate([4, 0, (heigth)/2]) {
		cube([length,width,heigth], center=true);
		//translate([(length-5)/2,0,0]) cube([5,30,heigth], center=true);
	}
}


module XT90positf(cut=4.9)
{
	difference() {
		cube([20,21,10], center=true);
		translate([0, 10.5, 5]) rotate([45, 0, 0]) cube([21,cut,cut], center=true);
		translate([0, 10.5, -5]) rotate([45, 0, 0]) cube([21,cut,cut], center=true);
	}
	
}
	

module XT90HoleScrew(dia=2.2, h=10)
{
	for(x=[1,-1]) for(y=[1, -1]) translate([x*10, y*12.5, 0]) cylinder(d=dia, h=h, center=true);	
}

module XT90()
{
	module XT90Hole()
	{
		translate([(length-20+8)/2+0.02, 0, 10/2+0.4]) {
			XT90positf(cut=4.4);
			translate([0, 0, -5]) cube([20,21,10], center=true);
			translate([-6.5, -2, 3.5+1]) cube([6.4,15,2], center=true);
			//translate([-(20+10)/2 + 0.02, 0, -1.5])cube([10, 19.5, 12], center=true);
			translate([-(20+20)/2 + 0.02, 0, -1.5])cube([20, 19.5, 12], center=true);
		}
	}

	translate([0, 0, heigth]) rotate([0, 180, 0]) {
		difference()
		{
			XT90Base();
			XT90Hole();
			XT90HoleScrew();
		}
	}
}
module XT90Plate()
{
	module BasePlate()
	{
		translate([0, 0, 0]) {
			difference() {
				translate([-4, 0,  1.8/2])  cube([length+0.5,width+0.5,1.8], center=true);
				translate([0, 0, 0]) hull() {
					translate([0, -4, 0]) cylinder(d=12, h=10, center=true);
					translate([0, 4, 0]) cylinder(d=12, h=10, center=true);
				}
			}
		}
	}
	difference() {
		BasePlate();
		XT90HoleScrew(dia=3.5);
	}
}

module XT90PlateFixing()
{
	module BasePlate()
	{
		module hole()
		{
			translate([0, 0, 0]) hull() {
				translate([0, -4, 0]) cylinder(d=12, h=10, center=true);
				translate([0, 4, 0]) cylinder(d=12, h=10, center=true);
			}
		}
		
		translate([0, 0, 0]) {
			translate([0, 0, 5/2]) XT90HoleScrew(dia=6.5, h=5);
			difference() {
				translate([0, 0,  1.8/2])  cube([length+0.5-8,width+0.5,1.8], center=true);
				hole();
			}
		}
	}
	difference() {
		BasePlate();
		XT90HoleScrew(dia=2.7, h=15);
	}
}

module XT90PlateLed()
{
	module BasePlate()
	{
		module led_hole(d=2, h=15)
		{
			for(z = [-1, 1]) for(y = [-1, 1])
			{
				//#translate([-20, y*26.5/2, z*(16/2) + 21/2]) rotate([0, 90, 0]) cylinder(d=d, h=h, center=true);
				translate([-20,  z*(15+3) , y*26.5/2 +46/2]) rotate([0, 90, 0]) cylinder(d=d, h=h, center=true);
			}
			
		}
		module hole()
		{
			translate([0, 0, 0]) hull() {
				translate([0, -4, 0]) cylinder(d=12, h=10, center=true);
				translate([0, 4, 0]) cylinder(d=12, h=10, center=true);
			}
			led_hole();
		}
		module plate()
		{
			translate([0, 0, 1.8/2])  cube([length+0.5,width+0.5,1.8], center=true);
			translate([-9.4, 0, 1.8/2])  cube([17, width+11,1.8], center=true);
			#translate([-14.9, 0, 1.8/2+1.8])  cube([6, width+11,1.8], center=true);
			//translate([-length/2, 0, 21/2])  cube([2, 46, 21], center=true);
			/*for(y = [-1, 1])
			translate([-17, y*9, 0]) rotate([90,0,0])
				linear_extrude(height = 1.8, center = true, convexity = 10, twist = 0)
					polygon( points=[[0,0],[10,0],[0,20]] ); */ 
			//translate([4, 0, 0]) led_hole(d=4, h=5);
			for(y = [-1, 1])
			{
				translate([-length/2+1, y*21.8, 46/2])  cube([2, 12, 46], center=true);
				translate([-14, y*18, 46/2]) rotate([0, 90, 0])
				hull()
				{
				 	translate([ -26.5/2, 0, 0]) cylinder(d=4.5, h=6, center=true);
				 	translate([26.5/2 +7.5, 0, 0]) cylinder(d=4.5, h=6, center=true);
				}
			}
			
		}
		
		translate([0, 0, 0]) {
			difference() {
				translate([-4, 0, 0])  plate();
				hole();
			}
		}
	}
	difference() {
		BasePlate();
		XT90HoleScrew(dia=3.5);
		translate([0, 0, 1.8+10/2]) XT90HoleScrew(dia=6, h=10);
	}
}

module XT90PlateLed2()
{
	module BasePlate()
	{
		module led_hole(d=2, h=10)
		{
			for(z = [-1, 1]) for(y = [-1, 1])
			{
				translate([-20, y*26.5/2, z*(16/2) + 21/2]) rotate([0, 90, 0]) cylinder(d=d, h=h, center=true);
			}
			
		}
		module hole()
		{
			translate([0, 0, 0]) hull() {
				translate([0, -4, 0]) cylinder(d=12, h=10, center=true);
				translate([0, 4, 0]) cylinder(d=12, h=10, center=true);
			}
			led_hole();
		}
		module plate()
		{
			translate([0, 0, 1.8/2])  cube([length+0.5,width+0.5,1.8], center=true);
			translate([-length/2, 0, 21/2])  cube([2, 46, 21], center=true);
			/*for(y = [-1, 1])
			translate([-17, y*9, 0]) rotate([90,0,0])
				linear_extrude(height = 1.8, center = true, convexity = 10, twist = 0)
					polygon( points=[[0,0],[10,0],[0,20]] ); */ 
			translate([4, 0, 0]) led_hole(d=4, h=5);
			for(y = [-1, 1])
			{
				translate([-15, y*26.5/2, 21/2]) rotate([0, 90, 0])
				hull()
				{
				 translate([16/2, 0, 2]) cylinder(d=4.5, h=10, center=true);
				 translate([ -16/2, 0, 0]) cylinder(d=4.5, h=6, center=true);
					
				}
			}
			
		}
		
		translate([0, 0, 0]) {
			difference() {
				translate([-4, 0, 0])  plate();
				hole();
			}
		}
	}
	difference() {
		BasePlate();
		XT90HoleScrew(dia=3.5);
		translate([0, 0, 1.8+10/2]) XT90HoleScrew(dia=6, h=10);
	}
}
	
	
translate([50, 0, 0])  rotate([0, 0, 0]) XT90();
translate([50, 50, 0]) XT90Plate();

translate([0, 0, 0]) XT90PlateLed();
translate([0, 100, 0]) XT90PlateLed2();
translate([0, 50, 0]) XT90PlateFixing();
