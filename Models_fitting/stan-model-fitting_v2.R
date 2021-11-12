# Fruit-fly_tik-tok.
# By Guzkiel.

# Stan model fiting v2.
#------------------------------------------------------------------------------#




################### cargado de paquetes, seteo wd y variables de entorno.


setwd("D:/Documents/Uncoma/Math & stadistics/Modelos en ecología/Tps/tpfinal")
load("standata.Rdata")

library("dplyr")
library("ggplot2")
library("rstan")

rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())  # para que corra varias cadenas a la vez.




################### Datos 


# carga de datos y checkeo
genes <- read.csv("norm.clockgenes.csv", header = T, sep = ",")
str(genes)
nrow(genes) # number of cells

# reemplazando 0 por NA
is.na(genes[3])<-genes[3]==0
is.na(genes[4])<-genes[4]==0
is.na(genes[5])<-genes[5]==0
is.na(genes[6])<-genes[6]==0

# factorizando variables.
genes$trat <- as.factor(genes$trat)
genes$tiempo <- as.factor(genes$time)
genes$time <- as.numeric(genes$time)
str(genes)

# extrayendo casos

means <- aggregate(genes[3:6], list(genes$trat, genes$tiempo), mean, na.rm = T)
stdde <- aggregate(genes[3:6], list(genes$trat, genes$tiempo), sd, na.rm = T)
colnames(means) <- c("trat", "tiempo","cyc", "Clk", "tim", "per")
colnames(stdde) <- c("trat", "tiempo","cyc", "Clk", "tim", "per")

mdgenes.dd <- filter(means, trat == "DD")
sdgenes.dd <- filter(stdde, trat == "DD")

mdgenes.dd$tiempo <- as.numeric(mdgenes.dd$tiempo)
sdgenes.dd$tiempo <- as.numeric(mdgenes.dd$tiempo)

genesdd <- filter(genes, trat == "DD")


################### Stan model running


# Datos

largen <- c(Cyc = 2163, 
            Clk = 12371, 
            Tim = 14134,
            Per = 7201)

m = c(
  2,                           # cte hill cyc
  2,                           # cte hill Clk
  2,                           # cte hill tim
  2 )                          # cte hill per

t0 =c(
  2,                           # t0 cyc
  2,                           # t0 Clk
  2,                           # t0 tim
  2 )                          # t0 per


datos <- list (
  T  = nrow(genesdd)-1,
  ts = genesdd[ , 2],
  ob = genesdd[ , 3:6],
  y0 = means[ 1, 3:6],
  t0 = t0,
  m  = m,
  lg = largen) 




################### run model


# lectura del string por parte del interpretador de stan

fit <- stan(file   = "shoujoModel.stan", 
            data   = datos, 
            chains = 3,
            iter   = 1000, 
            thin   = 1)



# visualizar salidas del modelo

fit
summary(fit)
plot(fit)
print(fit)
traceplot(fit)
extract(fit)

#-----------------------------------------------------------------------------------------------------------------------
save.image(file = "standata.Rdata")
