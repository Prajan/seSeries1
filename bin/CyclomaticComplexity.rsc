module CyclomaticComplexity

import lang::java::jdt::m3::AST;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core; 
import List;
import Set;
import IO;

import LinesOfCodeCalculator;

public loc HelloWorldLoc = |project://HelloWorld|;
public loc smallsqlLoc = |project://smallsql|;

public set[Declaration] helloWorldAst = createAstsFromEclipseProject (HelloWorldLoc, false);
public set[Declaration] smallsqlAst = createAstsFromEclipseProject (smallsqlLoc, false);

public void reportProjectCyclComplexity(set[Declaration] ast){
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

public list[tuple[str name, loc location, int complexity, int lofc]] getComplexityPerUnit(set[Declaration] ast){
    list[tuple[str name, loc location, int complexity, int lofc]] result = [];
    int index;
	visit(ast){
	    case class(str name, _, _, list[Declaration] body) :{
	        index = 0;
	    	visit(body){
				case method(_, str methodName, _, _, Statement impl) : {
					result += <methodName, body[index]@src, calculateComplexity(impl), calculateUnitLoc(body[index]@src)>;
					if(index >= size(body) -1)
						index = 0;
					else
						index += 1;
				}
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