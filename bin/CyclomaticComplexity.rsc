module CyclomaticComplexity

import lang::java::jdt::m3::AST;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core; 
import List;
import Set;
import IO;
import Type;

public set[Declaration] smallsqlAst = createAstsFromEclipseProject (|project://smallsql|, false);
public set[Declaration] helloWorldAst = createAstsFromEclipseProject (|project://HelloWorld|, false);

public void reportCyclomaticComplexity(set[Declaration] ast){
	int lowRisk = 0;
	int modRisk = 0;
	int highRisk = 0;
	int veryHighRisk = 0;
	
	for(cc <- getComplexityPerUnit(ast)){
		if(cc.complexity <= 10) { lowRisk += 1; continue; }
		if(cc.complexity > 10 && cc.complexity <= 20) { modRisk += 1; continue; }
		if(cc.complexity > 20 && cc.complexity <= 50) { highRisk += 1; continue; }
		veryHighRisk += 1;
	}
	
	println("Methods Risk evaluation:
	'	Amount of methods with low risk: <lowRisk>
	'	Amount of methods with moderate risk: <modRisk>
	'	Amount of methods with high risk: <highRisk>
	'	Amount of methods with very high risk: <veryHighRisk>");
}

public list[tuple[str name, int complexity, loc location]] getComplexityPerUnit(set[Declaration] ast){
    list[tuple[str name, int complexity, loc location]] result = [];
	visit(ast){
		case method(_, str name, _, _, Statement impl) : {
			visit(impl) {
				case \block(_): result += <name, calculateComplexity(impl), impl@src>;
			}	
		 }  
	}
	return result;
}

public int calculateComplexity(Statement stat){
	switch(stat){		
		case \block(list[Statement] statements):
			return (0| it + calculateComplexity(s) | s <- statements);			
		case \if(Expression condition, Statement thenBranch):
			return 1 + calculateComplexity(thenBranch);
		case \if(Expression condition, Statement thenBranch, Statement elseBranch):
			return 2 + calculateComplexity(thenBranch) + calculateComplexity(elseBranch);			
		case \switch(Expression expression, list[Statement] statements): 			
			return 1 + (0| it + calculateComplexity(s) | s <- statements);
		case \case(Expression expression):
			return 1;
		case \foreach(Declaration parameter, Expression collection, Statement body):
			return 1 + calculateComplexity(body);	
		case \for(list[Expression] initializers, list[Expression] updaters, Statement body):
			return 1 + calculateComplexity(body);
		case \for(list[Expression] initializers, Expression condition, list[Expression] updaters, Statement body):
			return 1 + calculateComplexity(body);
		case \while(Expression condition, Statement body):
			return 1 + calculateComplexity(body);
		default:
			return 0;
	}
}

// sum of complexity of all the methods in the AST
public int calcTotalComplexity(set[Declaration] ast){
	int complexity = 0;
	visit(ast){
		case method(_, _, _, _, Statement impl) : complexity += calculateComplexity(impl);
   	}
	return complexity;
}
   
   
   
   
   
   
   
   
   