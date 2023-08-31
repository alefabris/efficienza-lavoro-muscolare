# Dataset: muscle1.dat
# 
# Source: M. Greenwood (1918). "On the Efficiency of Muscular Work,"
# Proceedings of the Royal Society of London, Series B, Containing Papers
# of a Biological Character, Vol.90, #627, pp.199-214
# (Originally from Glazebrook and Dye, vol.87, p.96 (1914))
# 
# Description: Measurements of Heat Production (calories) at various
# Body Masses (kgs) and Work levels (Calories/hour) on a stationary bike.
# 
# Models Considered:
#   (i)   E(H)=a0+a1*M+a2*W
#   (ii)  E(H)=b0+b1*M+(W/(b3+b4*M))
# 
# Variables/Columns
# Body Mass  
# Work Level 
# Heat Output   

# packages
library(ggplot2)
library(gridExtra)
library(GGally)
# library(drc)
# library(nlme)

# global variables
ALPHA = 0.05 # livello di significatività fissato

# load data
data = matrix(c(43.7,      19,     177,
                43.7,      43,     279,
                43.7,      56,     346,
                54.6,      13,     160,
                54.6,      19,     193,
                54.6,      43,     280,
                54.6,      56,     335,
                55.7,      13,     169,
                55.7,      26,     212,
                55.7,    34.5,     244,
                55.7,      43,     285,
                58.8,      13,     181,
                58.8,      43,     298,
                60.5,      19,     212,
                60.5,      43,     317,
                60.5,      56,     347,
                61.9,      13,     186,
                61.9,      19,     216,
                61.9,    34.5,     265,
                61.9,      43,     306,
                61.9,      56,     348,
                66.7,      13,     209,
                66.7,      43,     324,
                66.7,      56,     352),
              byrow=T, ncol=3)

muscle1 = data.frame(data)
colnames(muscle1) = c("body_mass","work_level","heat_output")

# ANALISI UNIVARIATA

# body mass
summary(muscle1$body_mass)
sd(muscle1$body_mass) # standard deviation
IQR(muscle1$body_mass) # interquartile range

