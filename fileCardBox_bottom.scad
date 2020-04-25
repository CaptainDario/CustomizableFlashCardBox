use <parametric_butt_hinge.scad>;

// file card box (1 unit == 1mm)
// releases:
//
//      v 1.0 - initial release



/* [general] */
//the thickness of all walls
wallStrength = 3;

/* [file card] */
//file card height
fH = 52;
//file card height
fW = 74;
//the space between card and box (should not be zero)
space = 2;

/* [lid] */
//the height of the lid
lH = 10;

/* [Bottom] */
//should not be < 1
nrOfSeperators = 5;

/* [Hidden] */
//box dimensions
//box width
w = fW + space;
//box depth
d = 250 ; 
// box height
h = fH + space;

//spaceBetweenSeperators
sBS = (d - wallStrength * (2 + nrOfSeperators)) / (nrOfSeperators + 1);


module file_card_box_main(){

    difference(){
        boxBottom();

        translate([-wallStrength * 1.5, d/2, h]){
            rotate([180, 90, 0]){
                main();
            }
        }
    };

    translate ([0, 0, h]){
        boxTop();
    };
}


module boxBottom (){
    union() {
        union() {   
            difference() {
                
                //shell
                cube ([w, d, h]) ;
                
                //remove inside
                translate([wallStrength, wallStrength, wallStrength]){
                    cube ([w - wallStrength*2, d-wallStrength*2, h-wallStrength+00.1]);
                }
            };
            //seperators
            for (i=[0:nrOfSeperators - 1])
                // first wall + already set walls + the wall strength of the set walls
                translate([0, wallStrength + sBS + (i * sBS) + (i * wallStrength), 0]){
                    cube([w, wallStrength, h - lH]);
            }
        }
    }
}

module boxTop (){
    difference() {

        union() { 
            //shell
            cube ([w, d, lH]) ;

            translate([wallStrength / 2, wallStrength / 2, 0]) {
                cube([w - wallStrength, d - wallStrength, lH]);
            }
        }
        //remove inside
        translate([wallStrength, wallStrength, wallStrength]){
            cube ([w - wallStrength*2, d-wallStrength*2, h-wallStrength+0.1]);
        }
    };
}


//MAIN
file_card_box_main();
