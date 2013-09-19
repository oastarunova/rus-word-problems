cuts <- function(x)
{
n <- length(x) %/% 4
map <- rep(c(rep(TRUE,4),FALSE), n)
result <- rep(NA, n*5)
result[map] <- x
result
}

polygon.dyn <- function(mydata, offset, cex)
{
# Retrieving data matrix dimensions
XNUM <- dim(mydata)[2]
YNUM <- dim(mydata)[1]

# Extracting the numeric part of the data matrix
mdn = NULL
for (i in 1:XNUM)
 {
 mdni <- as.numeric(as.character(mydata[2:YNUM,i]))
 mdn <- cbind(mdn, mdni)
 }

# Calculating left and right coords for all possible rectangular polygons
xr <- mdn[,1]+.5
xl <- mdn[,1]-.5
x <- cbind(xl,xr,xr,xl)

# Calculating plot outline parameters
vspace = 0
for (i in 2:(XNUM))
 {
 vsi <- max(mdn[,i], na.rm=T)
 vspace <- c(vspace, vsi)
 }

# Drawing the plot outline
plot(0, xlim=c((min(x)-1-2*offset),max(x)), ylim=c(0,(sum(vspace) + XNUM + 1)), frame=F, yaxt="n", ylab="", xlab="Years")

# Looping the polygons
for (i in 2:XNUM)
 {
 ## Calculating the top and bottom coords for each rectangular polygon
 yt <- ((max(mdn[,i], na.rm=T)+2)+mdn[,i])/2
 yb <- ((max(mdn[,i], na.rm=T)+2)-mdn[,i])/2
 y <- cbind(yb,yb,yt,yt)

 ## Drawing a polygon
 polygon(x=cuts(t(x)), y=(i + sum(vspace[1:i-1]) + cuts(t(y))), col="black")
 }

# Adding labels
## Calculating x coord for text labels
xlab = NULL
for (i in 2:XNUM)
 {
 xraw <- cbind(mdn[,1], mdn[,i])
 xraws <- subset(xraw, xraw[,2] > 0)
 xlab <- rbind(xlab, min(xraws[,1]))
 }

## Calculating y coord for text labels
ylab = NULL
for (i in 2:XNUM)
 {
 ybase <- (max(mdn[,i], na.rm=T)+2)/2
 yraw <- (i + sum(vspace[1:i-1]) + ybase + .5)
 ylab <- rbind(ylab, yraw)
 }

## Putting text labels to the plot
text (xlab[,1]-1-offset, ylab[,1], t(mydata[1,2:XNUM]), pos=1, cex=cex)
}

issues <- read.table("issues.csv", sep=",")
pdf("issues.pdf")
polygon.dyn(issues, 12, 1)
dev.off()
