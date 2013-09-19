source("coef.R")
setwd("stats")
fs<-list.files(".",pattern="freq.*.csv")
write(fs, stderr())

for (f in fs) {
    freqs<-read.csv(f,sep=";",header=T)
    freqs <-freqs[order(rowSums(freqs[2:ncol(freqs)]),decreasing=T),]
    jaccard<-allpairs(freqs)
    jaccard<-jaccard[order(jaccard$value, decreasing=T),]
    write.csv(jaccard, sub("freq", "jaccard", f))
    dpf<-dp(freqs)
    dpf<-dpf[order(dpf$DP, decreasing=T),]
    write.csv(dpf, sub("freq","dp",f))
    write.csv(dpf[which(dpf$freq>2),],sub("freq","dp3+",f))
    write.csv(dpf[which(dpf$freq>9),],sub("freq","dp10+",f))
    pdpf<-as.data.frame(prop.table(as.matrix(dpf),2)*100)
    write.csv(pdpf, sub("freq","pdp",f))
    write.csv(pdpf[which(pdpf$freq>2),],sub("freq","pdp3+",f))
    write.csv(pdpf[which(pdpf$freq>9),],sub("freq","pdp10+",f))
}

