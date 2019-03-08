/*
    Author: Kuba Gasiorowski
    
    Press space to swap between landscape/heatmap modes
    Click the mouse to generate new terrain
    Press enter to have terrain shift over
*/

OpenSimplexLoop2d noise;

int cols, rows;
final float scale = 1; // This controls how many vertices to calculate (lower scale = more vertices)

float terrain[][]; // Elevation data
int transX, transY, transZ; 
float rotX, rotY, rotZ;
int terrainWidth; // How many pixels wide should the terrain be
int terrainHeight; // How many pixels tall should the terrain be

final int numFrames = 300;
int counter = 0;

float previousPercent = -1;
float percent = 0;

void setup(){

    size(800,600,P3D);
    background(0);
    smooth();
    noStroke();
    
    terrainWidth = terrainHeight = 900;

    cols = int(terrainWidth/scale);
    rows = int(terrainHeight/scale);

    terrain = new float[cols][rows];
    //generateTerrain(0);

    transX = transY = transZ = 0;
    rotX = rotY = rotZ = 0;

    noise = new OpenSimplexLoop2d(4, -70, 70);

}

void generateTerrain(float percent){
    
    float xoff = 0;
    for(int x = 0; x < cols; x++, xoff += 0.03 * scale){
    
        float yoff = 0;
        for(int y = 0; y < rows; y++, yoff += 0.03 * scale){
        
            terrain[x][y] = noise.value(percent, xoff, yoff);
        
        }
    
    }
    
}

void draw(){
    
    float startTime = millis();
    
    background(0);
    
    float percent = float(counter)/float(numFrames);
    generateTerrain(percent);
    
    lights();
    translate(width/2-terrainWidth/2, height/2-terrainHeight/2, (height+width) * 0.27174 - 1015.22);
    rotateX(PI/4.5);
    
    for(int y = 0; y < rows-1; y++){
    
        beginShape(TRIANGLE_STRIP);
        
        for(int x = 0; x < cols; x++){
            
            fill(heatMap(terrain[x][y]));
            vertex(x*scale, y*scale, terrain[x][y]);
            
            fill(heatMap(terrain[x][y+1]));
            vertex(x*scale, (y+1)*scale, terrain[x][y+1]);
        
        }
    
        endShape();
    
    }

    saveFrame("img/###.png");
    
    float timeElapsed = (millis() - startTime) / 1000.0;
    
    print(String.format("Frame took %.2f ", timeElapsed));
    
    percent = round(float(++counter)/float(numFrames)*1000.0)/10.0;
    if(percent != previousPercent){
        println(percent + "%");
        previousPercent = percent;
    }
    
    if(counter > numFrames){
     
        exit();
        return;
        
    }
    
}

//void mousePressed(){

//    generateTerrain();
//    redraw();

//}

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
