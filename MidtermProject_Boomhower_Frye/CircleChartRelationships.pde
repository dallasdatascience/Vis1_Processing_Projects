Toggle ZoomRel;

class CircleChartRelationships extends Frame {

  Table circle;
  int[] patco = {};
  String[] agelvlT = {};
  String[] workschT = {};
  String[] sallvlT = {};
  int[] cnt = {};
  int[] agelvlTmag = {};
  int[] workschTmag = {};
  int[] sallvlTmag = {};
  int[] patcoUnique = {};
  String[] agelvlTUnique = {};
  String[] workschTUnique = {};
  String[] sallvlTUnique = {};
  
  CircleChartRelationships() {
  }

  CircleChartRelationships(float x, float y, float frameWidth, float frameHeight) {
    super(x, y, frameWidth, frameHeight);
    ZoomRel = cp5.addToggle("ZoomRel")
      .setPosition(x + frameWidth - frameWidth/17, y-height/30)
      .setSize(width/55, height/60)
      .setValue(false)
      .setMode(ControlP5.SWITCH)
      .hide()
      ;
  }

  void Construct() {
    ZoomRel.setPosition(x + frameWidth - frameWidth/17, y-height/30)
      .show();
    //TableRow row = circle.getRow(0);
    float radius;
    drawFrame();
    drawTitle("CIRCLECHARTRELATIONSHIPS TITLE HERE");

    pushMatrix();

    // Draw circle (center set as reference)
    translate(x + frameWidth/2, y + frameHeight/1.85);
    
    noFill();
    stroke(255);
    if (frameWidth < frameHeight) radius = frameWidth*0.8;
    else radius = frameHeight*0.8;
    ellipse(0, 0, radius, radius);
    
    // Draw triangles
    stroke(255, 0, 0);
    for (int i = 30; i < 60; i=i+2) {
      //println(i);
      point(cos(radians(i))*(radius/1.9), sin(radians(i))*radius/1.9);
    }

    stroke(255, 255, 0);
    for (int i = 150; i < 180; i=i+5) {
      //println(i);
      point(cos(radians(i))*(radius/1.9), sin(radians(i))*radius/1.9);
    }

    popMatrix();
  }

  void loadChartData(){
    patco        = new int[0];
    agelvlT      = new String[0];
    workschT     = new String[0];
    sallvlT      = new String[0];
    cnt          = new int[0];
    agelvlTmag   = new int[0];
    workschTmag  = new int[0];
    sallvlTmag   = new int[0];
    circle = loadTable("DistinctPATCO_AGELVL_WORKSCH_SALLVL_FINAL.csv", "header");

    for (TableRow row : circle.rows()) {
      this.patco        =  append(patco, row.getInt("PATCO"));
      this.agelvlT      =  append(agelvlT, row.getString("AGELVLT"));
      this.workschT     =  append(workschT, row.getString("WORKSCHT"));
      this.sallvlT      =  append(sallvlT, row.getString("SALLVLT"));
      this.cnt          =  append(cnt, row.getInt("CNT"));
      this.agelvlTmag   =  append(agelvlTmag, row.getInt("AGELVLTMagnitude"));
      this.workschTmag  =  append(workschTmag, row.getInt("WORKSCHTMagnitude"));
      this.sallvlTmag   =  append(sallvlTmag, row.getInt("SALLVLTMagnitude"));
    }
    
    //for (int i = 0; i < this.patco.length; i++) { //<>//
    //  println("CircleChart Line " + i + " = " + patco[i] + ", " + 
    //    agelvlT[i] + ", " + workschT[i] + ", " + sallvlT[i] + ", " + cnt[i] + 
    //    ", " + agelvlTmag[i] + ", " + workschTmag[i] + ", " + sallvlTmag[i]);
    //}
    
    patcoUnique = getUniqueInt(this.patco);
    agelvlTUnique = getUniqueString(this.agelvlT);
    workschTUnique = getUniqueString(this.workschT);
    sallvlTUnique = getUniqueString(this.sallvlT);
    
    print("PATCO unique = ");
    for (int i = 0; i < patcoUnique.length; i++) print(patcoUnique[i] + ", ");
    print("\n");
    
    print("AGELVLT unique = ");
    for (int i = 0; i < agelvlTUnique.length; i++) print(agelvlTUnique[i] + ", ");
    print("\n");
    
    print("WORKSCHT unique = ");
    for (int i = 0; i < workschTUnique.length; i++) print(workschTUnique[i] + ", ");
    print("\n");
    
    print("SALLVLT unique = ");
    for (int i = 0; i < sallvlTUnique.length; i++) print(sallvlTUnique[i] + ", ");
    print("\n");
    
    //ZoomRel.show();
  }
  int[] getUniqueInt(int[] input) {
    int[] temp = new int[input.length];
    int p = 1;
    Arrays.sort(input);
    temp[0] = input[0];
    for (int i = 1; i < input.length; i++)
      if (input[i] != input[i-1])
        temp[p++] = input[i];
    int[] output =  new int[p];
    arrayCopy(temp, 0, output, 0, p);
    return output;
  }
  
  String[] getUniqueString(String[] input) {
    String[] temp = new String[input.length];
    int p = 1;
    Arrays.sort(input);
    temp[0] = input[0];
    for (int i = 1; i < input.length; i++) //<>//
      if (!input[i].contains(input[i-1]))
        temp[p++] = input[i];
    String[] output =  new String[p];
    arrayCopy(temp, 0, output, 0, p);
    return output;
  }
  
}