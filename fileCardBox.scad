// file card box (1 unit == 1mm)
// releases:
//      v 1.0.1  - added font example
//          - changed defaults
//
//      v 1.0    - initial release:
//          - resizable box 
//          - text for lid and box
//          - select different file card sizes to match your needs 


/* [general] */
//
enable_bottom = true;
enable_lid = true;
text_resolution = 25;

/* [file card] */
//file card height
fH = 52;
//file card height
fW = 74;

/* [lid] */
//the height of the lid
lH = 10;
enable_lid_text = true;
lid_box_text = "DaAppLab";
lid_text_font = "Liberation Sans:style=Regular";
lid_text_size = 25;
lid_text_extrusion = 4;
lid_text_font_spacing = 1;

/* [Bottom] */
//how many dividers are placed in the box 
nrOfSeperators = 5;
enable_bottom_text = true;
bottom_box_text = "DaAppLab";
bottom_text_font = "Liberation Sans:style=Regular";
bottom_text_size = 25;
bottom_text_extrusion = 4;
bottom_text_font_spacing = 1;

/* [Hidden] */
//the space between card and box (should not be zero)
space = 2;


//box dimensions
//the thickness of all walls
wall_strength = 2;
//box width
w = fW + space*2 + wall_strength*2;
//box depth
d = 250 ; 
// box height
h = fH + space;
//spaceBetweenSeperators
sBS = (d - wall_strength * (2 + nrOfSeperators)) / (nrOfSeperators + 1);


module FileCardBoxMain(){

    //bottom
    if(enable_bottom){
        BoxBottom();
    }

    //top
    if(enable_lid){
        BoxTop();
    }
}

module BoxBottom (){
    union() {
        //text
        if(enable_bottom_text){
            
            translate([0.3, d/2, h/2]){
                rotate([90, 0, -90]){
                    BottomBoxText();
                }
            }
        }
        //box
        union() {
            union() {   
                difference() {
                    
                    union() {
                        //shell
                        cube ([w, d, h]) ;
                        //line for the lid to stick
                        translate([wall_strength/2, wall_strength/2, h]){
                            cube([w - wall_strength, d - wall_strength, lH-wall_strength-lid_text_extrusion]);
                        };
                    };
                    
                    //remove inside
                    translate([wall_strength, wall_strength, wall_strength]){
                        cube ([w - wall_strength*2, d-wall_strength*2, lH+h-wall_strength+00.1]);
                    };
                };
                //seperators
                if(nrOfSeperators > 0){
                    for (i=[0:nrOfSeperators - 1])
                        // first wall + already set walls + the wall strength of the set walls
                        translate([0, wall_strength + sBS + (i * sBS) + (i * wall_strength), 0]){
                            cube([w, wall_strength, h - (lH/2 + 2)]);
                    }
                }
            }
        }
    }
}

module BoxTop (){
    translate ([fW + 2*wall_strength + 10, 0, 0]){
        if(enable_lid_text){
            difference() {
                //shell
                cube ([w, d, lH]);
                //remove inside 
                translate([wall_strength/2, wall_strength/2, wall_strength+lid_text_extrusion]){
                    cube ([w - wall_strength*2+ wall_strength,
                            d-wall_strength*2+ wall_strength,
                            lH+wall_strength+lid_text_extrusion]);
                }
                //remove text
                translate([w/2, d/2, lid_text_extrusion]){
                    rotate([180, 0, -90]){
                            LidBoxText();
                        }
                    }
                }   
            }
        else{
            difference() { 
                //shell
                cube ([w, d, lH]);
                //remove inside 
                translate([wall_strength/2, wall_strength/2, wall_strength]){
                    cube ([w - wall_strength*2 + wall_strength,
                            d-wall_strength*2 + wall_strength,
                            lH+wall_strength+lid_text_extrusion]);
                }
            }
        }
    }
}

module BottomBoxText (){
    linear_extrude(bottom_text_extrusion){
        text(text=bottom_box_text, size=bottom_text_size, font=bottom_text_font, spacing=bottom_text_font_spacing,
        halign="center", valign="center",
        $fn=text_resolution);
    };
}

module LidBoxText (){
    linear_extrude(lid_text_extrusion + 0.02){
        text(text=lid_box_text, size=lid_text_size, font=lid_text_font, spacing=lid_text_font_spacing,
        halign="center", valign="center",
        $fn=text_resolution);
    };
}


//MAIN
FileCardBoxMain();

