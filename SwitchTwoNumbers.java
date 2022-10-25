package MyGame;

import java.util.Random;
import java.util.Scanner;

public class SwitchTwoNumbers {
	
	

    public static void main(String[] args) {
    	System.out.println("Guess if the numbers will Change or not!");
    	
    	method();
    	
    	
    }
    static void method() {
    	
    	Scanner X = new Scanner(System.in);
    	
    	System.out.println("Enter your first number");
        int first = X.nextInt();
        System.out.println("Enter your second number");
        int second = X.nextInt();

        int temporary = first;
        first = second;
        second = temporary;

        int S = r();
        switch(S) {
        case 1 : 
        	 System.out.println("--They changed!--");
             System.out.println("First number = " + first);
             System.out.println("Second number = " + second);
             break;
       
        case 2 :
        	System.out.println("--They did not change!--");
            System.out.println("First number = " + second);
            System.out.println("Second number = " +first );
            break;
        	
        }
        System.out.println("1. to start\n2. to exit");
        int Y = X.nextInt();
        switch(Y) {
        case 1 : method(); break;
        case 2 :  System.out.println("Good-Bye"); X.close(); System.exit(0);
        }
    	
    }
    
    static int r() {
    	Random r = new Random();
    	int R = r.nextInt(2)+1;
    	return R;
    }
}