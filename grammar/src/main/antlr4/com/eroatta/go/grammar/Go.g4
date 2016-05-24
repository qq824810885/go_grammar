grammar Go;

sourceFile : packageClause (importDecl)* (topLevelDecl ';')* ;

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
	| functionDecl
	| methodDecl
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
	
// function declaration
functionDecl : 'func' functionName function
	| 'func' functionName signature
	;
functionName : identifier ;
function : signature functionBody ;
functionBody : block ;
block : '{' statementList '}' ;
statementList : (statement ';')* ;

functionLit : 'func' function ; //anonymous functions (closures)

statement : declaration 
	| labeledStmt 
	| simpleStmt 
	| goStmt 
	| returnStmt 
	| breakStmt 
	| continueStmt 
	| gotoStmt 
	| fallthroughStmt 
	| block 
	| ifStmt 
	| switchStmt 
	| selectStmt 
	| forStmt 
	| deferStmt
	;

labeledStmt : label ':' statement ;
label : identifier ;

goStmt : 'go' expression ;

returnStmt : 'return' expressionList? ;

breakStmt : 'break' label? ;

continueStmt : 'continue' label? ;

gotoStmt : 'goto' label ;

fallthroughStmt : 'fallthrough' ;

ifStmt : 'if' (simpleStmt ';')? expression block ('else' (ifStmt | block))? ;

switchStmt : exprSwitchStmt
	| typeSwitchStmt
	;
	
exprSwitchStmt : 'switch' (simpleStmt ';')? expression? '{' (exprCaseClause)* '}' ;
exprCaseClause : exprSwitchCase ':' statementList ;
exprSwitchCase : 'case' expressionList
	| 'default'
	;

typeSwitchStmt : 'switch' (simpleStmt ';')? typeSwitchGuard '{' (typeCaseClause)* '}' ;
typeSwitchGuard : (identifier ':=')? primaryExpr '.(type)' ;
typeCaseClause : 'case' typeList
	| 'default'
	;
typeList : type (',' type)* ;

selectStmt : 'select' '{' (commClause)* '}' ;
commClause : commCase ':' statementList ;
commCase : 'case' (sendStmt | recvStmt)
	| 'default'
	;
recvStmt : (expressionList '=' | identifierList ':=')? recvExpr ;
recvExpr : expression ;

forStmt : 'for' condition block 
	| 'for' forClause block
	| 'for' rangeClause block
	;

condition : expression ;

forClause : initStmt? ';' condition? ';' postStmt ;
initStmt : simpleStmt ;
postStmt : simpleStmt ;

rangeClause : (expressionList '=' | identifierList ':=')? 'range' expression ;

deferStmt : 'defer' expression ;

simpleStmt : emptyStmt 
	| expressionStmt 
	| sendStmt 
	| incDecStmt 
	| assignment 
	| shortVarDecl
	;

emptyStmt : '' ; // TODO: review

expressionStmt : expression ;

sendStmt : channel '<-' expression;
channel : expression ; // TODO: review

incDecStmt : expression '++'
	| expression '--'
	;
	
assignment : expressionList assignOp expressionList ;
assignOp : (addOp | mulOp)? '=' ;

shortVarDecl : identifierList ':=' expressionList ;

// method declarations
methodDecl : 'func' receiver methodName (function | signature) ;
receiver : parameters ;

// primary expressions
primaryExpr : operand
	| conversion
	| primaryExpr selector
	| primaryExpr index
	| primaryExpr slice
	| primaryExpr typeAssertion
	| primaryExpr arguments
	;
	
selector : '.' identifier ;
index : '[' expression ']' ;
slice : '[' expression? ':' expression? ']'
	| '[' expression? ':' expression ':' expression ']'
	;
typeAssertion : '.' '(' type ')' ;
arguments : '(' ')'
	| '(' (expressionList | type (',' expressionList)?) '...'? ','? ')'
	;
	
// operands
operand : literal 
	| operandName
	| methodExpr
	| '(' expression ')'
	;
	
// literals
literal : basicLit
	| compositeLit
	| functionLit
	;
basicLit : intLit
	| floatLit
	| imaginaryLit
	//| runeLit TODO: complex!
	//| stringLit
	;
intLit : decimalLit
	| octalLit
	| hexLit
	;
decimalLit : NUMBER ;// TODO: review
octalLit : '0' (OCTAL_DIGIT)* ;
hexLit : '0' ('x' | 'X') (HEX_DIGIT)+ ;

DECIMAL_DIGIT : [0-9] ;
OCTAL_DIGIT : [0-7] ;
HEX_DIGIT : [0-9] | [A-F] | [a-f] ;

floatLit : decimals '.' decimals? exponent?
	| decimals exponent
	| '.' decimals exponent?
	;
decimals : DECIMAL_DIGIT (DECIMAL_DIGIT)* ; //TODO: number?
exponent : ('e' | 'E') ('+' | '-')? decimals ;

imaginaryLit : (decimals | floatLit) 'i' ;

stringLit : STRING ;

compositeLit : literalType literalValue ;
literalType : structType
	| arrayType
	| '[' '...' ']' elementType
	| sliceType
	| mapType
	| typeName
	;
literalValue : '{' (elementList ','?)? '}' ;
elementList : keyedElement (',' keyedElement)* ;
keyedElement : (key ':')? element ;
key : fieldName
	| expression
	| literalValue
	;
fieldName: identifier ;
element : expression
	| literalValue
	;
	
operandName : identifier
	| qualifiedIdent
	;

methodExpr : receiverType '.' methodName ;
receiverType : typeName
	| '(' '*' typeName ')'
	| '(' receiverType ')'
	;

conversion : type '(' expression ','? ')' ;

// expressions
expressionList : 'TODO' ;// TODO ;

expression : unaryExpr
	| expression binaryOp expression
	;
unaryExpr : primaryExpr
	| unaryOp unaryExpr
	;
	
binaryOp : '||'
	| '&&'
	| relOp
	| addOp
	| mulOp
	;
relOp : '==' | '!=' | '<' | '<=' | '>' | '>=' ;
addOp : '+' | '-' | '|' | '^' ;
mulOp : '*' | '/' | '%' | '<<' | '>>' | '&' | '&^' ;

unaryOp : '+' | '-' | '!' | '^' | '*' | '&' | '<-' ;

qualifiedIdent : packageName '.' identifier ;
packageName : identifier ;

identifier : STRING ;

STRING : [a-z\/\._]+ ;
NUMBER : [0-9]+ ;

WS: (' ' | '\t\n\r')+ -> skip ;