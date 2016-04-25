grammar Go;

sourceFile : packageClause (importDecl)* ; // { topLevelDecl ';' } ;

// package
packageClause : 'package' identifier;

// imports
importDecl : 'import' importSpec 
	| 'import''(' (importSpec)* ')';
	
importSpec : 
	'.' importPath
	| '_' importPath
	| identifier importPath
	| importPath;
importPath : '"' identifier '"';

// top level declarations
topLevelDecl : ;

// common rules and tokens
identifier : STRING ;

STRING : [a-z\/\._]+ ;

WS: (' ' | '\t\n\r')+ -> skip;