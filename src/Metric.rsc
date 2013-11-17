module Metric

import lang::java::jdt::m3::AST;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
//import analysis::m3::metrics::LOC;
import List;
import IO;
import Set;

import demo::common::Crawl;

public set[Declaration]  CreateAst(){
   ast = createAstsFromEclipseProject (|project://smallsql|, false);
   visit(ast){
//	 case method(_, str name,_,_,_): println(name);
//  case package(_,str sour): println("------------" + sour);
case package(_,str sour): println("------------" + sour);
   }
}

public void countEmtpyLines(){
  int count  = 0;
  for(s <- text)
    if( /^$/ := s)
      n +=1;
  return n;   
}

public void calculateLinesOfCode(){

  lrel[list[int] LOC, str rank, str MY] FP = [<[0..66],"++","0 to 8">, <[66..246],"+","8 to 30">, <[246..665],"o","30 to 80">, <[665..1310],"-","80 to 160">];
  //<[1310..],"--","gr 160">
  
  int countFileLinesTotal = 0;
  int countFileLines = 0;
  int countEmptyLines = 0;
  int countEmptyLinesTotal = 0;
  int countCommentedLines = 0;
  int countCommentedLinesTotal = 0;
  int countImpPackLines = 0;
  int countImpPackLinesTotal = 0;
  int countLines = 0;
  int cnt = 0;
  bool fpFound = true;
  
  project1 = |project://smallsql|;
  project2 = |project://hsqldb231|;
  
  for (files <- sourceFilesForProject(project1)){  
    countFileLines = 0;
    countEmptyLines = 0;  
    countCommentedLines = 0;
    countImpPackLines = 0;
    
    for(s <- readFileLines(files)){
      if( /^$/ := s)
        countEmptyLines += 1;
      if( /\*/ := s)
        countCommentedLines += 1;
      if( /import|package/ := s)
        countImpPackLines += 1;
      }
    countEmptyLinesTotal += countEmptyLines;
 //   println("Empty Lines of Codes <files> <countEmptyLines>");        
    countCommentedLinesTotal += countCommentedLines;
//    println("Empty Lines of Codes <files> <countCommentedLines>");
    countImpPackLinesTotal += countImpPackLines;
//    println("Empty Lines of Codes <files> <countImpPackLines>");
    
    countFileLinesTotal += size(readFileLines(files));
    countFileLines += size(readFileLines(files));
 //   println("LOC in <files>  <perFileLines>");
    
  }
  countLines = countFileLinesTotal - countEmptyLinesTotal - countCommentedLinesTotal - countImpPackLinesTotal;
  for (x <- FP.LOC){
    if (12 in x ){  //countLines/1000
      println("Rank is <FP.rank[cnt]> \nMan Years is <FP.MY[cnt]>");
      fpFound = false;
    }
   cnt +=1;
   
 
   }
  if (fpFound) 
      println("Rank is -- \nMan Years is greater 160");
  println("Total LOC in project <countFileLinesTotal>");
  println("Total empty lines in project <countEmptyLinesTotal>");
  println("Total commented lines in project <countCommentedLinesTotal>");
  println("Total import/package lines in project <countImpPackLinesTotal>");
  println("Total empty lines in project without empty lines <countLines>");
  
}

// Calculating LOC using rascal reducer expression
public void calculateLinesOfCodeUsingCrawl(){
//  allFile = sourceFilesForProject(|project://smallsql/|);
//  perFileLines = (0 | it + size(readFileLines(f)) | loc f <- allFile);
//  println("print file <perFileLines>");

  int totalFileLines = 0;
  int perFileLines = 0;
  for (rfiles <- sourceFilesForProject(|project://smallsql/|)){  
    perFileLines = 0;
    totalFileLines += (0 | it + size(readFileLines(f)) | loc f <- toList({rfiles}));  // creating set by introducing curly braces then converting it to list.
    perFileLines += (0 | it + size(readFileLines(f)) | loc f <- toList({rfiles}));
    println("LOC in <rfiles>  <perFileLines>");
  }
  println("Total LOC in project <totalFileLines>");



}




public void calculateGeneral(){
   myModel = createM3FromEclipseProject(|project://smallsql|);
   myMethods = methods(myModel);
   println("Total number of Methods : <size(myMethods)>");
  /* int totalMethods = 0;
   for(e <- myMethods){
     totalMethods += 1;
   } println("<totalMethods>");
   */
}


public void findCodeDuplication(){
 A = readFileLines(|project://smallsql/src/smallsql/database/CreateFile.java|);
 //println("<A[0..5]> ..  <size(A)>");
 int i = 0 , j = 0 , m = 0, n= 0;
 for (i, m <- [0..size(A)]){
   for (j,n <- [5..size(A)]){
     if (i == m)  m += 1; 
     if (j == n)  n += 1;
    //println("this <slice(A, i, 6)>");  
    
    // println("<A[i..j] == A[m..n]>");
   println("<i>  <j> .... <m>   <n>");
   }
 }
 
 
 
 
 // for (e <- sourceFilesForProject(|project://smallsql/|)){
 // line0to6 = readFileLines(e);
 // println("<line0to6[0..5]>");
//  }
}


/*
q = {1,2,3};
for (e <- q){
  println("<e>");
};

v = {|ptoject://smallsql/src/smallsql/database/a.java|,|project://smallsql/src/smallsql/database/2.java|,|project://smallsql/src/smallsql/database/Column.java|};
for (e <- v){
  println("<v>");
};


readFileLines(|project://smallsql/src/smallsql/database/Column.java|);
 size(readFileLines(|project://smallsql/src/smallsql/database/Column.java|));
*/


 public void printTotalNmbOfMethods(){
    println("project smallsql has got a total of <totalMethods()> methods.");    
 }
 
 public int totalMethods() = size([e | e <- createM3FromEclipseProject(|project://smallsql|)@containment, /java\+method+/ := e.from.scheme]);
 	
 public int countTotalLoc(){
 	return countProjectTotalLoc(createM3FromEclipseProject(|project://smallsql|));
 }
 
 public int totalLines(){
    int lines = 0;
 for(e <- createM3FromEclipseProject(|project://smallsql|)){
    lines += size(readFile(e.from));
 }
 return lines;
 
 }
 

public int count(){
text = readFileLines(|project://smallsql/src/smallsql/database/StoreNoCurrentRow.java|);
  n = 0;
  for(s <- text)
    if(  /\*/  := s) { // for white space {
    println("<s>");      
      n +=1;
      }

  return n;
}
 
 
 public void  check(){
 
//lrel[str LOC, str rank, str MY] FP = [<"0..66","++","0 to 8">, <"66..246","+","8 to 30">, <"246..665","o","30 to 80">, <"665..1310","-","80 to 160">, <"1310..","--","gr 160">];

 //FP = [[[0..66],"++","0 to 8"], [[66..246],"+","8 to 30"], [[246..665],"o","30 to 80"], [[665..1310],"-","80 to 160"], [[1310..1313],"--","gr 160"]];

FP = [[[0..66],"++","0 to 8"], [[66..246],"+","8 to 30"]];
lrel[list[int] pra, str rank, str MY] SFP = [<[0..66],"++","0 to 8">, <[66..246],"+","8 to 30">, <[68..246],"+","8 to 30">, <[2466..270],"+","8 to 30">];
   int cnt = 0;
   for (x <- SFP.pra){
       if (67 in x){
         println(" <2 in x> <SFP.rank[cnt] > <cnt>");
         
         }  
cnt +=1;
   }
     
   
   /*  if (x < 250)
       result +=x;
       println("<last(result)>");
       
       return result ; */ 
   
 }
 
 
 
 