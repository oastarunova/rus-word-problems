source("coef.R")
freqs<-read.csv("freq.table.csv",sep=";",header=T)
jaccard<-allpairs(freqs)
jaccard<-jaccard[order(jaccard$value, decreasing=T),]
write.csv(jaccard, "jaccard.csv")

dpf<-dp(freqs)
dpf<-dpf[order(dpf$DP, decreasing=T),]
write.csv(dpf, "dp.csv")
write.csv(dpf[which(dpf$freq>2),],"dp3+.csv")
write.csv(dpf[which(dpf$freq>9),],"dp10+.csv")
pdpf<-as.data.frame(prop.table(as.matrix(dpf),2)*100)
write.csv(pdpf, "pdp.csv")
write.csv(pdpf[which(pdpf$freq>2),],"pdp3+.csv")
write.csv(pdpf[which(pdpf$freq>9),],"pdp10+.csv")

