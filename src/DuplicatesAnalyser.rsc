module DuplicatesAnalyser

import lang::java::jdt::m3::AST;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core; 
import IO;
import LinesOfCodeCalculator;

public loc HelloWorldLoc = |project://HelloWorld|;

public list[str] analyseMethod(loc project){
	list[list[str]] matched = [];
	
	model = createM3FromEclipseProject(project);
	
	bool isInComment = false;
	 for(l <- readFileLines(methods)){   
    	if(/^\s*$/ := l || /^$/ := l || /\/\// := l )
       		continue;
       	if(/\/\*/ := l) {
       		if(/\*\// := l)
       			continue;       			
       		else{
       			isInComment = true;
       			continue;
       		}
       	}       	       	
       	if(/\*\// := l) {
       		isInComment = false;
       		continue;
       	}
       	if(isInComment)
       		continue;
       append l; 	
    } 
    return result;
	
	//return methods(model);
	
	
}