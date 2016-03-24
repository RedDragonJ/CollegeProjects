//import java.applet.Applet;
import java.awt.*;
import java.awt.event.*;
import java.awt.geom.*;
import javax.swing.*;
/**
 *
 * @author JamesSun
 */
public class AppletTest extends JApplet {

    private JPanel down;
    private JLabel label1, label2, label3, label4, label5, label6;
    private JComboBox<String> shapebox;
    private JRadioButton radiobutton1, radiobutton2;
    private JTextField text1, text2, text3, text4;
    private JButton button1, button2, button3;
    private double size1, size2, size3, size4, width, height, radius;
    private double x1, x2, y1, y2, newx1, newy1, newx2, newy2;
    private double m, b;
    private int radio1, radio2, index;
    private ButtonGroup bgroup;
    private String shapename[] = {" ", "Line", "Rectangle", "Circle"};
    private Line2D line;
    private JColorChooser chcolor;
    private Color newcolor;
    
    public void init() {
        down = new JPanel(new FlowLayout());
        down.setLayout(new GridLayout(4, 4, 0, 0));
        label1 = new JLabel("Pick shape and style");
        shapebox = new JComboBox<String> (shapename);
        label2 = new JLabel(" ");
        label3 = new JLabel(" ");
        label4 = new JLabel(" ");
        label5 = new JLabel(" ");
        bgroup = new ButtonGroup();
        text1 = new JTextField(10);
        text2 = new JTextField(10);
        text3 = new JTextField(10);
        text4 = new JTextField(10);
        radiobutton1 = new JRadioButton("Solid");
        radiobutton2 = new JRadioButton("Outline");
        button1 = new JButton("Draw");
        button2 = new JButton("Reset");
        button3 = new JButton("Exit");
        label6 = new JLabel("Waiting");  
        down.setComponentOrientation(ComponentOrientation.LEFT_TO_RIGHT);
        down.add(label1);
        down.add(shapebox);
        bgroup.add(radiobutton1);
        bgroup.add(radiobutton2);
        radiobutton1.addItemListener(new radiobuttonhandler());
        down.add(radiobutton1);
        radiobutton2.addItemListener(new radiobuttonhandler());
        down.add(radiobutton2);
        down.add(label2);
        down.add(label3);
        down.add(label4);
        down.add(label5);
        down.add(text1);
        down.add(text2);
        down.add(text3);
        down.add(text4);
        down.add(button1);
        down.add(button2);
        down.add(button3);
        down.add(label6);
        add(down, BorderLayout.SOUTH);
    
        shapebox.addItemListener(new ItemListener() {
            @Override
            public void itemStateChanged(ItemEvent e){
                index = shapebox.getSelectedIndex();
                if (index == 1) {
                    label2.setText("1st Point x value");
                    label3.setText("1st Point y value");
                    label4.setText("2nd Point x value");
                    label5.setText("2nd Point y value");
                    label6.setText("Line");
                }
                else if (index == 2) {
                    label2.setText("Left top x");
                    label3.setText("Left top y");
                    label4.setText("right bottom x");
                    label5.setText("right bottom y");
                    label6.setText("Rectangle");
                }   
                else if (index == 3) {
                    label2.setText("Center x");
                    label3.setText("Center y");
                    label4.setText("Circle radius");
                    label5.setText("Just enter 0");
                    label6.setText("Circle");
                }
            }  
        }
        );
    
        drawbutton handler1 = new drawbutton();
        button1.addActionListener(handler1);
    
        resetbutton handler2 = new resetbutton();
        button2.addActionListener(handler2);
    
        closebutton handler3 = new closebutton();
        button3.addActionListener(handler3);
    }
        
