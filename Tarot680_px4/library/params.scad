FullView			= 0;
ViewAllModule		= 1;
ViewBottomPlate     = 2;
ViewControllerPlate = 3;
ViewFrskyBracket    = 4;
ViewVideoBracket    = 5;
ViewGPS1Type 		= 6;
ViewGPSARKBIRD		= 7;
ViewGPSARKBIRD2		= 8;

function isFullView(n) = n==FullView;

bottom_plate_color = [0.3, 0.7, 0.7];
top_plate_color = [0.8, 0.8, 0.3];
damper_color = [0.8, 0.2, 0.3];
gps_bracket_color = [0.3, 0.8, 0.3, 1];
option_bracket_color = [0.8, 0.8, 0.3];
pillar_color = [0.8, 0.5, 0.3];
cut_color = [0.9, 0, 0];

cc3d_hole_width = 30.5;
cutView=true;

M25_outer_dia=2.8; 
M25_inner_dia=2.05; 
M25_head_dia=5;
M3_outer_dia=3.5; 
M3_inner_dia=2.8;
M3_head_dia=5.4+0.5;
// SMA Thread
M6_outer_dia=6.3;



plate_tin = 2.2;

pillar_heigth = 34;

pillar_hole_width = 64;
pillar_hole_length = 64;

option_hole_length = cc3d_hole_width;
option_hole_width = cc3d_hole_width;

//viewModule = isFullView(viewType);
cutViewDebug=0;


DAMPER_EARS_DRAW_TOP=[0,1];
DAMPER_EARS_DRAW_BOTTOM=[0,0];
DAMPER_EARS_SHOW_DAMPER=[1,1];
DAMPER_EARS_CUT_BOTTOM=[2,0];
DAMPER_EARS_CUT_TOP=[2,1];

