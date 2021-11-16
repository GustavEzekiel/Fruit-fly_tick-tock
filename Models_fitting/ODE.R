# Fruit-fly_tik-tok.
# By Guzkiel.

# ODE

#------------------------------------------------------------------------------#




#### cargado de paquetes, seteo wd y variables de entorno.

setwd("D:/Documents/Uncoma/Math & stadistics/Modelos en ecología/Tps/tpfinal")
load("tpfinal.Rdata")

library("deSolve")
library("dplyr")
library("ggplot2")







                    ################### ODE --------------------------------#

# condiciones iniciales y tiempo (en hs)

tiempo <- seq(2, 100, by = 1)

iniciales <- c(Cyc = 5, 
               Clk = 10, 
               Tim = 5,
               Per = 2)

# Parametros

largen <- c(Cyc = 2163, 
            Clk = 12371, 
            Tim = 14134,
            Per = 7201)

parametros <- c(Jcy = 1, Jc = 60.456, Jt = 1, Jp = 1,    # jcy es clave
                Kcy = 0.1, Kc = 10.4563, Kt = 0.1, Kp = 0.1, # kc es clave
                Mcy = 5, Mc = 1, Mt = 2, Mp = 2,
                alpha = 50000,
                beta  = 50000)

# Ecuaciones

sistema <- function (t, ini, par) {
  
  with(as.list(c(ini, par)),{
    
    # ODEs
    dCyc = (alpha/largen["Cyc"]) / Jcy                                                 - (beta/largen["Cyc"]) * Cyc^Mcy / (Kcy^Mcy + Cyc^Mcy) 
    dClk = (alpha/largen["Clk"]) / ( Jc + (Cyc*Clk)^Mc )                               - (beta/largen["Clk"]) * Clk^Mc / (Kc^Mc + Clk^Mc)
    dTim = (alpha/largen["Tim"]) * (Cyc*Clk)^Mt / ( Jt + (Cyc*Clk)^Mt + (Tim*Per)^Mt ) - (beta/largen["Tim"]) * Clk^Mt / (Kc^Mt + Clk^Mt) 
    dPer = (alpha/largen["Per"]) * (Cyc*Clk)^Mp / ( Jp + (Cyc*Clk)^Mp + (Tim*Per)^Mp ) - (beta/largen["Per"]) * Clk^Mp / (Kc^Mp + Clk^Mp) 
    
    # Output (ode y lsoda piden una lista como salida de la funcion)
    list(c(dCyc, dClk, dTim, dPer)) 
    
  })
}

sistema(tiempo, iniciales, parametros)

# resolución de las ecuaciones

solucion <- as.data.frame(lsoda(iniciales, tiempo, sistema, parametros))

head(solucion)
plot(solucion$time, solucion$Cyc, type = "n", ylim = c(0,13), lwd = 2,
     xlab = "CT", cex.lab = 1.5, ylab = "Log TP10K")
points(solucion$time, solucion$Clk, type = "l", col = "red", lwd = 1)
points(solucion$time, solucion$Tim, type = "l", col = "blue", lwd = 1)
points(solucion$time, solucion$Per, type = "l", col = "green", lwd = 1)
legend(80, 13, legend=c("clk", "tim", "per"),
       col=c("red", "blue", "green"), lty=1, cex=1)

abline(h=0)


















#-----------------------------------------------------------------------------------------------------------------------
save.image(file = "tpfinal.Rdata")

