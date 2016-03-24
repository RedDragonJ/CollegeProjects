package labassign3;
/**
 *
 * @author JamesSun
 */
public class Labassign3 {

    public static void main(String[] args) {
        final double cm = 2.54;
        double answer;
        
        System.out.println("Convert from inches to cm");
        System.out.println("--------------------");
        System.out.println("inches     cm");
        for (int i=1; i <=10; i++) {
            answer = i * cm;
            System.out.println(i+" "+"        "+answer);
        }
    }
    
}
