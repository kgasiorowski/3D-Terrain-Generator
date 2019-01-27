/*
    Author: Kuba Gasiorowski
    
    Press space to swap between landscape/heatmap modes
    Click the mouse to generate new terrain
    Press enter to have terrain shift over
*/

import static java.awt.event.KeyEvent.*;

int cols, rows;
final float scale = 3; // This controls how many vertices to calculate (lower scale = more vertices)

float terrain[][]; // Elevation data
int transX, transY, transZ; 
float rotX, rotY, rotZ;
int terrainWidth; // How many pixels wide should the terrain be
int terrainHeight; // How many pixels tall should the terrain be

// True for heat map, false for land
boolean heatMap = false;

// If true, new terrain will generate
boolean moving = false;

void setup(){

    fullScreen(P3D);
    //size(1280, 800, P3D);
    background(0);
    smooth();
    noStroke();
    
    terrainWidth = terrainHeight = 900;

    cols = int(terrainWidth/scale);
    rows = int(terrainHeight/scale);

    terrain = new float[cols][rows];
    generateTerrain();

    transX = transY = transZ = 0;
    rotX = rotY = rotZ = 0;

    frameRate(15);


}

float xoff = 0, yoff = 0;

void generateTerrain(){

    noiseSeed((long)random(65536));
    
    xoff = 0;
    for(int x = 0; x < cols; x++, xoff += 0.007 * scale){
    
        yoff = 0;
        for(int y = 0; y < rows; y++, yoff += 0.007 * scale){
        
            terrain[x][y] = map(noise(xoff, yoff), 0.2, 0.8, -50, 50);
        
        }
    
    }
    
}

void moveTerrain(){
    
    for(int x = 0; x < cols; x++)
        for(int y = 0; y < rows-1; y++)        
            terrain[x][y] = terrain[x][y+1];
     
    
    xoff = 0;
    
    // Generate one more line of terrain here
    for(int x = 0; x < cols; x++, xoff += 0.007 * scale){
    
        terrain[x][rows-1] = map(noise(xoff, yoff), 0.2, 0.8, -50, 50);
    
    }
    
    yoff += 0.007 * scale;
     
}

void draw(){
    
    background(0);
    lights();
    
    translate(width/2-terrainWidth/2, height/2-terrainHeight/2, (height+width) * 0.27174 - 1015.22);
    rotateX(PI/4.5);
    
    for(int y = 0; y < rows-1; y++){
    
        beginShape(TRIANGLE_STRIP);
        
        for(int x = 0; x < cols; x++){
        
            if(heatMap){
                
                fill(heatMap(terrain[x][y]));
                vertex(x*scale, y*scale, terrain[x][y]);
                
                fill(heatMap(terrain[x][y+1]));
                vertex(x*scale, (y+1)*scale, terrain[x][y+1]);
            
            }else{
                
                fill(simpleLand(terrain[x][y]));
                vertex(x*scale, y*scale, terrain[x][y] < WATER_LEVEL? WATER_LEVEL : terrain[x][y]);
                
                fill(simpleLand(terrain[x][y+1]));
                vertex(x*scale, (y+1)*scale, terrain[x][y+1] < WATER_LEVEL ? WATER_LEVEL : terrain[x][y+1]);
                
            }
        
        }
    
        endShape();
    
    }

    if(moving)
        moveTerrain();


}

// Enter to start/stop movement
// Space to swap color schemes
void keyPressed(){

    if(keyCode == VK_ENTER){
    
        if(moving)
            noLoop();
        else
            loop();
        
        moving = !moving;
    
    }else if(keyCode == VK_SPACE){
    
        heatMap = !heatMap;
    
    }

    redraw();

}

void mousePressed(){

    generateTerrain();
    redraw();

}

int WATER_LEVEL = -35;
int GRASS_LEVEL = -25;
int STONE_LEVEL = 0;
int SNOW_LEVEL = 20;

color simpleLand(float elevation){
    
    if(elevation >= SNOW_LEVEL)
        return color(255);
    else if(elevation >= STONE_LEVEL)
        return color(120);
    else if(elevation >= GRASS_LEVEL)
        return color(41, 109, 39);
    else if(elevation >= WATER_LEVEL)
        return color(247, 225, 101);
    else
        return color(66, 106, 244);
    
}

color heatMap(float elevation){

    int red = 0;
    int green = 0;
    int blue = 0;
    
    int tempTerrain = int(map(elevation, -50, 50, 0, 255));
    
    if(tempTerrain <= 255/4){
    
        // Lowest level, blue -> cyan
        red = 0;
        green = int(map(tempTerrain, 0, 255/4, 0, 255));
        blue = 255;
    
    }else if(tempTerrain > 255/4 && tempTerrain <= 255/2){
    
        // 2nd level, teal -> green
        red = 0;
        green = 255;
        blue = int(map(tempTerrain, 255/4, 255/2, 255, 0));

    }else if(tempTerrain > 255/2 && tempTerrain <= 255/4*3){
        
        // 3rd level, green -> yellow
        red = int(map(tempTerrain, 255/2, 255/4*3, 0, 255));
        green = 255;
        blue = 0;
    
    }else{
    
        // Top level, yellow -> red
        red = 255;
        green = int(map(tempTerrain, 255/4*3, 255, 255, 0));
        blue = 0;
    
    }

    return color(red, green, blue);

}
