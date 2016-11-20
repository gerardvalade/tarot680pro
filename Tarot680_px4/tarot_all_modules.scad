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


use <main-plate.scad>
use <px4-controller-plate.scad>
use <pillar.scad>
use <gps_bracket.scad>
use <video_bracket.scad>
use <cable_holder.scad>
use <frskyD4R_bracket.scad>

//use <frsky.scad>
 
translate([0, 0, 0]) bottomPlate();
//translate([0, 0, 1]) controllerPlate();
translate([0, 150, 0]) controllerPlate();
for (x = [0 : 3]) translate([x*10+50, 120, 3]) rotate([90,0,0]) pillar();
//translate([130, 110, 0]) gps_bracket();
translate([130, 0, 0]) video_bracket();
translate([130, -50, 0]) video_bracket2();
translate([-130, 0, 0]) cable_holder();
translate([-100, 100, 0])  frskyD4R_bracket(false);