class OpenSimplexLoop1d {

    OpenSimplexNoise noise;
    float diameter;
    float min, max;
    float cx;
    float cy;

    OpenSimplexLoop1d(float diameter, float min, float max) {
    
        noise = new OpenSimplexNoise();
        this.diameter = diameter;
        this.min = min;
        this.max = max;
        cx = random(1000);
        cy = random(1000);
    
    }

    float value(float a) {
        float _a = map(a, 0, 1, 0, TWO_PI);
        float xoff = map(cos(_a), -1, 1, cx, cx + diameter);
        float yoff = map(sin(_a), -1, 1, cy, cy + diameter);
        float r = (float)(noise.eval(xoff, yoff));
        return map(r, -1, 1, min, max);
    
    }
    
}

class OpenSimplexLoop2d {

    OpenSimplexNoise noise;
    float diameter;
    float min, max;
    float cu;
    float cv;

    OpenSimplexLoop2d(float diameter, float min, float max) {
    
        noise = new OpenSimplexNoise();
        this.diameter = diameter;
        this.min = min;
        this.max = max;
        cu = random(1000);
        cv = random(1000);
    
    }

    float value(float a, float x, float y) {
        
        float angle = map(a, 0, 1, 0, TWO_PI);
        float uoff = map(cos(angle), -1, 1, cu, cu + diameter);
        float voff = map(sin(angle), -1, 1, cv, cv + diameter);
        float r = (float)(noise.eval(x, y, uoff, voff));
        return map(r, -1, 1, min, max);
    
    }

}
