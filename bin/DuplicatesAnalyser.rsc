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
		result = getCleanCode(m);
        if(size(result) < 6)           
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

//this is not completed yet!!!!
public int calculateDublicates(set[loc] projectFiles, int minDuplicate){	
	int searchSourceLoc = 0;	
	list[str] searchSource = [];	
	int searchBeginIndex = 0;	
	list[str] duplicates = [];
	list[tuple[list[str] code, list[loc] location]] foundDuplicates = [];
	
	int totalFiles = size(projectFiles);
	for(f <- [0..totalFiles]){
		searchSource = getCleanCode(projectFiles[f]);
		searchSourceLoc = size(searchSource);
		if(searchSourceLoc < minDuplicate)           
			continue;
			
		bool searchingInThisFile = searchSourceLoc / minDuplicate >= 2 ? true :  false;	
		// search in the current file first
		while(searchingInThisFile){			
		    	duplicates = getDuplicates(searchSource, searchBeginIndex, minDuplicate);
		    	if(isEmpty(duplicates))
		    		searchBeginIndex += 1;
		    	else{
		    		searchBeginIndex = 0;
		    		searchingInThisFile = false;	
		    	}	    
		}
		      	
      	if(!isEmpty(duplicates)){
      		if (size([d | d <- foundDuplicates, d.code == duplicates, d.location == f ]) == 0){
      			foundDuplicates += <duplicates, f>;
      		}
      	}	
      	
      	// here start search in other files	
	}	
	return 0;
}

public list[str] getDuplicates(list[str] source, int searchFrom, int searchTo){
    list[str] duplicates = [];
    int fromIndex = searchFrom;
    int toIndex = searchTo;
    int matchFromIndex = searchTo;
    int matchEndIndex = (2 * (searchTo - searchFrom));
	while(true){
		if(matchEndIndex >= size(source)){
				break;
			}			
		searchPattern = source[searchFrom..searchTo];  
		searchList = source[searchTo..matchEndIndex];			
		if([a*,searchPattern, b*, searchPattern, c*] := source){
			duplicates = searchPattern;		
     		searchTo += 1;
      		matchEndIndex += 1; 
      	}
      	else
      	  break;     		
	}	
	return duplicates;
	
   
}


//["a","b","c","d","a","b","c","f"]

//getDuplicates(["a","b","c","d","a","b","c","f","a","b","c","d"], 3, 4);










