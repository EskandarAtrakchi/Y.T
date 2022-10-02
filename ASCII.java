//American Standard Code for Information Interchange (ASCII)
//this code was made by Eskandar Atrakchi

import java.util.Scanner;
 
class Micc {
	static String struserInput;

	public static void main(String[] args) {
	
		actual();
		Main();
		exit();
		info();
	}
	public static void actual() {
		Scanner y = new Scanner (System.in);
		System.out.println("Select number 1 to choose an Alphabet\nor number 2 to exit");

		while(true) {
			try {//This might needed to be moved somewhere else 
				int x = y.nextInt();
				System.out.println("Please confirm your number again ");
			}
			catch (Exception e) {
				System.out.println("Something went wrong! please, choose again ");actual();
			}
			int x = y.nextInt();
			switch(x) {
			case 1 : 
				Main();System.out.println("You can select another Alphbet or select number 2 to exit the system ");break;
			case 2 : System.out.println("The system is shutted down"); exit();break;
			default : System.out.println("Please try again "); actual();
			}
		}
	}
	
	public static void Main() {
		System.out.println("Please enter the Alphabet");
		Scanner scanner = new Scanner (System.in);
		char ch = scanner.next().charAt(0);
		int ASCII = ch;
		
		System.out.println("The value of " + ch + " is " + ASCII);
	}
	public static void exit() {
		System.exit(0);
	}
	public static void info() {
		System.out.println("Wrong input!");
	}
}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	