//https://www.fontsquirrel.com/fonts/list/find_fonts?q%5Bterm%5D=Lobster&q%5Bsearch_check%5D=Y
use <fonts/Lobster_1.3.otf>
include <BOSL2/std.scad>

// CONFIG
$fn=100;

keychainText = "Santiago";
fontStyle = 
"Lobster 1.3:style=Italic";
fontSize = 18;

metrics = textmetrics(keychainText,fontSize, fontStyle);

txtLowChars="anmcvzxgsqweryuop";
txtHighChars="hkb";
file = "graduate.svg";
logoSizeX=25;
logoSizeY=13;

isLower = (search(keychainText[len(keychainText)-1],txtLowChars));
isHigher = (search(keychainText[len(keychainText)-1],txtHighChars));
logoOffsetX = (isLower) ? -14 : (isHigher)? -19 : -9;
logoOffsetY = (isLower) ? 9 : (isHigher)? 12 : 16;
logoRotate = (isLower) ? [0,0,-25] : (isHigher)? [0,0,-15] : [0,0,-35];
/*
//short last char
logoOffsetX=-14;
logoOffsetY=9;
logoRotate=[0,0,-25];

//tall last char
logoOffsetX2=-9;
logoOffsetY2=16;
logoRotate2=[0,0,-35];
*/

textHeight = 1;
backHeight = 1.6;
logoHeight = 1.0;
backPlateBorderSize = 3;
backPlateLogoBorderSize =2;
keychainHoleOffset = 0;
keychainHoleOffsetVert = 3;

// MODEL
genBackPlateWithHole();
genKeychainText();
genKeychainLogo();


// MODEL PARTS
module genBackPlateWithHole() {
    color("black")
    difference() {
        genBackPlate();
        translate([(-3+keychainHoleOffset),(fontSize/2+keychainHoleOffsetVert),-1]) cylinder(h=(backHeight+2),r=2);
    }
}

module genBackPlate() {
    union() {
    //text back
      linear_extrude(  backHeight){
        offset(r=backPlateBorderSize) genText();
    }
    //logo back
    metrics = textmetrics(keychainText,fontSize, fontStyle); //translate([len(keychainText)*fontSize*0.6+logoOffsetX,logoOffsetY,0])
    translate([metrics.advance.x+logoOffsetX,logoOffsetY,0])
      linear_extrude(  backHeight){
        offset(r=backPlateLogoBorderSize) genLogo();
      }
    }
    
    hull(){
        translate([(-3+keychainHoleOffset),(fontSize/2+keychainHoleOffsetVert),0]) cylinder(h=backHeight, r=4);
        translate([(2),(fontSize/2+keychainHoleOffsetVert),0]) cylinder(h=backHeight, r=4);
    }
}

module genKeychainText(){
    color("white") translate([0,0,backHeight])  linear_extrude(textHeight){ 
      genText();
    }
    
}

module genKeychainLogo(){
    //color("red") translate([len(keychainText)*fontSize*0.6+logoOffsetX,logoOffsetY,1.6]) 
    metrics = textmetrics(keychainText,fontSize, fontStyle);
    color("red") translate([metrics.advance.x+logoOffsetX,logoOffsetY,backHeight])
    linear_extrude(logoHeight){ 
        genLogo();
    }
}

module genText() {
    text(keychainText, size=fontSize ,font=fontStyle);
}

module genLogo(){ 
    translate([0,fontSize,0])
    rotate(logoRotate)
    resize([logoSizeX,logoSizeY])
    {
      import(file);
  }
}