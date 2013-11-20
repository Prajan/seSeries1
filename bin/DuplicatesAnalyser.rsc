module DuplicatesAnalyser

import lang::java::jdt::m3::AST;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core; 
import IO;
import List;
import String;
import LinesOfCodeCalculator;

public loc HelloWorldLoc = |project://HelloWorld|;

public void analyseMethod(loc project){
	list[list[str]] matched = [];
	list[str] resultTemp = [];
	model = createM3FromEclipseProject(project);
	
	bool isInComment = false;
	for(m <- methods(model)){
        if(calculateLoc(m) < 6)           
			continue;
		//println(size(result));
		//println(result);
		
		int offset = 6;
		for (i  <- [0..size(result)]){
     		for (j  <- [0..size(result)], j - i == offset){
      			 compareFrom = result[i..j];
      			 // after comparision if there is a match then look at the next line...
      			 
      			 println("<i> <j> <compareFrom>");  			 
      		}
      	}
    }	
}