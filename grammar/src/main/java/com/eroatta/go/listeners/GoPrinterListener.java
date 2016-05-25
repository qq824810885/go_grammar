package com.eroatta.go.listeners;

import com.eroatta.go.grammar.GoBaseListener;
import com.eroatta.go.grammar.GoParser.ImportSpecContext;
import com.eroatta.go.grammar.GoParser.PackageClauseContext;

public class GoPrinterListener extends GoBaseListener {

	@Override
	public void enterPackageClause(PackageClauseContext ctx) {
		System.out.println("Package: " + ctx.packageName().getText());
	}

	@Override
	public void enterImportSpec(ImportSpecContext ctx) {
		System.out.println("Imported package: " + ctx.importPath().getText());
	}
	
	
}
