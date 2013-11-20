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

public list[tuple[str name, loc location, int complexity, int lofc]] getComplexityPerUnit(set[Declaration] ast){
    list[tuple[str name, loc location, int complexity, int lofc]] result = [];
    int index;
	visit(ast){
	    case class(str name, _, _, list[Declaration] body) :{
	        index = 0;
	    	visit(body){
				case method(_, str methodName, _, _, Statement impl) : {
					result += <methodName, body[index]@src, calculateComplexity(impl), calculateLoc(body[index]@src)>;
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
		case \if(_, Statement thenBranch):
			return 1 + calculateComplexity(thenBranch);
		case \if(_, Statement thenBranch, Statement elseBranch):
			return 2 + calculateComplexity(thenBranch) + calculateComplexity(elseBranch);			
		case \switch(_, list[Statement] statements): 			
			return 1 + (0| it + calculateComplexity(s) | s <- statements);
		case \case(_):
			return 1;
		case \foreach(_, _, Statement body):
			return 1 + calculateComplexity(body);	
		case \for(_, _, Statement body):
			return 1 + calculateComplexity(body);
		case \for(_, _, _, Statement body):
			return 1 + calculateComplexity(body);
		case \while(_, Statement body):
			return 1 + calculateComplexity(body);
		case \throw(_):
			return 1;
		default:
			return 0;
	}
}