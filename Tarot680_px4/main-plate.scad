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
use <library/round-corners-cube.scad>
use <library/modules-utils.scad>


	
	
module bottomPlate(viewType=1)
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
							if (isfull_view(viewType)) {
								translate([0, 0, 6]) pillar();
							}
						}
						// pillar's hole
						translate([0, 0, -0.1]) {
							//cylinder(d=M25_head_dia, h=4, center=false);
							cylinder(d=M25_inner_dia, h=16, center=false);
							hexaprismx(ri=5.3/2, h=6);
						}
						//if (cut_view) color(cut_color) translate([-5, -0, 0]) cube([10,10,9]);
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
					round_corners_cube(157, option_hole_width+6, plate_tin, 3);
					//round_corners_cube(36, 70, plate_tin, 2);
					round_corners_cube(60, 95, plate_tin, 2);
					//round_corners_cube(option_hole_width+6, 157, plate_tin, 5);
					round_corners_cube(option_hole_width+6, 178, plate_tin, 3);
				}
				
				//round_corners_cube(30,35, plate_tin+0.1, 10);
				cube([22,26,plate_tin+2], center=true);
				round_corners_cube(31,31, plate_tin+0.1, 10);
				for(a=[0, 1]){
					rotate([0, 0, a*90]) round_corners_cube(16, 37, plate_tin+2, 3);
					ww=6;
					rotate([0, 0, a*180])  translate([0, 27, 0]) fente(w=7);
					rotate([0, 0, a*180+90])  translate([0, 26, 0]) fente(l=19);
					
					rotate([0, 0, a*180])  translate([55, 0, 0]) round_corners_cube(30,20, plate_tin+2, 3);
					rotate([0, 0, a*180+90]) translate([57, 0, 0]) round_corners_cube(30,20, plate_tin+2, 3);
					rotate([0, 0, a*180+90])  hull() {
						translate([80, 0, 0]) cylinder(d=7, h=50, center=true);
						translate([82, 0, 0]) cylinder(d=7, h=50, center=true);
					}
					
				}
			}
	
		}
		
	}
	module drawOptions(draw_type=1){
		for (a = [0, 1]) {
			
			rotate([0, 0, a*180])   translate([(78.5)/2, 0, 0]) draw_option_spacer(draw_type=draw_type, center=false);
			//rotate([0, 0, a*180+90])   translate([(78.5)/2, 0, 0]) draw_option_spacer(draw_type=draw_type, center=false);
			rotate([0, 0, a*180+90])   translate([50, 0, 0]) draw_option_spacer(draw_type=draw_type, center=false);
			
			//rotate([0, 0, a*180+90])  translate([(78.5/2), 0, 0]) draw_option_spacer(draw_type=draw_type, xaxis=[0], center=false);
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

				drawOptions(draw_type=1);

				powerModuleSpacer(d=5.5, h=6, center=false);
				
			}
			// high pillars
			pillars();
		
		}
		
		T680Pro_holes();
		drawOptions(draw_type=0);
		powerModuleSpacer(d=M25_inner_dia, h=20, center=true);
		
	}
	if (isfull_view(viewType)) {
		T680Pro_holes(1);
		translate([0, 0, plate_tin+1.8+2]) powerBoard();
		
	}
	
}
	
bottomPlate();