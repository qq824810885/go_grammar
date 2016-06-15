grammar Go;

// starting point for parsing a go file
compilationUnit
	: packageClause importDecl* topLevelDecl* EOF
	;

// package
packageClause
	: 'package' identifier
	;

// imports
importDecl 
	: 'import' importSpec 
	| 'import''(' importSpec* ')' 
	;

importSpec
	: importPath
	| identifier importPath
	| '_' importPath
	| '.' importPath
	;

importPath 
	: qualifiedIdent
	| identifier 
	;

// top level declarations
topLevelDecl
	: declaration
	| functionDecl
	| methodDecl
	;
	
declaration
	: constDecl
	| typeDecl
	| varDecl
	;

// constants declaration
constDecl
	: 'const' constSpec
	| 'const' '(' constSpec* ')' 
	;

constSpec
	: identifierList ((type)? '=' expressionList)?
	; 

// type declaration
typeDecl
	: 'type' typeSpec
	| 'type' '(' typeSpec* ')'
	;

typeSpec
	: identifier type
	;

// types
type 
	: typeName
	| typeLit
	| '(' type ')'
	;
	
typeName 
	: identifier
	| qualifiedIdent
	;
	
typeLit 
	: 'bool'
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
arrayType
	: '[' arrayLength ']' elementType 
	;
	
arrayLength 
	: expression 
	;
	
elementType 
	: type 
	;

structType 
	: 'struct' '{' fieldDecl* '}' 
	;
	
fieldDecl 
	: identifierList type tag?
	| anonymousField tag?
	;
	
anonymousField 
	: '*'? typeName 
	;
	
tag 
	: stringLit 
	;

pointerType 
	: '*' type 
	; 

functionType 
	: 'func' signature 
	;
	
signature 
	: parameters result? 
	;
	
result 
	: parameters
	| type
	;
	
parameters 
	: '(' (parameterList ','?)? ')' 
	;
	
parameterList 
	: parameterDecl (',' parameterDecl)* 
	;
	
parameterDecl 
	: identifierList? '...'? type 
	;

interfaceType
	: 'interface' '{' methodSpec* '}' 
	;
	
methodSpec 
	: methodName signature
	| interfaceTypeName
	;
	
methodName 
	: identifier 
	;
	
interfaceTypeName 
	: typeName 
	;

sliceType 
	: '[' ']' elementType 
	;

mapType 
	: 'map' '[' keyType ']' elementType 
	;
	
keyType 
	: type 
	;

channelType 
	: 'chan' elementType #bidirectionalChannel
	| 'chan' '<-' elementType #senderChannel
	| '<-' 'chan' elementType #receiverChannel
	;

// variable declaration
varDecl 
	: 'var' varSpec
	| 'var' '(' varSpec * ')'
	;
	
varSpec 
	: identifierList type ('=' expressionList)?
	| identifierList '=' expressionList
	;
	
// function declaration
functionDecl 
	: 'func' functionName function
	| 'func' functionName signature
	;
	
functionName 
	: identifier 
	;
	
function 
	: signature functionBody 
	;
	
functionBody 
	: block 
	;
	
block 
	: '{' statementList '}' 
	;

functionLit 
	: 'func' function #closure
	;

statementList
	: statement* 
	;
	
statement 
	: declaration 
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

labeledStmt 
	: label ':' statement 
	;
	
label 
	: identifier 
	;

goStmt 
	: 'go' expression 
	;

returnStmt 
	: 'return' expressionList? 
	;

breakStmt 
	: 'break' label? 
	;

continueStmt 
	: 'continue' label? 
	;

gotoStmt 
	: 'goto' label 
	;

fallthroughStmt 
	: 'fallthrough' 
	;

ifStmt 
	: 'if' (simpleStmt ';')? expression block ('else' (ifStmt | block))? 
	;

switchStmt 
	: exprSwitchStmt
	| typeSwitchStmt
	;
	
exprSwitchStmt 
	: 'switch' (simpleStmt ';')? expression? '{' (exprCaseClause)* '}' 
	;
	
exprCaseClause 
	: exprSwitchCase ':' statementList 
	;
	
exprSwitchCase 
	: 'case' expressionList
	| 'default'
	;

typeSwitchStmt 
	: 'switch' (simpleStmt ';')? typeSwitchGuard '{' (typeCaseClause)* '}' 
	;
	
typeSwitchGuard 
	: (identifier ':=')? primaryExpr '.' '(' 'type' ')' 
	;
	
typeCaseClause 
	: 'case' typeList
	| 'default'
	;
	
typeList 
	: type (',' type)* 
	;

selectStmt 
	: 'select' '{' (commClause)* '}' 
	;
	
commClause 
	: commCase ':' statementList 
	;
	
commCase 
	: 'case' (sendStmt | recvStmt)
	| 'default'
	;
	
recvStmt 
	: (expressionList '=' | identifierList ':=')? recvExpr 
	;
	
recvExpr 
	: expression 
	;

forStmt 
	: 'for' condition block 
	| 'for' forClause block
	| 'for' rangeClause block
	;
	
condition 
	: expression 
	;

forClause 
	: initStmt? ';' condition? ';' postStmt 
	;
	
initStmt 
	: simpleStmt 
	;
	
postStmt 
	: simpleStmt 
	;

rangeClause 
	: (expressionList '=' | identifierList ':=')? 'range' expression 
	;

deferStmt 
	: 'defer' expression 
	;

simpleStmt 
	: emptyStmt 
	| expressionStmt 
	| sendStmt 
	| incDecStmt 
	| assignment 
	| shortVarDecl
	;

emptyStmt 
	: '' 
	;

expressionStmt 
	: expression 
	;

sendStmt 
	: channel '<-' expression 
	;
	
