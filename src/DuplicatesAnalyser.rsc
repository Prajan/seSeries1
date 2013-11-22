module DuplicatesAnalyser

import lang::java::jdt::m3::AST;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core; 
import IO;
import List;
import String;
import Set;
import LinesOfCodeCalculator;

public loc HelloWorldLoc = |project://HellowWorld|;
public loc smallsql = |project://smallsql|;

public void analyseMethod(loc project){
	list[list[str]] matched = [];
	list[str] resultTemp = [];
	model = createM3FromEclipseProject(project);

    int finalcnt = 0;
    bool isInComment = false;
	toListmodels = toList(methods(model));
	
	int cntFiles = 0;
		
	for(m <- toListmodels){
		result = getCleanCode(m);
	//	println(" First loop Size <size(toListmodels)>   ");
        if(size(result) < 6){
          cntFiles += 1;
          continue;
        }  
	//	println(" First loop Size <size(toListmodels)>  List of Methods: <toListmodels> ");
		int offset = 6;
		
		for (i  <- [0..size(result)]){
     		for (j  <- [0..size(result)], j - i == offset){
      			 compareFrom = result[i..j];
      			// println(" count <cntFiles> <m>");
      			 // after comparision if there is a match then look at the next line...
      			 int cntdupl = compareDuplication(toListmodels, compareFrom, i , j, offset, cntFiles);
                 finalcnt += cntdupl;
                 //println("Final cnt increment <finalcnt>");
      			 //println("<i> <j> <compareFrom>");   analyseMethod(HelloWorldLoc);  			 
      		}
      	}
    cntFiles += 1;
    }
    println("Final duplicates count <finalcnt> cntFiles <cntFiles>");	
}


public int compareDuplication(toListmodels, list [str] compareFrom, int i , int j, int offset, int cntFiles ){
  int cntDuplicates = 0;
  //model = createM3FromEclipseProject(project);
//  println("Later count of files <cntFiles>");
  fromListModels = drop(cntFiles, toListmodels);
//  println(" Second method Size <size(fromListModels)> CntFiles <cntFiles>");
  for(m <- fromListModels){
    result = getCleanCode(m);
    
    if(size(result) < 6)           
	  continue;
  //  println("Second list <fromListModels>");
    for (x  <- [i+1..size(result)]){
      for (y  <- [j+1..size(result)], y - x == offset){
       compareWith = [];
       if (x > size(result) || y > size(result)) 
         continue;
         
        compareWith = result[x..y];
   //     println("Comparewith <compareWith>");
        if (compareFrom == compareWith){
          println("Hey duplicates i j <i + 1> <j + 1> x y  <x + 1> <y + 1> <compareWith>");
          cntDuplicates += 1;
        }  
      }  
    }
  }
  return cntDuplicates;
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










