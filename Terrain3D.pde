import static java.awt.event.KeyEvent.*;
import controlP5.*;

int cols, rows;
float scale = 1;

float terrain[][];
int transX, transY, transZ;
float rotX, rotY, rotZ;
int terrainWidth = 900;
int terrainHeight = 900;

// True for heat map, false for land
boolean heatMap = false;

void setup(){

    println(width, height);

    fullScreen(P3D);
    //size(800, 600, P3D);
    background(0);
    smooth();

    cols = int(terrainWidth/scale);
    rows = int(terrainHeight/scale);

    terrain = new float[cols][rows];
    generateTerrain(terrain);

    transX = transY = transZ = 0;
    rotX = rotY = rotZ = 0;

}

void generateTerrain(float[][] terrainArray){

    noiseSeed((long)random(65536));
    
    float xoff = 0;
    for(int x = 0; x < cols; x++, xoff += 0.007 * scale){
    
        float yoff = 0;
        for(int y = 0; y < rows; y++, yoff += 0.007 * scale){
        
            terrainArray[x][y] = map(noise(xoff, yoff), 0.2, 0.8, -50, 50);
        
        }
    
    }
    
}

void draw(){

    background(0);

    generateTerrain(terrain);
    
    lights();
    
    translate(width/3.76, height/6, -250);
    rotateX(PI/3.5);
    
    for(int y = 0; y < rows-1; y++){
    
        beginShape(TRIANGLE_STRIP);
        
        for(int x = 0; x < cols; x++){
        
            if(heatMap){
            
                noStroke();
                
                fill(heatMap(terrain[x][y]));
                vertex(x*scale, y*scale, terrain[x][y]);
                
                fill(heatMap(terrain[x][y+1]));
                vertex(x*scale, (y+1)*scale, terrain[x][y+1]);
            
            }else{
            
                noStroke();
                
                float terrainToDraw = terrain[x][y] < WATER_LEVEL? WATER_LEVEL : terrain[x][y];
                fill(simpleLand(terrain[x][y]));
                vertex(x*scale, y*scale, terrainToDraw);
                
                terrainToDraw = terrain[x][y+1] < WATER_LEVEL ? WATER_LEVEL : terrain[x][y+1];
                fill(simpleLand(terrain[x][y+1]));
                vertex(x*scale, (y+1)*scale, terrainToDraw);
                
            }
        
        }
    
        endShape();
    
    }

    delay(5000);

}

int WATER_LEVEL = -35;
int GRASS_LEVEL = -25;
int STONE_LEVEL = 13;
int SNOW_LEVEL = 20;

color simpleLand(float elevation){
    
    if(elevation <= WATER_LEVEL)
        return color(66, 106, 244);
    else if(elevation > WATER_LEVEL && elevation < GRASS_LEVEL)
        return color(247, 225, 101);
    else if(elevation >= GRASS_LEVEL && elevation < STONE_LEVEL)
        return color(41, 109, 39);
    else if(elevation >= STONE_LEVEL && elevation < SNOW_LEVEL)
        return color(120);
    else
        return color(255);

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
