// video transmitter - a OpenSCAD 
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

module videoTX($fn = 30)
{
	gold = [0.9, 0.8, 0.2];
	white = [0.9, 0.9, 0.9];
	black = [0.2, 0.2, 0.2];
	module connector(w)
	{
		 difference() {
			color(black)  cube([w, 12, 6.5], center=false);
			color(white) translate([1,-2, 1]) cube([w-2, 10, 4.5], center=false);
		}
	}
		
	translate([0, 0, 0.6]) color([0.4, 0.4, 0.4]) cube([26.24, 38.25, 1.2], center=true);
	translate([0, 0, 1.2]) {
		translate([1, 5, 0]) color(black) cube([11, 11, 5.5], center=false);
		translate([0, -6, 0]) cylinder(d=8.26, h=6);
		translate([8.5, -6, 0]) cylinder(d=6.76, h=6);
	} 
	translate([-12, -12, -10.5]) cube([25, 30, 10.5], center=false);
//	translate([6, 19, -4]) rotate([-90,0,0]) color(gold)  cylinder(d=6.26, h=13);
	translate([7.2, 19, -5]) rotate([-90,0,0]) {
		difference() {
		color(gold)  cylinder(d=6.21, h=13);
		translate([0,0,11]) color(white)  cylinder(d=5, h=3);
		}
		color(gold)  cylinder(d=0.5, h=13);
	} 
	translate([-12, -28, -6.5])  connector(10);
	translate([4, -28, -6.5])  connector(7.8); //color(black)  cube([7.8, 12, 6.5], center=false);
}

//videoTX();
