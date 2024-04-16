W<-seq(0,500,5)
U<- function(W,r) {
  1-exp(-W/r)
}
r<-c(100,350,800)  #The risk tolerance. The higher the less risk averse.
par(mai=c(0.85,0.85,0.4,0.4))  #Set Margins
plot(W,U(W,r[1]),type='l',lwd=1, main="Exponential Utility",xlab="Wealth",
     ylab="Utility", axes=FALSE)
axis(side=1, labels=TRUE, at=seq(0,500,by=50),font=1)
axis(side=2, labels=TRUE, at=seq(0,1,by=0.2),font=1,las=1)
lines(W,U(W,r[2]),type='l',col="blue")
lines(W,U(W,r[3]),type='l',col="darkgreen")
legend(320,0.25,legend=c("r=100 (Most RA)", "r=350","r=800 (Less RA)"),
       col=c("black","blue", "darkgreen"), lty=1, cex=0.8)

