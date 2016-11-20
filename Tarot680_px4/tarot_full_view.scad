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


//include <library/tarot680Modules.scad>
include <library/params.scad>
use <library/tarot680pro.scad>
use <main-plate.scad>
use <px4-controller-plate.scad>
use <pillar.scad>
use <gps_bracket.scad>
use <cable_holder.scad>
use <video_bracket.scad>
use <pcb_holder.scad>
use <frskyD4R_bracket.scad>

full_view=true;
 
//translate([0, 0, 0]) tarot680Modules(full_view, 1);
translate([0, 0, 0]) bottomPlate();
translate([0, 0, 12]) controllerPlate(full_view);
translate([0, 0, 0]) tarot680Pro_board();
pillars();
//translate([0, 0, pillar_heigth+6]) gps_bracket();
translate([0, 0, pillar_heigth+6]) cable_holder();

//translate([33.5, 0, 8]) rotate([0, 0, 0]) video_bracket();
translate([54.5, 0, 8]) rotate([0, 0, 90]) video_bracket2(full_view);
//translate([54.5, 0, 8]) antenna_backet();
translate([0, -65.3, 8]) rotate([0, 0, 0]) pcb_holder(full_view);
translate([-54.5, 0, plate_tin])  frskyD4R_bracket(full_view);