library(reshape)
source("coef.R")
c<-read.csv("stats/pairs.all.csv",header=F,sep=";")
colnames(c)<-c('ent','comp','book','freq')
cm<-melt(c)
cc<-cast(cm, ent + comp ~ book,fill=0)
ccm<-cbind(paste(cc$ent, cc$comp, sep=' -- '), cc[,3:ncol(cc)])
write.table(ccm, "stats/freq.net.csv", col.names=T, row.names=F,sep=";")
cmm<-melt(c, id=c("ent","book"), measure.vars=c("comp"))
# correct chronological order of columns
o=c('0','ar','gl','be','po','la','vi','vi')
ccn<-cast(cmm, ent ~ book, length)[,order(o)]
ccj<-cast(cmm, ent ~ book, function(x){paste(x[!is.na(x)],collapse=" ")})[,order(o)]
ccn<-within(ccn, df<-round(apply(ccn[,2:ncol(ccn)],1,dx),4))
ccn<-within(ccn, dfa<-round(apply(ccn[,2:ncol(ccn)],1,dxan),4))
#ccn<-within(ccn, dfn<-round(apply(ccn[,2:ncol(ccn)],1,dxn),4))
#ccn<-within(ccn, dff<-round(apply(ccn[,2:ncol(ccn)],1,dxf),4))
write.table(ccn, "stats/freq.comp.csv", col.names=T, row.names=F,sep=";")
write.table(ccj, "stats/companions.csv", col.names=T, row.names=F,sep=";")
cf<-within(c,cf<-paste(comp, freq, sep="_"))
cmmf<-melt(cf, id=c("ent","book"), measure.vars=c("cf"))
ccjf<-cast(cmmf, ent ~ book, function(x){paste(x[!is.na(x)],collapse=" ")})[,order(o)]
write.table(ccjf, "stats/companionsf.csv", col.names=T, row.names=F,sep=";")
