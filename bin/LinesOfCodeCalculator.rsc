module LinesOfCodeCalculator

import IO;
import List;
import String;
import lang::java::jdt::m3::Core;

public loc HelloWorldLoc = |project://HelloWorld|;
public loc smallsqlLoc = |project://smallsql|;

public int calculateProjectLoc(set[loc] projectFiles){
	int totalLoc = 0;
	for(f <- projectFiles)
		totalLoc += calculateLoc(f);
	return totalLoc;
}

public int calculateLoc(loc location){
	return size(getCleanCode(location));
}

public list[str] getCleanCode(loc location){
	bool isInComment = false;
	list[str] cleanCode = [];
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
       	trim(l);
       	cleanCode += l;
    }
    return cleanCode;
 }