    public void paint(Graphics g) {
        super.paint(g);
        Graphics2D g2 = (Graphics2D)g;
        for (int i=400; i>=100; i-=10){
            if (i != 250){
                g.drawLine(100, i, 400, i);
            }
        }
        
        for (int j=400; j>=100; j-=10){
            if (j != 250){
                g.drawLine(j, 400, j, 100);
            }
        }
        g2.setStroke(new BasicStroke(2));
        g2.drawLine(100, 250, 400, 250);
        g2.drawLine(250, 400, 250, 100);
        
        if (index == 1){
            g2.setColor(newcolor);
            line = new Line2D.Double(size1, size2, size3, size4);
            g2.draw(line);
        }
        else if (index == 2){
            if (radio1 == 1) {
                g2.setColor(newcolor);
                g2.fillRect((int)size1, (int)size2, (int)width, (int)height);
            }
            else if (radio2 == 2) {
                g2.setColor(newcolor);
                g2.drawRect((int)size1, (int)size2, (int)width, (int)height);
            }
        }
        else if (index == 3){
            if (radio1 == 1) {
                g2.setColor(newcolor);
                g2.fillOval((int)size1, (int)size2, (int)size3, (int)size3);
            }
            else if (radio2 == 2) {
                g2.setColor(newcolor);
                g2.drawOval((int)size1, (int)size2, (int)size3, (int)size3);
            }
        }
    }
     
    private class radiobuttonhandler implements ItemListener {
        @Override
        public void itemStateChanged(ItemEvent e)  {
            if (radiobutton1.isSelected()) {
                radio1 = 1;
            }
            else if (radiobutton2.isSelected()) {
                radio2 = 2;
            }
            else {
                radio1 = 0;
                radio2 = 0;
            }       
        }
    }
    
