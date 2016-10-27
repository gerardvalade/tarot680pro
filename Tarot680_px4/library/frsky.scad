// frsky - a OpenSCAD 
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

module frskyD4R($fn = 4)
{
	module connector()
	{
		//translate([31.12/2, -3, 2.5]) color([0.9, 0.8, 0.2])
		color([0.2, 0.2, 0.2]) cube([2.5, 15, 5], center=false);
		translate([0, 1, 1]) color([0.9, 0.8, 0.2])
			for (y=[0:5]) {
				translate([0, y*2.54, 0]) rotate([0, 90, 0]) cylinder(d=.6, h=8.5);
				translate([0, y*2.54, 2.54]) rotate([0, 90, 0]) cylinder(d=.6, h=8.5);
			}
		
	}
	module telemetryPort()
	{
		color([0.9,0.9,0.9])
		difference() { 
			cube([7.5, 4.5, 3.0], center=true);
			cube([7, 5, 2.5], center=true);
		
		}
		color([0.9, 0.8, 0.2]) for (x=[0:3]) {
			translate([x*1.25-1.9, 2.8, 0]) rotate([90, 0, 0]) cylinder(d=.5, h=5);
		}
		
	}

	difference() {	
		translate([0, 0, 7.34/2]) color([0.4, 0.4, 0.4]) cube([31.12, 23.16, 7.34], center=true);
		translate([11.9, -9.5, 6.0]) 
				cube([7.5, 4.5, 3.0], center=true);
	}
	translate([11.9, -9.5, 6.0]) telemetryPort();	
	translate([31.12/2, -7.34, 2]) connector();

}

frskyD4R();