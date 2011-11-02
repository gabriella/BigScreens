import processing.video.*;

import javax.imageio.*;
import java.awt.image.*; 

// This is the port we are sending to
int clientPort1 = 9101;

int clientPort2 = 9105;

int clientPort3 = 9109;

// This is our object that sends UDP out
DatagramSocket ds; 
// Capture object
Capture cam;

void setup() {
  size(320,240);
  // Setting up the DatagramSocket, requires try/catch
  try {
    ds = new DatagramSocket();
  } catch (SocketException e) {
    e.printStackTrace();
  }
  // Initialize Camera
  cam = new Capture( this, width,height,30);
}

void captureEvent( Capture c ) {
  c.read();
  // Whenever we get a new image, send it!
  broadcast(c);
}

void draw() {
  image(cam,0,0);
  //println(address());
}


// Function to broadcast a PImage over UDP
// Special thanks to: http://ubaa.net/shared/processing/udp/
// (This example doesn't use the library, but you can!)
void broadcast(PImage img) {

  // We need a buffered image to do the JPG encoding
  BufferedImage bimg = new BufferedImage( img.width,img.height, BufferedImage.TYPE_INT_RGB );

  // Transfer pixels from localFrame to the BufferedImage
  img.loadPixels();
  bimg.setRGB( 0, 0, img.width, img.height, img.pixels, 0, img.width);

  // Need these output streams to get image as bytes for UDP communication
  ByteArrayOutputStream baStream	= new ByteArrayOutputStream();
  BufferedOutputStream bos		= new BufferedOutputStream(baStream);

  // Turn the BufferedImage into a JPG and put it in the BufferedOutputStream
  // Requires try/catch
  try {
    ImageIO.write(bimg, "jpg", bos);
  } 
  catch (IOException e) {
    e.printStackTrace();
  }

  // Get the byte array, which we will send out via UDP!
  byte[] packet = baStream.toByteArray();

  // Send JPEG data as a datagram
  println("Sending datagram with " + packet.length + " bytes");
  try {
    
    //IAC
    ds.send(new DatagramPacket(packet,packet.length, InetAddress.getByName("192.168.130.241"),clientPort1));//change localhost to "ip.ip.ip.ip");
    ds.send(new DatagramPacket(packet,packet.length, InetAddress.getByName("192.168.130.242"),clientPort2));//change localhost to "ip.ip.ip.ip");
    ds.send(new DatagramPacket(packet,packet.length, InetAddress.getByName("192.168.130.240"),clientPort3));//change localhost to "ip.ip.ip.ip");
    //plug in router, then this Ip address goes in catherine's computer after she connects to stevie
   // SCHOOL
   /*
       ds.send(new DatagramPacket(packet,packet.length, InetAddress.getByName("128.122.151.64"),clientPort1));//change localhost to "ip.ip.ip.ip");
    ds.send(new DatagramPacket(packet,packet.length, InetAddress.getByName("128.122.151.65"),clientPort2));//change localhost to "ip.ip.ip.ip");
    ds.send(new DatagramPacket(packet,packet.length, InetAddress.getByName("128.122.151.83"),clientPort3));//change localhost to "ip.ip.ip.ip");
   */
  } 
  catch (Exception e) {
    e.printStackTrace();
  }
}

