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
public int calculateDublicates(set[loc] projectFiles){
	int count = 0;
	int dupThreshold = 6;
	int tempDupThreshold = 0;	
	int searchSourceLoc = 0;	
	list[str] searchSource = [];
	list[str] searchPattern = [];
	list[str] searchList = [];
	list[str] duplicates = [];
	list[tuple[list[str], list[loc]]] foundDuplicates = [];
	
	int totalFiles = size(projectFiles);
	for(f <- [0..totalFiles]){
		searchSource = getCleanCode(projectFiles[f]);
		searchSourceLoc = size(searchSource);
		if(searchSourceLoc < dupThreshold)           
			continue;		
		bool keepSearching = false;		
		for(i <- [0..searchSourceLoc]){	
			tempDupThreshold = dupThreshold;
			keepSearching = true;			
			while(keepSearching){			
				searchPattern = searchSource[i..tempDupThreshold];
				searchList = searchSource[i..tempDupThreshold];
				if(searchPattern := searchList){
      				 duplicates = searchPattern;
      				 tempDupThreshold += 1;
      			}
      		}
		}
		tempDupThreshold = dupThreshold;			
	}	
	return 0;
}















