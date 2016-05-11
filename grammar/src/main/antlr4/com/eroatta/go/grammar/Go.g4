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
topLevelDecl : declaration
	//| functionDecl
	//| methodDecl
	;
	
declaration : constDecl
	| typeDecl
	| varDecl
	;

// constants
constDecl : 'const' constSpec
	| 'const' '(' (constSpec)* ')';
constSpec : identifierList ((type)? '=' identifierList)?; // TODO: cambiar por expressionList

identifierList : identifier (',' identifier)*;
//expressionList : expression (',' expression);

// type declaration
typeDecl : 'type' typeSpec
	| 'type' '(' (typeSpec ';')* ')'
	;
typeSpec : identifier type ;

// common rules and tokens
type : typeName
	| typeLit
	| '(' type ')'
	;
typeName : identifier
	| qualifiedIdent
	;
typeLit : 'bool'
	| 'byte'
	| 'complex64'
	| 'complex128'
	| 'error'
	| 'float32'
	| 'float64'
	| 'int'
	| 'int8'
	| 'int16'
	| 'int32'
	| 'int64'
	| 'rune'
	| 'string'
	| 'uint'
	| 'uint8'
	| 'uint16'
	| 'uint32'
	| 'uint64'
	| 'uintptr'
	| arrayType
	| structType
	| pointerType
	| functionType
	| interfaceType
	| sliceType
	| mapType
	| channelType
	;

// type literals
arrayType : '[' arrayLength ']' elementType ;
arrayLength : NUMBER ; // TODO: replace by expression
elementType : type ;

structType : 'struct' '{' (fieldDecl ';')* '}' ;
fieldDecl : identifierList type tag?
	| anonymousField tag?
	;
anonymousField : '*'? typeName ;
tag : STRING ; // TODO: replace by string_lit

pointerType : '*' type ; 

functionType : 'func' signature ;
signature : parameters result? ;
result : parameters
	| type
	;
parameters : '(' parameterList? ')' ;
parameterList : parameterDecl (',' parameterDecl)* ;
parameterDecl : identifierList? '...'? type ;

interfaceType : 'interface' '{' (methodSpec ';')* '}' ;
methodSpec : methodName signature
	| interfaceTypeName
	;
methodName : identifier ;
interfaceTypeName : typeName ;

sliceType : '[' ']' elementType ;

mapType : 'map' '[' keyType ']' elementType ;
keyType : type ;

channelType : 'chan' elementType
	| 'chan' '<-' elementType
	| '<-' 'chan' elementType
	;

// variable declaration
varDecl : 'var' varSpec
	| 'var' '(' (varSpec ';')* ')'
	;
varSpec : identifierList type ('=' expressionList)?
	| identifierList '=' expressionList
	;

expressionList : 'TODO' ;// TODO ;

qualifiedIdent : packageName '.' identifier ;
packageName : identifier ;

identifier : STRING ;

STRING : [a-z\/\._]+ ;
NUMBER : [0-9]+ ;

WS: (' ' | '\t\n\r')+ -> skip ;