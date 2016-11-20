// tarot 680 pro - a OpenSCAD 
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


include <library/params.scad>
use <library/modules-utils.scad>


module pillar(l=pillar_heigth, $fn=30)
{
	color(pillar_color) difference() {
		translate([0, 0, l/2])  hexaprismx(ri=6/2, h=l);
		translate([0, 0, -1])  cylinder(d=M25_inner_dia, h=l+2);
	}
}

module pillars($fn=30)
{
	for (x = [-1, 1]) {
		for (y = [-1,1]) { 
			translate([x*pillar_hole_length/2, y*(pillar_hole_width/2), 6])
					 pillar();
		}
	}
}

for (x = [0 : 3]) translate([x*10, 0, 3]) rotate([90,0,0]) pillar();