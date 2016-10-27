
$fn=30;
difference() {
cube([27, 20.5, 5], center=true);
cylinder(d= 17, h=10 , center=true);
cube([28,6,10], center=true);

#translate([11,0,0]) rotate([90,0,0]) cylinder(d= 2.3, h=30 , center=true);
#translate([-11,0,0]) rotate([90,0,0]) cylinder(d= 2.3, h=30 , center=true);
}