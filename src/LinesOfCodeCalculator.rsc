module LinesOfCodeCalculator

import IO;
import lang::java::jdt::m3::Core;

public int calculateProjectLoc(loc project){
	model = createM3FromEclipseProject(project);
	units = methods(model);	
	int totalLoc = 0;
	for(u <- units)
		totalLoc += calculateUnitLoc(u);
	return totalLoc;
}

public int calculateUnitLoc(loc location){
    int linesCount = 0;	 
	bool isInComment = false;
    for(l <- readFileLines(location)){
    	if(/^\s*$/ := l || /^$/ := l || /\/\// := l || /import|package/ := l || isInComment)
       		continue;        		
       	if(/\/\*/ := l){
       		isInComment = true;
       		continue;
       	}        	
       	if(/\*\// := l) {
       		isInComment = false;
       		continue;
       	}
       	linesCount += 1;        	
    } 
    return linesCount;
}