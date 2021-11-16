# Fruit-fly_tik-tok.
# By Guzkiel.



########################### Settings ----

setwd("D:/Documents/Uncoma/Math & stadistics/Modelos en ecología/Tps/tpfinal")

library("deSolve")
library("dplyr")
library("ggplot2")
library("bbmle")







########################### sistema ----

# condiciones iniciales y tiempo (en hs)

tiempo <- c(0,seq(2, 24, by = 0.5))

iniciales <- c(Cyc = 5, 
               Clk = 10, 
               Tim = 5,
               Per = 2)

# Parametros

largen <- c(Cyc = 2163, 
            Clk = 12371, 
            Tim = 14134,
            Per = 7201)

parametros <- c(alpha = 70,
                beta  = 70,
                Kcy = 0.1, Kc = 10, Kt = 0.1, Kp = 0.1, # kc es clave
                Jcy = 1, Jc = 60, Jt = 1, Jp = 1,       # jcy es clave
                Mcy = 5, Mc = 1, Mt = 2, Mp = 2)
               

# Ecuaciones

sistema <- function (t, ini, par) {
  
  with(as.list(c(ini, par)),{
    
    # ODEs
    dCyc = (alpha) / Jcy                                                 - (beta) * Cyc^Mcy / (Kcy^Mcy + Cyc^Mcy) 
    dClk = (alpha) / ( Jc + (Cyc*Clk)^Mc )                               - (beta) * Clk^Mc / (Kc^Mc + Clk^Mc)
    dTim = (alpha) * (Cyc*Clk)^Mt / ( Jt + (Cyc*Clk)^Mt + (Tim*Per)^Mt ) - (beta) * Clk^Mt / (Kc^Mt + Clk^Mt) 
    dPer = (alpha) * (Cyc*Clk)^Mp / ( Jp + (Cyc*Clk)^Mp + (Tim*Per)^Mp ) - (beta) * Clk^Mp / (Kc^Mp + Clk^Mp) 
    
    # Output (ode y lsoda piden una lista como salida de la funcion)
    list(c(dCyc, dClk, dTim, dPer)) 
    
  }) 
}

# resolución de las ecuaciones

solucion <- as.data.frame(lsoda(iniciales, tiempo, sistema, parametros))

# ploteo de la solución

plot(solucion$time, solucion$Cyc, type = "l", ylim = c(0,40), lwd = 2)
points(solucion$time, solucion$Clk, type = "l", col = "blue", lwd = 2)
points(solucion$time, solucion$Tim, type = "l", col = "red", lwd = 2)
points(solucion$time, solucion$Per, type = "l", col = "pink", lwd = 2)







########################### datos ----

clockgenes<-read.csv("clockgenes.csv", header = T, sep = ",")







########################### Modelo ----


### definicion del modelo
mod.mll <- function(par.ini){
  
  # parametros y resolucion del sistema
  parametros["alpha"] <- exp (par.ini[1]) # ingresar parametros en logaritmo.
  parametros["beta"] <- exp (par.ini[2])
  parametros["Kcy"] <- exp(par.ini[3])
  parametros["Kc"]  <- par.ini[4]
  parametros["Kt"]  <- par.ini[5]
  parametros["Kp"]  <- par.ini[6]
  parametros["Jcy"] <- par.ini[7]
  parametros["Jc"]  <- par.ini[8]
  parametros["Jt"]  <- par.ini[9]
  parametros["Jp"]  <- par.ini[10]
  solucion <- as.data.frame(lsoda(iniciales, tiempo, sistema, parametros))
  
  # armado de df
  y_hat <- solucion
  obs <- left_join(clockgenes, y_hat, by = "time")
  
  # calculo de mll
  row.mll <- function(vector){
    -sum(dnorm(vector[1:4], mean = vector[5:8], sd = sigma, log = TRUE))
  }
  sum(apply(obs, 1, row.mll))
}




### corrida del modelo
parnames(mod.mll) <- c("alpha", "beta", 
                      "Kcy", "Kc", "Kt", "Kp", 
                      "Jcy", "Jc", "Jt", "Jp")
fit <- mle2(mod.mll, 
            start = parametros[1:10], 
            data = list(iniciales  = iniciales, 
                        tiempo     = tiempo,
                        sistema    = sistema, 
                        clockgenes = clockgenes[-1],
                        sigma      = 1))







