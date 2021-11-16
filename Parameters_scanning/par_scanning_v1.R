# Fruit-fly_tik-tok.
# By Guzkiel.



########################### checkeo de comportamiento cíclico ################################## -


setwd("D:/Documents/Uncoma/Math & stadistics/Modelos en ecología/Tps/tpfinal")

library("deSolve")
library("dplyr")
library("gtools")







########################### sistema ODE ---------------------------------------------

# condiciones iniciales y tiempo (en hs)

tiempo <- seq(4990, 5000, by = 2)

iniciales <- c(Cyc = 5, 
               Clk = 10, 
               Tim = 5,
               Per = 2)

# Parametros

largen <- c(Cyc = 2163, 
            Clk = 12371, 
            Tim = 14134,
            Per = 7201)

parametros <- c(alpha = 80,
                beta  = 80,
                Mcy = 10, Mc = 10, Mt = 10, Mp = 10,
                Kcy = 0.1, Kc = 10, Kt = 0.1, Kp = 0.1, # kc es clave
                Jcy = 1, Jc = 60, Jt = 1, Jp = 1)      # jcy es clave



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

# ploteo de la solución logaritmizada

plot(solucion$time, solucionn$Cyc, type = "l", ylim = c(0,40), lwd = 2)
points(solucion$time, solucionn$Clk, type = "l", col = "blue", lwd = 2)
points(solucion$time, solucionn$Tim, type = "l", col = "red", lwd = 2)
points(solucion$time, solucionn$Per, type = "l", col = "pink", lwd = 2)









#################################### Checking -------------------------------------

# tiempos a evaluar.
tiempo <- c(0, seq(2, 10024, by = 4)) # ultimos 4 indexs 2502:2507



# parametros a explorar.
par.exp <- list()
for (i in 1:8){
  par.exp[[i]]<-seq(0.5, 1.5, by = 1)
}



# exploracion
explorado <- function(par.exp, tiempo){
  par.exi <- list()
  for (i in 1:length(par.exp[[1]])){
    for (j in 1:length(par.exp[[2]])){
      for (k in 1:length(par.exp[[3]])){
        for (l in 1:length(par.exp[[4]])){
          for (m in 1:length(par.exp[[5]])){
            for (n in 1:length(par.exp[[6]])){
              for (o in 1:length(par.exp[[7]])){
                for (p in 1:length(par.exp[[8]])){
                  
                  # asignacion de parametros
                  parametros["Kcy"] <- par.exp[[1]][i]
                  parametros["Kc"]  <- par.exp[[2]][j]
                  parametros["Kt"]  <- par.exp[[3]][k]
                  parametros["Kp"]  <- par.exp[[4]][l]
                  parametros["Jcy"] <- par.exp[[5]][m]
                  parametros["Jc"]  <- par.exp[[6]][n]
                  parametros["Jt"]  <- par.exp[[7]][o]
                  parametros["Jp"]  <- par.exp[[8]][p]


                  # resolucion del sistema
                  solucion <- as.data.frame(lsoda(iniciales, tiempo, sistema, parametros))
                  sol.eval <- trunc(solucion[2502:2507, 4:5])
                  T <- sol.eval$Tim
                  P <- sol.eval$Per
                  
                  # evaluacion
                  if ( length(unique(T)) == 1 | length(unique(P)) == 1 | 
                       length(T[T<0])>0 | length(P[P<0])>0 ){
                  }
                  # guardado de parametros exitosos
                  else {
                    par.exi <- c(par.exi, list(parametros))
                    print("parameters kept")
                  }
                }
              }
            }
          }
        }
      }
    }
  }
  return(par.exi)
}









################################################# FUUUUUUUCK
start.time <- Sys.time()
theWinnersAre <- explorado(par.exp, tiempo)
end.time <- Sys.time()
end.time - start.time



### soluciones ganadoras

par <- theWinnersAre[[1]]
solucion <- as.data.frame(lsoda(iniciales, tiempo, sistema, par))
sol.eval <- trunc(solucion[2502:2507, 4:5])
T <- sol.eval$Tim
P <- sol.eval$Per

# ploteo de la solución

plot(solucion$time, solucion$Cyc, type = "l", ylim = c(0,40), lwd = 2)
points(solucion$time, solucion$Clk, type = "l", col = "blue", lwd = 2)
points(solucion$time, solucion$Tim, type = "l", col = "red", lwd = 2)
points(solucion$time, solucion$Per, type = "l", col = "pink", lwd = 2)







################################################# prueba


f <- function(par){
  # preparando la data
  parametros[7:14] <- par
  solucion <- as.data.frame(lsoda(iniciales, tiempo, sistema, parametros))
  sol.eval <- trunc(solucion[2502:2507, 4:5])
  T <- sol.eval$Tim
  P <- sol.eval$Per
  
  # evaluacion
  if ( length(unique(T)) == 1 | length(unique(P)) == 1 | 
       length(T[T<0])>0 | length(P[P<0])>0 ){
  }
  # guardado de parametros exitosos
  else {
    par.exi <- c(par.exi, list(parametros))
    return(par.exi)
  }
}

par.exi <- list()
eval <- function(para.exp){
  p <- permutations(length(para.exp), 8, para.exp, repeats.allowed = T)
  salida <- apply(p, 1, f)
  return(salida)
}



## parametros a explorar
para.exp <- seq(0.1 , 1.1, by = 0.2)
length(para.exp)
nrow(permutations(length(para.exp), 8, para.exp, repeats.allowed = T))

# tiempo estimado en hs
((nrow(permutations(length(para.exp), 8, para.exp, repeats.allowed = T))/6561) * 7)/3600

## corrida
start.time <- Sys.time()
theWinnersAre <- eval(para.exp)
end.time <- Sys.time()
end.time - start.time



