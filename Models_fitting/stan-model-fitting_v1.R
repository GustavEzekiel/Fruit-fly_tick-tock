# Fruit-fly_tik-tok.
# By Guzkiel.

# Stan model fiting v1.

#------------------------------------------------------------------------------#




########################## cargado de paquetes, seteo wd y variables de entorno.

setwd("D:/Documents/Uncoma/Math & stadistics/Modelos en ecología/Tps/tpfinal")


library("deSolve")
library("dplyr")
library("ggplot2")
library("readr")
library("rstan")





########################## datos 

# tiempo y valores iniciales.
tiempo <- seq(5002, 5096, by = 4) # 4 dias, ptos por días.

iniciales <- c(Clk = 2, 
               Tim = 2,
               Per = 2)

# Parametros

parametros <- c(Jc = 1, Jt = 1, Jp = 1,    
                Mc = 10, Mt = 10, Mp = 10,
                alpha = 1,
                beta  = 1)


# carga de datos y checkeo
genes <- read.csv("celulas-ITP-ITP.csv", header = T, sep = ",")
str(genes)
nrow(genes) # number of cells

# factorizando variables.
genes$trat <- as.factor(genes$trat)
genes$tiempo <- as.factor(genes$time)
str(genes)

# reemplasando 0 por NA (opcional)
is.na(genes[3])<-genes[3]==0
is.na(genes[4])<-genes[4]==0
is.na(genes[5])<-genes[5]==0
is.na(genes[6])<-genes[6]==0

# separando tratamientos
genes.dd <- filter(genes, trat=="DD")
genes.ld <- filter(genes, trat=="LD")
str(genes.dd)
str(genes.ld)
nrow(genes.dd)

# sacando los NAs (opcional)

genes.dd <- na.omit(genes.dd)
nrow(genes.dd)

# reacomodando en un array
genes.def <- genes.dd[c(2,4:7)]

#genes.def$Clk[is.na(genes.def$Clk)] <- 0.5
#genes.def$tim[is.na(genes.def$tim)] <- 0.5
#genes.def$per[is.na(genes.def$per)] <- 0.5

# spliteado
data.def <- as.list(split(genes.def, genes.def$tiempo))
data.def                 # check
lapply(data.def, nrow)   # check
f <- function(df){
  df <- df[1:88, 2:4]
}
data.def<-lapply(data.def, f)
lapply(data.def, head)  # check
lapply(data.def, nrow)  # check

# repitiendo los datos por 4 dias.
data.def <- append(data.def, c(data.def, data.def, data.def)) 
names(data.def) <- tiempo
lapply(data.def, head)  # check
lapply(data.def, nrow)  # check
length(data.def)        # check n of time points

data.def <- as.array(lapply(data.def, as.matrix))


#### datos a pasarle a stan

datos <- list (T  = length(tiempo),
               N  = 88,
               y0 = c(2,2,2),
               t0 = 5001,
               t  = tiempo,
               y  = data.def,
               mc = 10,
               mt = 10,
               mp = 10)


fit <- stan( file = "real fitting 1.stan", 
             data   = datos, 
             chains = 4,
             iter   = 4000, 
             thin   = 1)           



fit
summary(fit)
plot(fit)
print(fit)
traceplot(fit)


# googlear el error:

"AMPLING FOR MODEL 'real fitting 1' NOW (CHAIN 1).
Chain 1: Unrecoverable error evaluating the log probability at the initial value.
Chain 1: Exception: Exception: []: accessing element out of range. index 2 out of range; expecting index to be between 1 and 1; index position = 1theta  (in 'modelb0c2be942b2_real_fitting_1' at line 10)
  (in 'modelb0c2be942b2_real_fitting_1' at line 55)

[1] Error in sampler$call_sampler(args_list[[i]]) : "                                                                                                                                                   
[2] "  Exception: Exception: []: accessing element out of range. index 2 out of range; expecting index to be between 1 and 1; index position = 1theta  (in 'modelb0c2be942b2_real_fitting_1' at line 10)"
[3] "  (in 'modelb0c2be942b2_real_fitting_1' at line 55) "
