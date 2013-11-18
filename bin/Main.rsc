module Main

import lang::java::jdt::m3::AST;
import lang::java::jdt::m3::Core; 
import lang::java::m3::Core;
import util::Math;
import Number;
import List;
import IO;


import LinesOfCodeCalculator;
import CyclomaticComplexity;
import Ranking;

public loc HelloWorldLoc = |project://HelloWorld|;
public loc smallsqlLoc = |project://smallsql|; 

public void startAnalysis(loc project){
	println("Analysis started. Please wait..");
	reportProjectMetrics(project);

}

public void reportProjectMetrics(loc project){
	
	int totalLoc = calculateProjectLoc(project);
	ast = createAstsFromEclipseProject(project, false);
	
	println("========================= Begin report ======================================");
	println("");
	// report on lines of code
	locRanking = determineLocRanking(totalLoc);
	println("Analysis of function point by lines of code:");
	println("	The system has got a total size of <totalLoc> lines of code.
			'	This gives a ranking of \'<locRanking.rank>\' which indicates that the man years is <locRanking.mYears>.");
	
	println("");
	println("");
	// report on CC
	int lowRiskLoc = 0;
	int modRiskLoc = 0;
	int highRiskLoc = 0;
	int veryHighRiskLoc = 0;
	
	for(cc <- getComplexityPerUnit(ast)){
		if(cc.complexity <= 10) { lowRiskLoc += cc.lofc; continue; }
		if(cc.complexity > 10 && cc.complexity <= 20) { modRiskLoc += cc.lofc; continue; }
		if(cc.complexity > 20 && cc.complexity <= 50) { highRiskLoc += cc.lofc; continue; }
		veryHighRiskLoc += cc.lofc;
	}
	
	int lowRiskRatio = round((toReal(lowRiskLoc) / totalLoc) * 100);
	int modRiskRatio = round((toReal(modRiskLoc) / totalLoc) * 100);
	int highRiskRatio = round((toReal(highRiskLoc) / totalLoc) * 100);
	int veryHighRiskRatio = round((toReal(veryHighRiskLoc) / totalLoc) * 100);
	
	println("Analysis of complexity:
	'	Percentage of low risk:		<lowRiskRatio>%
	'	Percentage of moderate risk:	<modRiskRatio>%
	'	Percentage of high risk:	<highRiskRatio>%
	'	Percentage of very high risk:	<veryHighRiskRatio>%
	'	This gives the project a \'<determineCyclComRanking(lowRiskRatio, modRiskRatio, highRiskRatio, veryHighRiskRatio)>\' for Cyclomatic Complexity.");
	
	println("");
	println("========================== End report ======================================");
}