channel 
	: expression 
	;

incDecStmt 
	: expression '++' #incStmt
	| expression '--' #decStmt
	;
	
assignment 
	: expressionList assignOp expressionList 
	;
	
assignOp 
	: (addOp | mulOp)? '=' 
	;

shortVarDecl 
	: identifierList ':=' expressionList 
	;

// method declarations
methodDecl 
	: 'func' receiver methodName (function | signature) 
	;
	
receiver 
	: parameters 
	;

// primary expressions
primaryExpr 
	: operand
	| conversion
	| primaryExpr selector
	| primaryExpr index
	| primaryExpr slice
	| primaryExpr typeAssertion
	| primaryExpr arguments
	;
	
selector 
	: '.' identifier 
	;
	
index 
	: '[' expression ']' 
	;
	
slice 
	: '[' expression? ':' expression? ']'
	| '[' expression? ':' expression ':' expression ']'
	;
	
typeAssertion 
	: '.' '(' type ')' 
	;
	
arguments 
	: '(' ')'
	| '(' (expressionList | type (',' expressionList)?) '...'? ','? ')'
	;
	
// operands
operand 
	: literal 
	| operandName
	| methodExpr
	| '(' expression ')'
	;
	
// literals
literal 
	: basicLit
	| compositeLit
	| functionLit
	;
	
basicLit 
	: intLit
	| floatLit
	| imaginaryLit
	//| runeLit TODO: complex!
	| stringLit
	;
	
intLit 
	: DECIMAL_LIT
	| OCTAL_LIT
	| HEX_LIT
	;

floatLit 
	: decimals '.' decimals? exponent?
	| decimals exponent
	| '.' decimals exponent?
	;
	
decimals 
	: DECIMAL_DIGIT (DECIMAL_DIGIT)* 
	;
	
exponent 
	: ('e' | 'E') ('+' | '-')? decimals 
	;

imaginaryLit 
	: (decimals | floatLit) 'i' 
	;

runeLit 
	: '\'' unicodeValue '\''
	| '\'' byteValue '\''
	;
	
unicodeValue 
	: unicodeChar
	| littleUValue
	| bigUValue
	| ESCAPED_CHAR
	;
	
byteValue 
	: octalByValue
	| hexByteValue
	;
	
octalByValue 
	: '\\' OCTAL_DIGIT OCTAL_DIGIT OCTAL_DIGIT 
	;
	
hexByteValue 
	: '\\' 'x' HEX_DIGIT HEX_DIGIT 
	;
	
littleUValue 
	: '\\' 'u' HEX_DIGIT HEX_DIGIT HEX_DIGIT 
	;
	
bigUValue 
	: '\\' 'U' HEX_DIGIT HEX_DIGIT HEX_DIGIT
	HEX_DIGIT HEX_DIGIT HEX_DIGIT 
	;
	
ESCAPED_CHAR 
	: '\\a'
	| '\\b'
	| '\\f'
	| '\\n'
	| '\\r'
	| '\\t'
	| '\\v'
	| '\\/'
	| '\\''\''
	| '\\''\"'
	;

unicodeChar 
	: stringLit 
	; // TODO
	
stringLit 
	: STRING 
	; //TODO: stringLit!

compositeLit 
	: literalType literalValue 
	;
	
literalType 
	: structType
	| arrayType
	| '[' '...' ']' elementType
	| sliceType
	| mapType
	| typeName
	;
	
literalValue 
	: '{' (elementList ','?)? '}' 
	;
	
elementList 
	: keyedElement (',' keyedElement)* 
	;
	
keyedElement 
	: (key ':')? element 
	;
	
key 
	: fieldName
	| expression
	| literalValue
	;
	
fieldName
	: identifier 
	;
	
element 
	: expression
	| literalValue
	;
	
operandName 
	: identifier
	| qualifiedIdent
	;

methodExpr 
	: receiverType '.' methodName 
	;
	
receiverType 
	: typeName
	| '(' '*' typeName ')'
	| '(' receiverType ')'
	;

conversion 
	: type '(' expression ','? ')' 
	;

// expressions
expressionList 
	: expression (',' expression) 
	;

expression 
	: unaryExpr
	| expression binaryOp expression
	;
	
unaryExpr 
	: primaryExpr
	| unaryOp unaryExpr
	;
	
binaryOp 
	: '||'
	| '&&'
	| relOp
	| addOp
	| mulOp
	;
	
relOp : '==' | '!=' | '<' | '<=' | '>' | '>=' ;
addOp : '+' | '-' | '|' | '^' ;
mulOp : '*' | '/' | '%' | '<<' | '>>' | '&' | '&^' ;

unaryOp : '+' | '-' | '!' | '^' | '*' | '&' | '<-' ;

qualifiedIdent : identifier ('.' identifier)* ;
identifierList : identifier (',' identifier)* ;
identifier : stringLit ;

DECIMAL_LIT : [1-9] DECIMAL_DIGIT ;
DECIMAL_DIGIT : [0-9] ;

OCTAL_LIT : '0' (OCTAL_DIGIT)* ;
OCTAL_DIGIT : [0-7] ;

HEX_LIT : '0' ('x' | 'X') (HEX_DIGIT)+ ;
HEX_DIGIT : [0-9] | [A-F] | [a-f] ;

//LINE_COMMENT : '//' .*? NEW_LINE -> channel(HIDDEN) ;
LINE_COMMENT
	: '//' ~[\r\n]* -> channel(HIDDEN)
	;

STRING : [a-zA-Z\/_\".]+ ;
NUMBER : [0-9]+ ;

NEW_LINE : '\r'? '\n' -> channel(HIDDEN);
WS: [ \t\n\r]+ -> channel(HIDDEN) ;