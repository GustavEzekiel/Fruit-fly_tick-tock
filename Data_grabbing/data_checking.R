# Fruit-fly-tik-tok.
# by Guzkiel.

# Data checking

#------------------------------------------------------------------------------#




#### cargado de paquetes, seteo wd y variables de entorno.

setwd("D:/Documents/Uncoma/Math & stadistics/Modelos en ecología/Tps/tpfinal")
load("tpfinal.Rdata")

library("deSolve")
library("dplyr")
library("ggplot2")


################### Datos ---------------------------------#

# carga de datos y checkeo
genes <- read.csv("norm.clockgenes.csv", header = T, sep = ",")
str(genes)
nrow(genes) # number of cells

# reemplasando 0 por NA
is.na(genes[3])<-genes[3]==0
is.na(genes[4])<-genes[4]==0
is.na(genes[5])<-genes[5]==0
is.na(genes[6])<-genes[6]==0

# factorizando variables.
genes$trat <- as.factor(genes$trat)
genes$tiempo <- as.factor(genes$time)
str(genes)

# separando tratamientos
genes.dd <- filter(genes, trat=="DD")
genes.ld <- filter(genes, trat=="LD")
str(genes.dd)
str(genes.ld)

# cálculo de medias por tiempo y trat
means <- aggregate(genes[3:6], list(genes$trat, genes$tiempo), mean, na.rm = T)
stdde <- aggregate(genes[3:6], list(genes$trat, genes$tiempo), sd, na.rm = T)
colnames(means) <- c("tiempo", "cyc", "Clk", "tim", "per", "trat")
colnames(stdde) <- c("tiempo", "cyc", "Clk", "tim", "per", "trat")

# checking
means
stdde




#### ploteos exploratorios.


op <- par(mfrow = c(2, 2),                    # grid of plots by rows.
          omi = c(0.2,0.2,0.1,0.1),           # the size of outer margins in inches
          mar = c(2.3, 2.4, 1.5, 1),          # nomber of lines of margin for each plot
          cex.axis = 1.3,                     # size of labels over the axis
          cex.lab = 1.2,                      # size of axis labels
          mgp = c(1.5, 0.5, 0))               # margin lines in mex units for c(axis title, axis labels, axis lines)
boxplot(genes.dd$cyc~genes.dd$tiempo, xlab = "CT", ylab = "cyc DD")
boxplot(genes.ld$cyc~genes.ld$tiempo, xlab = "ZT", ylab = "cyc LD", col = "pink")
boxplot(genes.dd$Clk~genes.dd$tiempo, xlab = "CT", ylab = "Clk DD")
boxplot(genes.ld$Clk~genes.ld$tiempo, xlab = "ZT", ylab = "Clk LD", col = "pink")

boxplot(genes.dd$tim~genes.dd$tiempo, xlab = "CT", ylab = "tim DD")
boxplot(genes.ld$tim~genes.ld$tiempo, xlab = "ZT", ylab = "tim LD", col = "pink")
boxplot(genes.dd$per~genes.dd$tiempo, xlab = "CT", ylab = "per DD")
boxplot(genes.ld$per~genes.ld$tiempo, xlab = "ZT", ylab = "per LD", col = "pink")


par(op)


# ploteos definitivos

ggplot(medias.dd, aes(x = Group.1, y=cyc)) + 
  geom_point()
