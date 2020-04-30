//font(s)
use <./fonts/togalite/togalite-bold.otf>;
//models

// file card box (1 unit == 1mm)
// releases:
//
//      v 1.0 - initial release
//          - resizable box 
//          - text for lid and box
//          - 


/* [general] */
//the thickness of all walls
wall_strength = 3;
enable_bottom = true;
enable_lid = true;

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
enable_lid_text = true;
lid_box_text = "日本語の単語";
lid_text_font = "togalite-bold";
lid_text_size = 20;
lid_text_extrusion = 4;

/* [Bottom] */
//should not be < 1
nrOfSeperators = 5;
enable_bottom_text = true;
bottom_box_text = "日本語の単語";
bottom_text_font = "togalite-bold";
bottom_text_size = 20;
bottom_text_extrusion = 4;

/* [Hidden] */
//box dimensions
//box width
w = fW + space;
//box depth
d = 250 ; 
// box height
h = fH + space;
//spaceBetweenSeperators
sBS = (d - wall_strength * (2 + nrOfSeperators)) / (nrOfSeperators + 1);


module FileCardBoxMain(){

    union(){
        //bottom
        if(enable_bottom){
            BoxBottom();
        }

        //top
        if(enable_lid){
            BoxTop();
        }
    };
}


module BoxBottom (){
    union() {
        //text
        translate([w, d/2, h/2]){
            rotate([90, 0, 90]){
                BottomBoxText();
            }
        }
        //box
        union() {
            union() {   
                difference() {
                    
                    union() {
                        //shell
                        cube ([w, d, h]) ;
                        translate([wall_strength/2, wall_strength/2, h]){
                            cube([w - wall_strength, d - wall_strength, lH/2]);
                        };
                    };
                    
                    //remove inside
                    translate([wall_strength, wall_strength, wall_strength]){
                        cube ([w - wall_strength*2, d-wall_strength*2, lH+h-wall_strength+00.1]);
                    };
                };
                //seperators
                for (i=[0:nrOfSeperators - 1])
                    // first wall + already set walls + the wall strength of the set walls
                    translate([0, wall_strength + sBS + (i * sBS) + (i * wall_strength), 0]){
                        cube([w, wall_strength, h - (lH/2 + 2)]);
                }
            }
        }
    }
}

module BoxTop (){
    rotate([180, 0, 0]){
        difference() {

            //shell
            cube ([w, d, lH]);
            //remove inside
            translate([wall_strength, wall_strength, wall_strength]){
                cube ([w - wall_strength*2, d-wall_strength*2, h-wall_strength+0.1]);
            }
        };
    }
}

module BottomBoxText (){
    linear_extrude(bottom_text_extrusion){
        text(text=bottom_box_text, size=bottom_text_size, font=bottom_text_font,
        halign="center", valign="center");
    };
}

module LidBoxText (){
    linear_extrude(lid_text_extrusion){
        text(text=lid_box_text, size=lid_text_size, font=lid_text_font,
        halign="center", valign="center");
    };
}

//MAIN
FileCardBoxMain();