plot1 = ggplot(muscle1, aes(1,body_mass)) +
  stat_boxplot(geom="errorbar", width=0.7) +
  geom_boxplot() +
  geom_jitter(width=0.5, color="blue", alpha=0.5, size=3) +
  theme(axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
  labs(x="", y="Body Mass")

plot2 = ggplot(muscle1, aes(body_mass)) + 
  geom_histogram(aes(y=..density..), colour=1, fill="white", bins=6) +
  geom_density(color="blue", fill="blue", alpha=0.2) +
  labs(x="Body Mass", y="Density")

plot3 = ggplot(muscle1, aes(sample=body_mass)) +
  stat_qq(size=2, fill="white", shape=21) +
  stat_qq_line(color="blue") +
  labs(x="Theoretical Quantiles", y="Sample Quantiles")

grid.arrange(plot1, plot2, plot3, ncol=3)

shapiro.test(muscle1$body_mass)
shapiro.test(muscle1$body_mass)$p.value >= ALPHA
# rifiuto ipotesi di normalità

# work level
summary(muscle1$work_level)
sd(muscle1$work_level) # standard deviation
IQR(muscle1$work_level) # interquartile range

plot1 = ggplot(muscle1, aes(1,work_level)) +
  stat_boxplot(geom="errorbar", width=0.7) +
  geom_boxplot() +
  geom_jitter(width=0.5, color="blue", alpha=0.5, size=3) +
  theme(axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
  labs(x="", y="Work Level")

plot2 = ggplot(muscle1, aes(work_level)) + 
  geom_histogram(aes(y=..density..), colour=1, fill="white",
                 breaks=seq(10,60,by=10)) +
  geom_density(color="blue", fill="blue", alpha=0.2) +
  labs(x="Work Level", y="Density") +
  scale_x_continuous(limits=c(10,60))

plot3 = ggplot(muscle1, aes(sample=work_level)) +
  stat_qq(size=2, fill="white", shape=21) +
  stat_qq_line(color="blue") +
  labs(x="Theoretical Quantiles", y="Sample Quantiles")

grid.arrange(plot1, plot2, plot3, ncol=3)

shapiro.test(muscle1$work_level)
shapiro.test(muscle1$work_level)$p.value >= ALPHA
# rifiuto ipotesi di normalità

# heat output
summary(muscle1$heat_output)
sd(muscle1$heat_output) # standard deviation
IQR(muscle1$heat_output) # interquartile range

plot1 = ggplot(muscle1, aes(1,heat_output)) +
  stat_boxplot(geom="errorbar", width=0.7) +
  geom_boxplot() +
  geom_jitter(width=0.5, color="blue", alpha=0.5, size=3) +
  theme(axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
  labs(x="", y="Heat Output")

plot2 = ggplot(muscle1, aes(heat_output)) + 
  geom_histogram(aes(y=..density..), colour=1, fill="white",
                 breaks=seq(150,400,by=50)) +
  geom_density(color="blue", fill="blue", alpha=0.2) +
  labs(x="Heat Output", y="Density") +
  scale_x_continuous(limits=c(150,400))

plot3 = ggplot(muscle1, aes(sample=heat_output)) +
  stat_qq(size=2, fill="white", shape=21) +
  stat_qq_line(color="blue") +
  labs(x="Theoretical Quantiles", y="Sample Quantiles")

grid.arrange(plot1, plot2, plot3, ncol=3)

shapiro.test(muscle1$heat_output)
shapiro.test(muscle1$heat_output)$p.value >= ALPHA
# rifiuto ipotesi di normalità

# ANALISI BIVARIATA
ggally_points_filled = function(data, mapping, ...) {
  names(mapping)[grepl("^colour", names(mapping))] = "fill"
  ggally_points(data, mapping, ..., shape = 21)
}
w_ggally_points_filled = wrap(ggally_points_filled, size=2, fill="white",
                              color="black")

ggpairs(muscle1, diag=list(continuous="blankDiag"),
        lower=list(continuous=w_ggally_points_filled))

# body mass vs work level
ggplot(muscle1, aes(body_mass,work_level)) +
  geom_point(size=2, fill="white", shape=21) +
  geom_smooth(method="lm", se=F, color="red", linetype="dashed") +
  labs(x="Body Mass", y="Work Level")

cor.test(muscle1$body_mass, muscle1$work_level, method="spearman")

# body mass vs heat output
ggplot(muscle1, aes(body_mass,heat_output)) +
  geom_point(size=2, fill="white", shape=21) +
  geom_smooth(method="lm", se=F, color="red", linetype="dashed") +
  labs(x="Body Mass", y="Heat Output")

cor.test(muscle1$body_mass, muscle1$heat_output, method="spearman")

# work level vs heat output
ggplot(muscle1, aes(work_level,heat_output)) +
  geom_point(size=2, fill="white", shape=21) +
  geom_smooth(method="lm", se=F, color="red", linetype="dashed") +
  labs(x="Work Level", y="Heat Output")

cor.test(muscle1$work_level, muscle1$heat_output, method="spearman")
summary(lm(heat_output~work_level, data=muscle1))



# STIMA DEL MODELLO


# E(H) = a0+a1*M+a2*W
fit1 = lm(heat_output ~ body_mass + work_level, data=muscle1)
summary(fit1)

res1 = fit1$residuals
fitted1 = fit1$fitted.values
df1 = data.frame(resids=res1, fv=fitted1, H=muscle1$heat_output)

plot1 = ggplot(df1, aes(sample=resids)) +
  stat_qq(size=2, fill="white", shape=21) +
  stat_qq_line(color="blue") +
  labs(x="Theoretical Quantiles", y="Sample Quantiles")

plot2 = ggplot(df1, aes(resids,fv)) +
  geom_point(size=2, fill="white", shape=21) +
  labs(x="Residuals", y="Fitted Vaues")

grid.arrange(plot1, plot2, ncol=2)

shapiro.test(res1)

ggplot(df1, aes(H,fv)) +
  geom_point(size=2, fill="white", shape=21) +
  geom_abline(color="red", linetype="dashed") +
  labs(x="Observed Values", y="Fitted Vaues")

# effetto
1.6965 # di M
3.9395 # di W

# E(H) = b0+b1*M+(W/(b3+b4*M))
fit2 = nls(heat_output ~ b0+b1*body_mass+work_level/(b2+b3*body_mass),
           data=muscle1, start=list(b0=-117, b1=4, b2=1, b3=0))
summary(fit2)

res2 = fit2$m$resid()#[1:24]
#names(res2) = names(res1)
fitted2 = fit2$m$fitted()#[1:24]
#names(fitted2) = names(fitted1)
df2 = data.frame(resids=res2, fv=fitted2, H=muscle1$heat_output)

plot1 = ggplot(df2, aes(sample=resids)) +
  stat_qq(size=2, fill="white", shape=21) +
  stat_qq_line(color="blue") +
  labs(x="Theoretical Quantiles", y="Sample Quantiles")

plot2 = ggplot(df2, aes(resids,fv)) +
  geom_point(size=2, fill="white", shape=21) +
  labs(x="Residuals", y="Fitted Vaues")

grid.arrange(plot1, plot2, ncol=2)

shapiro.test(res2)

ggplot(df2, aes(H,fv)) +
  geom_point(size=2, fill="white", shape=21) +
  geom_abline(color="red", linetype="dashed") +
  labs(x="Observed Values", y="Fitted Vaues")

# effetto
# 4.221904+(34.04/(0.03119462 +0.003925117))-34.04/0.03119462 # di M
# non linearità, ha poco senso il singolo valore
1/(0.03119462+0.003925117*57.54) # di W

# E(H) = a0+a1*M+a2*W+a3*M*W
fit3 = lm(heat_output ~ body_mass + work_level + body_mass*work_level,
          data=muscle1)
summary(fit3)

res3 = fit3$residuals
fitted3 = fit3$fitted.values
df3 = data.frame(resids=res3, fv=fitted3, H=muscle1$heat_output)

plot1 = ggplot(df3, aes(sample=resids)) +
  stat_qq(size=2, fill="white", shape=21) +
  stat_qq_line(color="blue") +
  labs(x="Theoretical Quantiles", y="Sample Quantiles")

plot2 = ggplot(df3, aes(resids,fv)) +
  geom_point(size=2, fill="white", shape=21) +
  labs(x="Residuals", y="Fitted Vaues")

grid.arrange(plot1, plot2, ncol=2)

shapiro.test(res3)

ggplot(df3, aes(H,fv)) +
  geom_point(size=2, fill="white", shape=21) +
  geom_abline(color="red", linetype="dashed") +
  labs(x="Observed Values", y="Fitted Vaues")

# effetto
3.66528-0.052*34.04 # di M
6.95045-0.052*57.54 # di W

# CONCLUSIONI
ggplot() +
  geom_point(data=df1, aes(H,fv), size=2,colour="orange", alpha=0.5) +
  geom_point(data=df2, aes(H,fv), size=2,colour="blue", alpha=0.5) +
  geom_point(data=df3, aes(H,fv), size=2,colour="green", alpha=0.5) +
  geom_abline(color="red", linetype="dashed") +
  labs(x="Observed Values", y="Fitted Vaues")

ggplot() +
  geom_abline(color="red", size=1.5) +
  geom_smooth(data=df1, aes(H,fv), colour="orange", alpha=0.5, se=F) +
  geom_smooth(data=df2, aes(H,fv), colour="blue", alpha=0.5, se=F) +
  geom_smooth(data=df3, aes(H,fv), colour="green", alpha=0.5, se=F) +
  labs(x="Observed Values", y="Fitted Vaues")

AIC(fit1)
AIC(fit2)
AIC(fit3)

