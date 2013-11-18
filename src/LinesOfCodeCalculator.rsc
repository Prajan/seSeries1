module LinesOfCodeCalculator

import IO;
import lang::java::jdt::m3::Core;

public loc HelloWorldLoc = |project://HelloWorld|;
public loc smallsqlLoc = |project://smallsql|;

public int calculateProjectLoc(loc project){	
	int totalLoc = 0;
	for(u <- sourceFilesForProject(project))
		totalLoc += calculateUnitLoc(u);
	return totalLoc;
}

public int calculateUnitLoc(loc location){
    int linesCount = 0;	 
	bool isInComment = false;
    for(l <- readFileLines(location)){   
    	if(/^\s*$/ := l || /^$/ := l || /\/\// := l || /import|package/ := l)
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
       	linesCount += 1;        	
    } 
    return linesCount;
}