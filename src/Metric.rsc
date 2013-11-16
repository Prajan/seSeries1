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
  A = ["1","","b","c","","a"];
  bool isEmptyinList(str s) = s == "a";
  println("<isEmptyinList>");
   
}

public void calculateLinesOfCode(){
//  println (sourceFilesForProject(|project://smallsql/|));
  int totalFileLines = 0;
  int perFileLines = 0;
  for (files <- sourceFilesForProject(|project://smallsql/|)){  
    perFileLines = 0;
    totalFileLines += size(readFileLines(files));
    perFileLines += size(readFileLines(files));
    println("LOC in <files>  <perFileLines>");
  }
  println("Total LOC in project <totalFileLines>");
  
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
text = ["andra", "moi", "ennepe","", "Mousa", "","","polutropon"];
  n = 0;
  for(s <- text)
    if( /^$/ := s)
      n +=1;
  return n;
}
 
 
 
 