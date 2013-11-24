module CyclomaticComplexity

import lang::java::jdt::m3::AST;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core; 
import List;
import Set;
import IO;

import SourceCodeFilter;
import LinesOfCodeCalculator;

public list[tuple[str name, loc location, int complexity, int lofc]] getComplexityPerUnit(set[Declaration] ast, bool scanSrcOnly){
    list[tuple[str name, loc location, int complexity, int lofc]] result = [];
	visit(ast){
		case method(_, str methodName, _, _, Statement impl) : {
			if(scanSrcOnly){
				if(isSrcEntity(impl@src))
					result += <methodName, impl@src, calculateComplexity(impl), calculateLoc(impl@src)>;
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
		case \do(Statement body, _):
			return calculateComplexity(body);
		case \while(_, Statement body):
			return 1 + calculateComplexity(body);
		case  \try(Statement body, list[Statement] catchClauses):
			return calculateComplexity(body) + (0| it + calculateComplexity(s) | s <- catchClauses);	
		case  \try(Statement body, list[Statement] catchClauses, Statement \finally) :
			return calculateComplexity(body) + (0| it + calculateComplexity(s) | s <- catchClauses)
				+ calculateComplexity(\finally);	
		case \catch(Declaration exception, Statement body):
			return calculateComplexity(body);
		default:
			return 0;
	}
}