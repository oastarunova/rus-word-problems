clujaccard <- function(x, y) {
    lx <- x>0
    ly <- y>0
    return(sum(lx & ly)/(sum(lx)+sum(ly)))
}

seqpairs <- function (x, FUN=clujaccard) {
    out <- data.frame(from=NA, to=NA, value=NA)
    for (i in 3:ncol(x)) {
        out[(i-2),] <- c( colnames(x[,(i-1):i]), FUN(x[,(i-1)], x[,i]))
    }
    return(out)
}

allpairs <- function (x, FUN=clujaccard) {
    out <- data.frame(from=NA, to=NA, value=NA)
    afun <- function(y) { c(colnames(y), FUN(y[,1], y[,2])) }
    z <- combn(x[,2:ncol(x)],2,simplify=FALSE,FUN=afun)
    for (i in 1:length(z)) {
        out[i,] <- c(colnames(z), z[[i]])
    }
    return(out)
}

commons <- function(x, y) {
    return(paste(intersect(unique(x), unique(y)), collapse=" "))
}

dprow <- function(x,e){ sum(abs(x-e))/2}

dp <- function(x) {
    z <- data.frame(x[,2:ncol(x)])
    rownames(z) <- x[,1]
    csums <- colSums(z)
    rsums <- rowSums(z)
    eprops <- csums/sum(csums)
    xprops <- z/rsums
    out <- as.data.frame(apply(xprops, 1, dprow, eprops))
    out <- cbind(out, rsums, z)
    colnames(out) <- c("DP", "freq", colnames(z))
    return(out)
}
