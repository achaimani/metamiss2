
******Examples to illustrate the use of metamiss2******

*** Pairwise meta-analysis, binary data

//Load the data comparing the effectiveness of haloperidol against placebo for the treatment of schizophrenia (Joy, 2006):
use "http://www.mtm.uoi.gr/images/haloperidol.dta", clear

//Assume that the logIMOR in the haloperidol group has mean 0 and SD 1, while the logIMOR in the placebo group has mean -1 and SD 1.  
//This expresses the belief that for placebo the response in missing participants is probably
//worse than in observed participants:
metamiss2 rh fh mh rp fp mp, impmean(0 -1) impsd(1) metanopt(lcols(author))

//Next assume that the logIMORs are positively correlated between the two intervention groups, with correlation rho=0.5:
metamiss2 rh fh mh rp fp mp, impmean(0 -1) impsd(1) impc(0.5) b metanopt(lcols(author))

*** Pairwise meta-analysis, continuous data

//Load the data comparing the effectiveness of mirtazapine versus placebo for major depression (Cipriani, 2009):
use "http://www.mtm.uoi.gr/images/mirtazapine.dta", clear

//Assume a systematic departure from the MAR assumption where for the mirtazapine group IMDOM=-0.5 with sd(IMDOM)=1 and for placebo IMDOM=1 with sd(IMDOM)=1.5. 
//This means that probably placebo performed worse in the missing participants than in the observed, whereas mirtazapine performed worse in the observed participants. 
//Assume also that IMDOMs are correlated between the two groups with rho=0.5 and compare the results with ACA:
metamiss2 nm mm ym sdm np mp yp sdp, impmean(-0.5 1) impsd(1 1.5) impcorr(0.5) compare(impmean(0) impsd(0)) md metanopt(lcols(study))

//Change the IMP parameter and run a sensitivity analysis with IMROM=1 on a range of different values for sd(logIMROM):
metamiss2 nm mm ym sdm np mp yp sdp, md sensitivity b imptype(logimrom)

*** Network meta-analysis

//Load the data that comprise a network of trials comparing the effectiveness of 9 antidepressants (Cipriani, 2009):
use "http://www.mtm.uoi.gr/images/antidepressants.dta", clear

//Prepare the data in the "augmented" format:
network setup y sd n, trt(t) stud(id) nmiss(m)

//Run the ACA:
metamiss2

//Explore the impact of alternative assumptions by incorporating IMPs in the analysis. 
//Consider three groups of treatments with IMDOM=1,-1 or 0 but sd(IMDOM)=1 for all treatments in the network. 
//Also, allow the correlation of IMPs to differ across studies by specifying the full 9x9 correlation matrix:
mat C=J(9,9,0.5)+0.5*I(9)
forvalues i=4/8{
	mat C[`i',`=`i'+1']=0.2
	mat C[`=`i'+1',`i']=0.2
}
mat li C
metamiss2, impmean(1 1 -1 -1 0 1 0 1 -1) impsd(1) impcorr(C) b


