package com.eroatta.go.listeners;

import com.eroatta.go.grammar.GoBaseListener;
import com.eroatta.go.grammar.GoParser.FunctionDeclContext;
import com.eroatta.go.grammar.GoParser.ImportSpecContext;
import com.eroatta.go.grammar.GoParser.PackageClauseContext;

public class GoPrinterListener extends GoBaseListener {

	@Override
	public void enterPackageClause(PackageClauseContext ctx) {
		System.out.println("Package: " + ctx.identifier().getText());
	}

	@Override
	public void enterImportSpec(ImportSpecContext ctx) {
		String text = "Imported package: " + ctx.importPath().getText();
		if(ctx.identifier() != null) {
			text = text + " as " + ctx.identifier().getText();
		}
		System.out.println(text);
	}
	
	@Override
	public void enterFunctionDecl(FunctionDeclContext ctx) {
		System.out.println("Function: " + ctx.functionName().getText());
	}
}
