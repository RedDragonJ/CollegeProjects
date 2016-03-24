package testproject;

import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
/**
 * @author JamesSun
 */
public class TestProject extends JFrame {

    private int countPaints = 0;
    private int xValue = 0, yValue = 0;
    private Color ColorChoice = Color.black;
    private Label Msg;
    
    public TestProject()
   {
      super( "A simple paint program" );
      Msg = new Label("Drag to draw. Click to choose color");
      add(Msg,BorderLayout.SOUTH );

      // In this case the event source is the whole window so we
      // listen to events from "this".
      this.addMouseMotionListener(

         // anonymous inner class that extends adapter class
         new MouseMotionAdapter() {

            // Only interested in activating code when mouse
            // is dragged.  Store coordinates and repaint.
            public void mouseDragged( MouseEvent event )
            {
               xValue = event.getX();
               yValue = event.getY();
               repaint();
            }

         }  // end anonymous inner class

      ); // end call to addMouseMotionListener

      // MouseHandler is an inner class that extends MouseAdapter
      // See below for definition
      MouseHandler handler = new MouseHandler();
      this.addMouseListener(handler);

      setSize( 300, 150 );
      setVisible( true );
   }

   

public void paint( Graphics g )
   {
   	  // Call super first time but not subsequently to prevent
   	  // repainting and losing previous drawings
   	  if (countPaints == 0)
   	   	super.paint(g);

   	  // paint draws a 4x4 oval whenever the user is dragging
      g.setColor(ColorChoice);
      g.fillOval( xValue, yValue, 4, 4 );
      countPaints++;
   }

   // execute application
   public static void main( String args[] )
   {
      TestProject application = new TestProject();

      application.addWindowListener(

         // adapter to handle only windowClosing event
         new WindowAdapter() {

            public void windowClosing( WindowEvent event )
            {
               System.exit( 0 );
            }

         }  // end anonymous inner class

      ); // end call to addWindowListener
   }

   private class MouseHandler extends MouseAdapter {
      // Again, since we are extending an adapter class we
      // only override mouseClicked
      public void mouseClicked( MouseEvent event)
      {
          ColorChoice = JColorChooser.showDialog(
          	TestProject.this, "Choose a color", ColorChoice);
      }

   }
    
}
