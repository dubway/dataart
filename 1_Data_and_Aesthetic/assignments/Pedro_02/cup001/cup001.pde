// Data Art
// This is the Base for my code not the final one


//Import Libraries:
import processing.opengl.*;

import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.processing.*;

WETriangleMesh mesh;
ToxiclibsSupport gfx;


//Global Variables
AABB boundingBox;
float zoomAmt = 1;
int call = randRange(0, 66);
int counter = 0;





void setup() {
  size(900, 900, OPENGL);
  TriangleMesh tmesh = (TriangleMesh) new STLReader().loadBinary(sketchPath("base001.stl"), STLReader.TRIANGLEMESH);
  mesh = new WETriangleMesh();
  mesh.addMesh(tmesh);

  //Call built in functions from Toxic that provides new drawing commands
  gfx = new ToxiclibsSupport(this);
  //mesh.removeFace(mesh.faces.get(0));
  //centerModel(mesh);
  boundingBox=mesh.getBoundingBox();
  testTranslate2(0.3);
  //testTranslate3(0.8);
  //testTranslate4(-0.5);
}

void draw() {
  background(51);
  lights();  //openGL

  translate(width/2, height/2, 0);
  rotateX(mouseY*0.01);
  rotateY(mouseX*0.01);

  //mesh(myMesh, smooth, normalsLength);
  fill(255, 255, 255);
  gfx.mesh(mesh, true, 0);


  //Draw draw coordinate Axis
  gfx.origin(new Vec3D(), 200);

  //Draw bounding box
  //boundingBox=mesh.getBoundingBox();
  Mesh3D box = boundingBox.toMesh();
  noFill();
  gfx.mesh(box);

  //Return Number of Vertices
  int myVertices = mesh.getNumVertices();
  //println(myVertices);

  //Return Number of Faces
  int myFaces = mesh.getNumFaces();
  println(myFaces);

  //Return First Face of the Mesh
  Face firstFace = mesh.faces.get(40);
  //println(firstFace.a.x);
  
  //Return Centroid
  Vec3D myCentroid = mesh.computeCentroid();
  //println("Centroid: " + myCentroid);
  
  //Return Face Normals
  mesh.computeFaceNormals();
//  println(firstFace.a.angleBetween(myCentroid, true));
//  println(firstFace.b.angleBetween(myCentroid, true));
//  println(firstFace.c.angleBetween(myCentroid, true));
//  println("------------------------------------------");
  
  
  
  drawFace(selectFace(1));
  drawFace(selectFace(2+1));
  
//  if(counter<1){
//    Vec3D banana = new Vec3D(0, 100, 0);
//    //extrudeFace(selectFace(call), offset, false);
//    counter++;
//  }
  
}

void up(){
  for(int i=0; i<mesh.getNumFaces(); i++){
    moveVertex(i, 1, 2, i*10.0);
  }
}

void testTranslate(float Trans) {
  moveVertex(0, 1, 0, Trans);

  moveVertex(5, 1, 2, Trans);
  moveVertex(7, 1, -2, Trans);

  moveVertex(13, 1, 4, Trans);
  moveVertex(15, 1, -4, Trans);

  moveVertex(21, 1, 6, Trans);
  moveVertex(23, 1, -6, Trans);

  moveVertex(29, 1, 8, Trans);
  moveVertex(31, 1, -8, Trans);

  moveVertex(37, 1, 10, Trans);
}

//1st Top ring, every other
void testTranslate2(float Trans) {  
  moveVertex(0, 1, 0, Trans);

  for (int i=0; i<4; i++) {
    moveVertex(5+(i*8), 1, 2*(i+1), Trans);
    moveVertex(7+(i*8), 1, -2*(i+1), Trans);
  }

  moveVertex(37, 1, 10, Trans);
}

