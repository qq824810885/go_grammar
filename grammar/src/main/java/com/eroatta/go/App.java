package com.eroatta.go;

import java.io.InputStream;

import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.ParseTreeWalker;

import com.eroatta.go.grammar.GoLexer;
import com.eroatta.go.grammar.GoParser;
import com.eroatta.go.listeners.GoPrinterListener;

/**
 * Example parser app!
 *
 */
public class App {

	public static void main(String[] args) throws Exception {
		// create a resource stream that reads the resource files
		InputStream resourceStream = App.class
				.getResourceAsStream("/main.go");
		ANTLRInputStream inputStream = new ANTLRInputStream(resourceStream);

		// create a lexer that feeds off of input resource stream
		GoLexer lexer = new GoLexer(inputStream);

		// create a buffer of tokens pulled from the lexer
		CommonTokenStream tokens = new CommonTokenStream(lexer);

		// create a parser that feeds off the tokens buffer
		GoParser parser = new GoParser(tokens);

		// begin parsing at the start rule
		ParseTree tree = parser.sourceFile();
		System.out.println(tree.toStringTree(parser));
		
		// create a generic parse tree walker that can trigger callbacks
		ParseTreeWalker walker = new ParseTreeWalker();
		
		// walk the tree created during the parse, trigger callbacks
		walker.walk(new GoPrinterListener(), tree);
		System.out.println("-------------------");
	}
}
