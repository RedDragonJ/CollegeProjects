package drawtest;

import javax.swing.*;
import java.awt.*;
import java.awt.geom.*;
import java.awt.event.*; 
import java.util.*;
import javafx.scene.input.MouseButton;
/**
 * @author JamesSun
 */
public class DrawTest extends JFrame {

    private static final int NONE = 0, POLY = 1;
    private ShapePanel drawPanel;
    private JPanel buttonPanel;
    private JButton drawPoly;
    private TextField msg;
    private int mode;
    private boolean created;
    private Polygon newShape;
    private JPopupMenu popup;
    private JMenuItem menuitem;
    private Vector<Polygon> shapeList;    
    private Vector<Color>  colorList;   
    private int selindex;
    private int x1, y1, x2, y2, oldX, oldY, n=1;
    
    public DrawTest()
    {
        super("DrawTest");
        drawPanel = new ShapePanel(450, 240);
        buttonPanel = new JPanel();
        buttonPanel.setLayout(new GridLayout (1, 2));

        popup = new JPopupMenu();
        menuitem = new JMenuItem("Delete");
        popup.add(menuitem);
        
        drawPoly = new JButton("Draw/End Draw Poly");

        ButtonHandler bhandler = new ButtonHandler();
        drawPoly.addActionListener(bhandler);
        buttonPanel.add(drawPoly);

        msg = new TextField("End to Re-Draw New Poly");
        msg.setEditable(false);
        buttonPanel.add(msg);

        drawPanel.setMode(NONE);
        drawPanel.setBackground(Color.white);
        add(drawPanel, BorderLayout.CENTER);
        add(buttonPanel, BorderLayout.SOUTH);

        setSize(500, 300);
        setVisible(true);
    }

    public static void main(String [] args)
    {
        DrawTest win = new DrawTest();

        win.addWindowListener(
            new WindowAdapter()
            {
                public void windowClosing(WindowEvent e)
                { 
                    System.exit(0); 
                }
            }
        );
    }

    private class ButtonHandler implements ActionListener
    {
        public void actionPerformed(ActionEvent e)
        {
            if (e.getSource() == drawPoly && mode == DrawTest.NONE)
            {
                created = false;
                drawPanel.setMode(POLY);
                msg.setText("Use Mouse to Draw Rect");
            }
            else 
            {
                created = false; 
                drawPanel.setMode(NONE);
                msg.setText("End draw");
            }
        }
    }

    private class ShapePanel extends JPanel
    {
        public ShapePanel (int pwid, int pht)
        {
            shapeList = new Vector<Polygon>();
            colorList = new Vector<Color>();
            selindex = -1;

            addMouseListener(             
                new MouseAdapter() {
                    @Override
                    public void mousePressed(MouseEvent e) {
                        x1 = e.getX();  
                        y1 = e.getY();
                        
                        if (e.getButton() == MouseEvent.BUTTON1) {
                            if (mode == DrawTest.POLY) {
                                if (created == true) {
                                    newShape.addPoint(oldX, oldY);
                                    n++;
                                }
                                else {
                                    //System.out.println("new selindex is "+selindex);
                                    n = 1;
                                }
                            }
                            else if (mode == DrawTest.NONE)
                            {
                                selindex = getSelected(x1, y1);
                                if (selindex >= 0) {
                                    msg.setText("Moving Polygon");
                                }
                            }
                            repaint();
                        }
                        else {
                            if (mode == DrawTest.NONE)
                            {
                                selindex = getSelected(x1, y1);
                                if (selindex >= 0) {
                                    popupevent(e);
                                    msg.setText("Right clicked");
                                }
                                else {
                                    JOptionPane.showMessageDialog(null, "Right click on the shape");
                                }
                            }
                        }
                    }
                          
                    @Override
                    public void mouseReleased(MouseEvent e) {
                        if (selindex >= 0)
                        {   
                            if (e.getButton() == MouseEvent.BUTTON3) {
                                popupevent(e);
                            }
                            else {
                                colorList.setElementAt(Color.black, selindex);
                                selindex = -1;
                                repaint();
                                msg.setText("");
                            }
                        }    
                    }
                    
                    public void popupevent(MouseEvent e) {
                        if (e.isPopupTrigger()) {
                            if (shapeList.elementAt(selindex).contains(x1, y1)) {
                                ActionListener menulistener = new ActionListener() {
                                    public void actionPerformed(ActionEvent event) {
                                        if (selindex >= 0 && selindex <= shapeList.size()-1) {
                                            //System.out.println("before delete vector size is "+shapeList.size());
                                            shapeList.removeElementAt(selindex);
                                            msg.setText("");
                                            repaint();
                                            //System.out.println("delete index is "+selindex);
                                            //System.out.println("after delete vector size is "+shapeList.size());
                                        }
                                        else if (shapeList.isEmpty()) {
                                            JOptionPane.showMessageDialog(null, "vector is empty");
                                        }
                                    }
                                };
                                menuitem.addActionListener(menulistener);
                                popup.show(e.getComponent(), x1, y1);
                            }
                        }
                    }
                }
            );

            addMouseMotionListener(        
                new MouseMotionAdapter() {
                    public void mouseDragged(MouseEvent e)
                    {
                        x2 = e.getX();   
                        y2 = e.getY();
                              
                        if (mode == DrawTest.POLY)
                        {
                            if (!created)  {
                                msg.setText("New poly been created");
                                newShape = new Polygon();
                                newShape.addPoint(x1, y1);
                                newShape.addPoint(x2, y2);
                                addshape(newShape);
                                created = true;
                            }
                            else{ 
                                msg.setText("Update polygon");
                                if (newShape.contains(x2, y2)) {
                                    JOptionPane.showMessageDialog(null, "Don't draw inside polygon");
                                }
                                else {
                                    //System.out.println("n value is "+n);
                                    oldX = x2;
                                    oldY = y2;
                                    newShape.xpoints[n] = x2;
                                    newShape.ypoints[n] = y2;
                                }
                            } 
                        }
                        else if (mode == DrawTest.NONE && selindex >= 0) {
                            //System.out.println("drag shape");
                            shapeList.elementAt(selindex).translate(x2-x1, y2-y1);
                            x1 = x2;
                            y1 = y2;
                     
                        }
                        repaint();
                    }
                }
            );
        }  

        private int getSelected(int x, int y) {
            for (int i = 0; i < shapeList.size(); i++)
            {
                if ( (shapeList.elementAt(i)).contains(x, y))
                {
                    colorList.setElementAt(Color.red, i);
                    return i;
                }
            }
            return -1;
        }

        public void setMode(int newMode)   
        {
            mode = newMode;
        }

        private void addshape(Polygon newshape)     
        {
            shapeList.addElement(newshape);
            colorList.addElement(Color.black);
            //System.out.println("add new element vector size is "+shapeList.size());
            repaint();
        }

        public void paintComponent (Graphics g)
        {
            super.paintComponent(g);         
            Graphics2D g2d = (Graphics2D) g;
            for (int i = 0; i < shapeList.size(); i++)
            {
                g2d.setColor(colorList.elementAt(i));
                g2d.draw(shapeList.elementAt(i));
            }
        }

    } // end of ShapePanel
}