//2nd Top ring, every other
void testTranslate3(float Trans) {
  moveVertex(40, 1, 1, Trans);
  moveVertex(44, 1, -1, Trans);

  moveVertex(49, 1, 3, Trans);
  moveVertex(53, 1, -3, Trans);

  moveVertex(57, 1, 5, Trans);
  moveVertex(61, 1, -5, Trans);

  moveVertex(65, 1, 7, Trans);
  moveVertex(69, 1, -7, Trans);

  moveVertex(74, 1, -9, Trans);
  moveVertex(75, 1, 9, Trans);
}

void testTranslate4(float Trans) {
  moveVertex(41, 1, 0, Trans);

  moveVertex(43, 1, 2, Trans);
  moveVertex(47, 1, -2, Trans);

  moveVertex(54, 1, 4, Trans);
  moveVertex(58, 1, -4, Trans);

  moveVertex(64, 1, 6, Trans);
  moveVertex(66, 1, -6, Trans);

  moveVertex(70, 1, 8, Trans);
  moveVertex(76, 1, -8, Trans);

  moveVertex(78, 1, 10, Trans);
}


void moveVertex(int FaceID, int Vertex, int Angle, Float Amount) {
  Face selectFace = mesh.faces.get(FaceID);

  Vec3D offset = new Vec3D(
  (cos(radians((18*Angle)+90)) * (boundingBox.getExtent().x/2) )*Amount, 
  (sin(radians((18*Angle)+90)) * (boundingBox.getExtent().x/2) )*Amount, 
  0);

  if (Vertex == 0) {
    selectFace.a.addSelf(offset);
  }
  if (Vertex == 1) {
    selectFace.b.addSelf(offset);
  }
  if (Vertex == 2) {
    selectFace.c.addSelf(offset);
  }
}


void centerModel(TriangleMesh mesh) {
  Sphere boundingsphere=mesh.getBoundingSphere();
  //println(boundingsphere.radius);
  zoomAmt = (width/2)/(boundingsphere.radius*1.5);
}

// Interaction ------------------------------------------
void keyPressed() {
  if (key=='s') {
    println("works");
    exportSTL("cup001");
  }
}




// Utils -------------------------------------------------

//semi random
int randRange(int min, int max) {
  int value = int(random(min, max));//randomize my range
  return value;
}

//select some faces on a mesh
Face selectFace(int faceID) {
  Face selectedFace = mesh.faces.get(faceID);
  return selectedFace;
}

// draw face
void drawFace(Face f) {
  fill(255, 0, 0);
  beginShape(TRIANGLES);
  vertex(f.a.x, f.a.y, f.a.z);
  vertex(f.b.x, f.b.y, f.b.z);
  vertex(f.c.x, f.c.y, f.c.z);
  endShape();
}

// extrude Face
void extrudeFace(Face f, Vec3D extrude, Boolean Cap){
  float shrink=1;
  Vec3D centroid = mesh.computeCentroid();
  //Vec3D extrude = new Vec3D(0, 0, -10);
  Vec3D a = f.a.interpolateTo(centroid, 1-shrink).add(extrude);
  Vec3D b = f.b.interpolateTo(centroid, 1-shrink).add(extrude);
  Vec3D c = f.c.interpolateTo(centroid, 1-shrink).add(extrude);
  // begin by adding new side faces:
  // side A
  mesh.addFace(f.a, a, f.c);
  mesh.addFace(a, c, f.c);
  // side B
  mesh.addFace(f.a, b, a);
  mesh.addFace(f.a, f.b, b);
  // side C
  mesh.addFace(f.c, c, f.b);
  mesh.addFace(c, b, f.b);
  // remove original face
  mesh.faces.remove(0);
  // add new face as cap
  if(Cap == true){
    mesh.addFace(a, b, c);
  }
  // update normals (for shading)
  mesh.computeVertexNormals();
  }

//delete selected face from mesh
void deleteFace(Face f) {
  mesh.removeFace(f);
}

//export STL
void exportSTL(String fileName) {
  mesh.saveAsSTL(sketchPath( fileName + ".stl" ));
  println("Your file was save as: " + fileName + ".stl");
}
