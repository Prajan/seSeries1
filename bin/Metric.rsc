module Metric

import lang::java::jdt::m3::AST;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
//import analysis::m3::metrics::LOC;
import List;
import IO;
import Set;
import String;

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
  project3 = |project://HelloWorld|;
  
  for (files <- sourceFilesForProject(project3)){  
    countFileLines = 0;
    countEmptyLines = 0;  
    countCommentedLines = 0;
    countImpPackLines = 0;
    isIncomment = false;
    
    for(s <- readFileLines(files)){
      if( /^$/ := s  ||  /^\s*$/ := s)
        countEmptyLines += 1;
      
      
      if( /\/\// := s) isIncomment = true;
      if(/\/\*/ := s) {
        if(/\*\// := s)
       	  continue;
       	else{
       	  isInComment = true;
       	  continue;
       	}
      }
      if(/\*\// := s) {
        isInComment = true;
       	continue;
      }
      if (isIncomment){
        countCommentedLines += 1; 
        isIncomment = false;
      }
      
        
        
   //   if( /\*/ := s)
   //     countCommentedLines += 1;
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
    if (countLines/1000 in x ){  //countLines/1000
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
  println("Total real LOC <countLines>");
  
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
 list[str] compareFrom;
 int cntDuplicates = 0;
 int finalcnt = 0;
 for (rfiles <- sourceFilesForProject(|project://smallsql/|)){
 //  println("rfiles <rfiles>"); 
   A = trimSpaceEmptyImport(readFileLines(rfiles));
  // A = trimSpaceEmptyImport(readFileLines(|project://smallsql/src/smallsql/database/CreateFile.java|));
   for (i  <- [0..size(A)]){
     for (j  <- [0..size(A)], j - i == 6){
       compareFrom = A[i..j];
  //    println("Comapre From <compareFrom>");
       int cntdupl = compareDuplication(compareFrom, i , j );
       finalcnt += cntdupl;
     }
   }
 }  
println("Final duplicates count <finalcnt>");  
}

public int compareDuplication(list [str] compareFrom, int i , int j ){
  int cntDuplicates = 0;
  for (rfiles <- sourceFilesForProject(|project://smallsql/|)){
    B = trimSpaceEmptyImport(readFileLines(rfiles));
 // B = trimSpaceEmptyImport(readFileLines(|project://smallsql/src/smallsql/database/CreateFile.java|));
 //   println("i   <i + 1>       J  <j + 1>");
    for (m  <- [i+1..size(B)]){
      for (n  <- [j+1..size(B)], n - m == 6){
       // println("m <m> n <n>   <B[m..n]>");
       if (m > size(B) || n > size(B)) 
         continue;
        compareWith = B[m..n];
        if (compareFrom == compareWith){
          println("Hey duplicates i j <i + 1> <j + 1> m n  <m + 1> <n + 1> <compareWith>");
          cntDuplicates += 1;
        }  
      }  
    }
  }
  return cntDuplicates;
}

public list[str] trimSpaceEmptyImport(temp ){
  result = [];
  for(t <- temp)
    if ( (!/^$/ := t) && ( !/import|package/ := t) ) result += trim(t);
  return result;
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
 

 
 
 public  void test1 (){
  B = [1,2,3,4];
  G = B;
  int x = 0;

  for (i <- B){
  
  println("cnt x <x>");
  
  println(drop(x, G));
  x += 1; 
  
    
  
  
  }




 }
 

 
 