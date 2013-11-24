module DuplicatesAnalyser

import lang::java::jdt::m3::AST;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core; 
import IO;
import List;
import String;
import Set;
import LinesOfCodeCalculator;
import DateTime;

public loc HelloWorldLoc = |project://HellowWorld|;
public loc smallsql = |project://smallsql|;
public loc hsqldb231 = |project://hsqldb231|;

public void analyseMethod(loc project){
    list[list[str] resultReadFile] finalResult = [[]];
    int finalcnt = 0;
    bool isInComment = false;
    int cntFiles = 0;
    int offset = 6;
    
    model = createM3FromEclipseProject(project);	
    toListmodels = toList(methods(model));
    println("Starting time <now()>");		
    
    for(t <- toListmodels){
	  result = getCleanCode(t);
      if(size(result) < offset)
        continue;
      finalResult += [result];
	}
	
	for(m <- finalResult){
	int blocksize = 0;
      for (i  <- [0..size(m)]){
        for (j  <- [0..size(m)], j - i == offset){
      	  compareFrom = m[i..j];
  ////    	  println("compareFrom <compareFrom>");
          int cntdupl = compareDuplication(finalResult, compareFrom, i , j, offset, cntFiles);
          finalcnt += cntdupl;
      	}
      }
      cntFiles += 1;
    }
    println("Final duplicates count <finalcnt> cntFiles <cntFiles>");
    println("Ending time <now()>");	
}

public int compareDuplication(finalResult, list [str] compareFrom, int i , int j, int offset, int cntFiles ){
  int cntDuplicates = 0;
  fromListModels = drop(cntFiles, finalResult);
  //println("Print me <fromListModels>");
  i +=1;
  for(n <- fromListModels){
 // println("fromListModels <n>");
    for (x  <- [i..size(n)]){
    //println("x <x>  size(n)  <size(n)>");
      if (size(n) - x <= 6) 
        continue;
      compareWith = slice(n, x, offset);
      
      if (compareFrom == compareWith){
          println("Hey duplicates x <x>  <compareWith>");
          cntDuplicates += 1;
      }
    } i = 0;
  }
  return cntDuplicates;
}



public void test1(){
A = [["public static void main(String[] args) {","System.out.println(\"aaHello, Worlsafasdfd AFAS\");","System.out.println(\"aaHello, Worlsafasdfd AFAS\");","System.out.println(\"aaHello, Worlsafasdfd AFAS\");","int a ;","int b;","int c;","int d;","int e;","int f;","int g;","int i;","int a ;","int b;","int c;","int d;","int e;","int f;","int g;","int i;","}"],["int initAutoIncrement(FileChannel raFile, long filePos) throws IOException{","if(identity){","counter = new Identity(raFile, filePos);","defaultValue = new ExpressionValue( counter, SQLTokenizer.BIGINT );","}","return 8;","}"],["int getScale(){","switch(dataType){","case SQLTokenizer.DECIMAL:","case SQLTokenizer.NUMERIC:","return scale;","default:","return Expression.getScale(dataType);","}","}"]];


for (t <- A){
println("t <t>");
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





public void test1(){
a = 1;
n = 6;
for (i <- [a..n]){
  a = a + 2;
  println ("i <i> a <a>");
}

}




