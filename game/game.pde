//--------------------------Librerias---------------------------
 import processing.serial.*;
 
 Serial port;
 
// adding movement of paddles
PImage carro;
PImage taxi;
PImage pasajero1;
PImage pasajero2;
PImage fondo;

String sensores;

int potenciometro1;
int potenciometro2;

float posicionY1;
float posicionY2;


float ellX = width / 2; //initisl ellipse position in the middle
float ellY = height / 2;

boolean moveRight = true; // this means moving left is false
boolean moveDown = true; // this means moving up is false

float speedSide = 3; //speed in X direction, higher value is greater speed
float speedVertical = 4; //speed in Y direction

int countR = 0; //score for right paddle
int countL = 0; //score for left paddle

int estado1 [];

PFont font; //font used for score


//draw components
void setup () { 

size (700, 700); //size of screen
fondo = loadImage("fondo-01-01.png");
font = loadFont("Arial-BoldMT-28.vlw");
estado1 = new int[50];

noStroke();
    port = new Serial(this, Serial.list()[0], 9600);
   //   port = new Serial(this, "/dev/cu.usbmodem1461", 9600); 

carro = loadImage("carro-01.png");
taxi = loadImage ("taxi-01.png");
pasajero1 = loadImage ("pasajero-01.png");
pasajero2 = loadImage ("pasajero-02-01.png");
}
 
void draw () { 
  //ubicacion del jugador con el sensor de wiring
  if (0 < port.available()) 
  {     
    //otra forma de enviar los datos a processing es no usando serial.write, sino serial.println, sin embargo en processing no se utiliza port.read(), sino port.readStringUntil('\n');
    sensores =  port.readStringUntil('\n');    
        
    if(sensores != null)
    {
      println(sensores);
      //se crea un arreglo que divide los datos y los guarda dentro del arreglo, para dividir los datos se hace con split cuando le llegue el caracter 'T',
      String[] datosSensor = split(sensores,'T');
      
      if(datosSensor.length == 2)
      {
        println(datosSensor[0]);
        println(datosSensor[1]);
        potenciometro1 = int(trim(datosSensor[0]));      
        potenciometro2 = int(trim(datosSensor[1]));
      }     
    }
    
    posicionY1 = map(potenciometro1,0,1023,0,700);
    posicionY2 = map(potenciometro2,0,1023,0,700);
  }
  
  background (fondo);
  
  textFont (font);
  
  fill (250,0,0);
  image (pasajero1, ellX, ellY, 50, 50);
  text("VS", 330, 50);
  
  
  fill (255, 255, 0);
  image (taxi, 20, posicionY1, 30, 100);
  text ("taxi:" + countL, 100, 50);
  
  fill (0, 0, 255);
  image (carro, 650, posicionY2, 30, 100);
  text ("carro:" + countR, 500, 50);
  
  if (keyPressed == true && key == 'w') {
    posicionY1 = posicionY1 - 6;
  }
  
  if (keyPressed == true && key == 's') {
    posicionY1 = posicionY1 + 6;
  }
  
   if (keyPressed == true && key == 'i') {
    posicionY2 = posicionY2 - 6;
  }
  
   if (keyPressed == true && key == 'k') {
    posicionY2 = posicionY2 + 6;
  }
  
    if (moveRight == true)
    { ellX = ellX + speedSide;
     }
    
    else {
      ellX = ellX - speedSide;
      }
      
     if (moveDown == true) {
       ellY = ellY + speedVertical;
      }
      
     else {
       ellY = ellY - speedVertical;
       }
       
     if (ellY <= 10) {
     moveDown = true;
     speedSide = random (3, 6);
   }
     
     if (ellY >= 690) {
       moveDown = false;
       speedSide = random (3, 6);
     
   }
     
     if (ellX  >= 690) {
       countL++;
       ellX = width / 2;
       ellY = height / 2;
       speedSide = random (3, 6);
     }
       
     if (ellX <= 10) {
       countR++;
       ellX = width / 2;
       ellY = height / 2;
       speedSide = random (3, 6);
     }
     
     //creates right paddle boundary so circle will bounce off
     if (ellX >= 615 && ellY > posicionY2 && ellY < (posicionY2 + 100)) {
     moveRight = false;
     speedSide = random (3, 6);
     }
     
     //creates left paddle boundary so circle will bounce off
     if (ellX <= 75 && ellY > posicionY1 && ellY < (posicionY1 + 100)) {
     moveRight = true;
     speedSide = random (3, 6);
     
     }
     

}
