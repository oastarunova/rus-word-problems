source("coef.R")
args <- commandArgs(trailingOnly = TRUE)
setwd(args[1])
prefix = args[2]
print(args)
fs<-list.files(".",pattern=paste(prefix, ".*.csv", sep=""))
print(fs)

for (f in fs) {
    freqs<-read.csv(f,sep=";",header=T)
    freqs <-freqs[order(rowSums(freqs[2:ncol(freqs)]),decreasing=T),]
    jaccard<-allpairs(freqs)
    jaccard<-jaccard[order(jaccard$value, decreasing=T),]
    write.csv(jaccard, sub(prefix, "jaccard", f))
    dpf<-dp(freqs)
    dpf<-dpf[order(dpf$DP, decreasing=T),]
    write.csv(dpf, sub(prefix,"dp",f))
    write.csv(dpf[which(dpf$freq>2),],sub(prefix,"dp3+",f))
    write.csv(dpf[which(dpf$freq>9),],sub(prefix,"dp10+",f))
    pdpf<-as.data.frame(prop.table(as.matrix(dpf),2)*100)
    write.csv(pdpf, sub(prefix,"pdp",f))
    write.csv(pdpf[which(pdpf$freq>2),],sub(prefix,"pdp3+",f))
    write.csv(pdpf[which(pdpf$freq>9),],sub(prefix,"pdp10+",f))
}

