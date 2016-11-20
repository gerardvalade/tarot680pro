// tarot 680 pro  - a OpenSCAD 
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


include <params.scad>
use <nutsnbolts/cyl_head_bolt.scad>
use <round-corners-cube.scad>

module bom(code, desc, category) {
	echo(str("BOM: ",code," - ", desc, "; ", category));
}

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

module pillar(l=pillar_heigth, $fn=30)
{
	color(pillar_color) difference() {
		translate([0, 0, l/2])  hexaprismx(ri=6/2, h=l);
		translate([0, 0, -1])  cylinder(d=M25_inner_dia, h=l+2);
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

module draw_option_spacer(draw_type=0, xaxis=[0,1], hole_dia=M25_inner_dia, heigth=10, center=true, $fn=30)
{
	hole_dia = draw_type == 0 ? hole_dia : 6;
	heigth = draw_type == 0 ? 10 : 8;
	zaxis = draw_type == 0 ? -1 : 0;
	for (x = xaxis) { 
		for (y = [-1,1]) {
			xpos = (center) ? (x*2-1) * option_hole_length/2 :  x * option_hole_length;
			ypos = y * option_hole_width/2;
			translate([xpos, ypos, zaxis])  rotate([0, 0, 0])  {
				if (draw_type == 0) cylinder(d=hole_dia, h=heigth+2, center=false);
				if (draw_type == 1) cylinder(d=hole_dia, h=heigth, center=false);
				if (draw_type == 2) translate([0, 0, 0]) rotate([0, 0, 0]) screw("M2.5x10");
				if (debug) #cylinder(d=0.2, h=heigth+20, center=false);
			}
		}
	}
}

module controller_board($fn=30)
{
	difference() {
		translate([0, 0, 1.24/2]) {
			color([0.9, 0.5, 0]) round_corners_cube(36.2, 36.2, 1.24, 3);
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
	translate([0, 0, (1.24+4)/2]) round_corners_cube(21.45, 24.33, 4, 3);
}




module damperEars(type, ear_lengthx=4, damper_dia=10.5, damper_angle=40, plate_color, cur_view=0, $fn=30)
{

	function is_damper_draw(n) = n[0]==0; 
	function is_damper_show(n) = n[0]==1;
	function is_damper_cut(n) = n[0]==2; 
	function is_damper_top(n) = n[1]==1; 
	function is_damper_bottom(n) = n[1]==0; 

	cte=0.45;
	damper_length= is_damper_bottom(type) ? 107 : 95+5;
	damper_width= is_damper_bottom(type) ? 67 : 56+5;
	damper_heigth= is_damper_bottom(type) ? 4.5 : 0;
	ear_length = is_damper_bottom(type) ? 7.9 : 6;
	
	module ear(x, tz=0, cte=0, ear_length, tin=plate_tin)
	{
		 hull() {
			translate([x*ear_length, 0, tz]) cylinder(d=13-cte, h=tin, center=true);
			translate([0, 0, tz]) cylinder(d=14-cte, h=tin, center=true);
		}
	}
	
	module drawEars() {
		//drawEars2();
		translate([0, 0, damper_heigth])
		for (x = [-1,1]) { 
			for (y = [-1,1]) {
				translate([(x*damper_width*cte), (y*damper_length*cte), 0]) rotate([0, 0, x*y*45]) { 
					if (is_damper_top(type)) translate([-x*5, 0, plate_tin/2]) cube([10, 14, plate_tin], center=true);
					if (is_damper_bottom(type)) translate([-x*5, 0, -(damper_heigth+plate_tin)/2]) cube([10, 13, plate_tin], center=true);
					if (is_damper_bottom(type)) translate([-x*1.3, 0, -damper_heigth/2]) cube([plate_tin*1.6, 13, damper_heigth], center=true);
				}
				translate([0,0,1]) difference() 
				{
					translate([(x*damper_width*cte), (y*damper_length*cte), 0]) rotate([0, 0, x*y*45]) rotate([0,-x*damper_angle, 0]) {  
						difference() 
						{
							union() {
								color(plate_color) ear(x, ear_length=ear_length);
							}
							ear(x, 1.5, 4, ear_length=ear_length);
							translate([x*ear_length, 0, 5])  rotate([0, 180, 0])  cylinder(d=6, h=40, center=false);
							if (cur_view && x==1)
							{
								translate([x*ear_length, -10, -5]) color(cut_color) cube([10, 20, 20]);
							}
						} 
					}
			
					// vertical truncate
					translate([(x*damper_width*cte), (y*damper_length*cte), -(3/2*plate_tin)])  cube([20, 20, plate_tin*2], center=true);
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
				translate([(x*damper_width*cte), (y*damper_length*cte), damper_heigth]) rotate([0, 0, x*y*45]) rotate([0,-x*damper_angle, 0]) {  
							
					difference() 
					{
						translate([x*ear_length, 0, -4.5]) color(damper_color) damper();
						if (cur_view && x==1)
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
				translate([(x*damper_width*cte), (y*damper_length*cte), damper_heigth]) rotate([0, 0, x*y*45]) {// rotate([0,-x*damper_angle, 0]) {  
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
	//if (is_damper_show(type) && viewModule) showDamper();
	if (is_damper_show(type)) showDamper();
	if (is_damper_cut(type)) cutDamper();
}
