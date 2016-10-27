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
length = 27;
width = 30;
heigth = 13;

module XT90Base()
{
	translate([0,0,(heigth)/2]) {
		cube([length,width,heigth], center=true);
		translate([(length-5)/2,0,0]) cube([5,30,heigth], center=true);
	}
}
module XT90BasePlate()
{
	translate([0,0,1.8/2]) {
		difference() {
			cube([length+0.5,width+0.5,1.8], center=true);
			hull() {
				translate([0, -4, 0]) cylinder(d=12, h=10, center=true);
				translate([0, 4, 0]) cylinder(d=12, h=10, center=true);
			}
		}
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
	

module XT90HoleScrew(dia=2.2)
{
	for(x=[1,-1]) for(y=[1, -1]) translate([x*10, y*12.5, 2]) cylinder(d=dia, h=10, center=true);	
}

module XT90Hole()
{
	translate([(length-20)/2+0.02, 0, 10/2+0.4]) {
		XT90positf(cut=4.4);
		translate([0, 0, -5]) cube([20,21,10], center=true);
		translate([-6.5, -2, 3.5+1]) cube([6.4,15,2], center=true);
		translate([-(20+10)/2 + 0.02, 0, -1.5])cube([10, 19.5, 12], center=true);
	}
}

module XT90()
{
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
	difference() {
		XT90BasePlate();
		XT90HoleScrew(dia=2.7);
	}
}
	
translate([0, 0, 0])  rotate([0, 0, 0]) XT90();
translate([0, 40, 0]) XT90Plate();