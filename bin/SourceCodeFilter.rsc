module SourceCodeFilter

import IO;
import List;
import String;

import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core; 
import lang::java::m3::Core;


public set[loc] getSrcFiles(M3 model){
	 return {f | f <- files(model), isSrcEntity(f)};
}

public set[loc] getSrcMethods(set[loc] sourceFiles){
	set[loc] sourceMethods= {};	 
	for(f <- sourceFiles)
		sourceMethods += methods(createM3FromFile(f));
	return sourceMethods;
}


public bool isSrcEntity(loc entity) = 
	contains(entity.path, "/src/") && !contains(entity.path, "/generated/")
	&& !contains(entity.path, "/sample/") && !contains(entity.path, "/samples/")
	&& !contains(entity.path, "/test/") && !contains(entity.path, "/tests/") 
	&& !contains(entity.path, "/junit/") && !contains(entity.path, "/junits/");

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
       	cleanCode += trim(l);
    }
    return cleanCode;
 }