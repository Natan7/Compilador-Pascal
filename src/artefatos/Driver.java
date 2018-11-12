package artefatos;

import java_cup.runtime.*;

class Driver {

	public static void main(String[] args) throws Exception {
		Parser parser = new Parser();
		parser.parse();
		/*
		Lexer lexer = new Lexer(new FileReader("entrada/input.txt"));
		Parser parser = new Parser(lexer);
		parser.parse();
		System.out.println(parser.parse() + "\n");
		*/
	}
	
}