    private class drawbutton implements ActionListener  {
        @Override
        public void actionPerformed(ActionEvent e)  {
            
            try{
                x1 = Integer.parseInt(text1.getText());
                y1 = Integer.parseInt(text2.getText());
                x2 = Integer.parseInt(text3.getText());
                y2 = Integer.parseInt(text4.getText()); 
                newx1 = x1*10;
                newy1 = y1*10;
                newx2 = x2*10;
                newy2 = y2*10;
                
                if (newx1 > 150 || newx1 < -150) {
                    JOptionPane.showMessageDialog(null, "1st x out size!");
                }
                else if (newy1 > 150 || newy1 < -150) {
                    JOptionPane.showMessageDialog(null, "1st y out size!");
                }
                else if (newx2 > 150 || newx2 < -150) {
                    JOptionPane.showMessageDialog(null, "2st x out size!");
                }
                else if (newy2 > 150 || newy2 < -150) {
                    JOptionPane.showMessageDialog(null, "2st y out size!");
                }     
                else {
                
                    if (newx1 < 0) {
                        newx1 = 250 + newx1;
                    }   
                    else if (newx1 > 0) {
                        newx1 = 250 + newx1;
                    }
                    else {
                        newx1 = 250;
                    }
                
                    if (newy1 < 0) {
                        newy1 = 250 - newy1;
                    }
                    else if (newy1 > 0) {
                        newy1 = 250 - newy1;
                    }
                    else {
                        newy1 = 250;
                    }
                
                    if (newx2 < 0) {
                        newx2 = 250 + newx2;
                    }
                    else if (newx2 > 0) {
                        newx2 = 250 + newx2;
                    }
                    else {
                        newx2 = 250;
                    }
                
                    if (newy2 < 0) {
                        newy2 = 250 - newy2;
                    }
                    else if (newy2 > 0) {
                        newy2 = 250 - newy2;
                    }
                    else {
                        newy2 = 250;
                    }
                    m = (newy2-newy1)/(newx2-newx1);
                    b = newy1-(m*newx1);
                
                    if (index == 1) {
                        size1 = (100-b)/m;
                        size3 = (400-b)/m;
                        size2 = 100;
                        size4 = 400;
                        if (size1 < 100) {
                            size2 = (m*100)+b;
                            size1 = 100;
                        }
                        else if (size1 > 400) {
                            size2 = (m*400)+b;
                            size1 = 400;
                        }
                        
                        if (size3 < 100) {
                            size4 = (m*100)+b;
                            size3 = 100;
                        }
                        else if (size3 > 400) {
                            size4 = (m*400)+b;
                            size3 = 400;
                        }
                        Color initialBackground = button1.getBackground();
                        newcolor = JColorChooser.showDialog(null, "Choose Color", initialBackground);
                        if (newcolor != null) {
                            button1.setBackground(newcolor);
                        }
                        repaint();
                    }
                    else if (index == 2) {
                        if (radio1 == 1 || radio2 == 2) {    
                            double temp;
                            size1 = newx1;
                            size2 = newy1;
                            size3 = newx2;
                            size4 = newy2;
                            if (size1 < size3) {
                                width = size3 - size1;
                            }
                            else if (size3 < size1) {
                                width = size1 - size3;
                            }
                            if (size2 < size4) {
                                height = size4 - size2;
                            }
                            else if (size4 < size2) {
                                height = size2 - size4;
                            }                         
                            if (size1 > 250) {
                                temp = size1 + width;
                                if (temp > 400) {
                                    size1 = size1 - width;
                                    Color initialBackground = button1.getBackground();
                                    newcolor = JColorChooser.showDialog(null, "Choose Color", initialBackground);
                                    if (newcolor != null) {
                                        button1.setBackground(newcolor);
                                    }
                                    repaint();
                                }
                            }
                            else if (size2 > 250) {
                                temp = size2 + height;
                                if (temp > 400) {       
                                    size2 = size2 - height;
                                    Color initialBackground = button1.getBackground();
                                    newcolor = JColorChooser.showDialog(null, "Choose Color", initialBackground);
                                    if (newcolor != null) {
                                        button1.setBackground(newcolor);
                                    }
                                    repaint();
                                }
                            }
                            else {
                                Color initialBackground = button1.getBackground();
                                newcolor = JColorChooser.showDialog(null, "Choose Color", initialBackground);
                                if (newcolor != null) {
                                    button1.setBackground(newcolor);
                                }
                                repaint();
                            }
                        }
                        else {
                            JOptionPane.showMessageDialog(null, "Please select Solid or Outline!");
                        }
                    }
                    else if (index == 3) {
                        if (radio1 == 1 || radio2 == 2) {
                            double temp;
                            size1 = newx1;
                            size2 = newy1;
                            size3 = x2*10*2;
                            size1 = size1 - (size3/2);
                            size2 = size2 - (size3/2);
                            
                            if (size1 < 250) {
                                temp = size1 - x2*10;
                                if (temp < 100) {
                                    JOptionPane.showMessageDialog(null, "Choose smaller radius or increase x!");
                                }
                                else {
                                    Color initialBackground = button1.getBackground();
                                    newcolor = JColorChooser.showDialog(null, "Choose Color", initialBackground);
                                    if (newcolor != null) {
                                        button1.setBackground(newcolor);
                                    }
                                    repaint();
                                }
                            }
                            else if (size1 > 250) {
                                temp = size1 + x2*10;
                                if (temp > 400) {
                                    JOptionPane.showMessageDialog(null, "Choose smaller radius or decrease x!");
                                }
                                else {
                                    Color initialBackground = button1.getBackground();
                                    newcolor = JColorChooser.showDialog(null, "Choose Color", initialBackground);
                                    if (newcolor != null) {
                                        button1.setBackground(newcolor);
                                    }
                                    repaint();
                                }
                            }
                            else if (size2 < 250) {
                                temp = size2 - x2*10;
                                if (temp < 100) {
                                    JOptionPane.showMessageDialog(null, "Choose smaller radius or increase y!");
                                }
                                else {
                                    Color initialBackground = button1.getBackground();
                                    newcolor = JColorChooser.showDialog(null, "Choose Color", initialBackground);
                                    if (newcolor != null) {
                                        button1.setBackground(newcolor);
                                    }
                                    repaint();
                                }
                            }
                            else if (size2 > 250) {
                                temp = size2 + x2*10;
                                if (temp > 400) {
                                    JOptionPane.showMessageDialog(null, "Choose smaller radius or decrease y!");
                                }
                                else {
                                    Color initialBackground = button1.getBackground();
                                    newcolor = JColorChooser.showDialog(null, "Choose Color", initialBackground);
                                    if (newcolor != null) {
                                        button1.setBackground(newcolor);
                                    }
                                    repaint();
                                }
                            }
                        }
                        else {
                            JOptionPane.showMessageDialog(null, "Please select Solid or Outline!");
                        }
                    }
                }
            }
            catch(NumberFormatException n) {
                JOptionPane.showMessageDialog(null, "Please enter all numbers!");
            }
        }      
    }
    
    private class resetbutton implements ActionListener {
        @Override
        public void actionPerformed(ActionEvent e) {
            text1.setText("");
            text2.setText("");
            text3.setText("");
            text4.setText("");
            label6.setText("Waiting ");
            index = 0;
            repaint();
        }
    }
    
    private class closebutton implements ActionListener  {
        @Override
        public void actionPerformed(ActionEvent e)  { 
            System.exit(0);   
        }
    }
}