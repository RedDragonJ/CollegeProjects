package labassign3;

import java.util.Scanner;
import javax.swing.JOptionPane;

/**
 *
 * @author JamesSun
 */
public class labassign3_jop {

    public static void main(String[] args) {
        Scanner input = new Scanner(System.in);
        double num = 0, avg, largest = 0, total = 0;
        int count1 = 0, count2 = 0, count3 = 0;
        String savg = new String();
        String slargest = new String();
        
        while (num != -1) {
            num = Integer.parseInt(JOptionPane.showInputDialog("Enter the Salary:"));
            if (num < 40000 && num > 0) {
                count1 = count1 + 1;
                total = total + num;
            }
            else if (num >= 40000 && num <= 100000) {
                count2 = count2 + 1;
                total = total + num;
            }
            else if (num > 100000) {
                count3 = count3 + 1;
                total = total + num;
                if (largest > 0) {
                    if (largest > num) {
                        largest = largest;
                    }
                    else {
                        largest = num;
                    }
                }
                else {
                    largest = num;
                }
            }
        }
        
        avg = total/(count1 + count2 + count3);
        savg = String.format("%.2f", avg);
        slargest = String.format("%.2f", largest);
       
        JOptionPane.showMessageDialog(null, "There are "+count1+" salaries less than 40000"+"\n"
                + "There are "+count2+" salaries between 40000 and 100000"+"\n"+
                "There are "+count3+" salaries greater than 100000"+"\n"+
                "The average is "+savg+"\n"+"The largest salary is "+largest);
    }
    
}
