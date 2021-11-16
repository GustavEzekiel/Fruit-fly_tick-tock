# Fruit-fly_tik-tok.
# By Guzkiel.



# par scanning




###### package loading

library("deSolve")
library("gtools")


###### ODE system

# value settings

time <- c(0, seq(2, 10024, by = 4)) # ultimos 4 indexs 2502:2507
init <- c( CC =5,
           PT = 5,
           Clk = 5, 
           Tim = 5,
           Per = 5)

# Parameters

parametros <- c(alpha = 80,
                beta  = 80,
                Cyc = 2,
                Mc = 10, Mt = 10, Mp = 10,
                gamma = 0.7,
                delta = 1,
                Kc = 1, Kt = 1, Kp = 1, 
                Jc = 1, Jt = 1, Jp = 1)      

# Equations

sistema <- function (t, ini, par) {
  
  with(as.list(c(ini, par)),{
    
    # ODEs
    dCC  = gamma*(Cyc*Clk) - delta*(CC)
    dPT  = gamma*(Per*Tim) - delta*(PT)
    dClk = (alpha) / ( Jc + (CC)^Mc )                     - (beta) * Clk^Mc / (Kc^Mc + Clk^Mc)
    dTim = (alpha) * (CC)^Mt / ( Jt + (CC)^Mt + (PT)^Mt ) - (beta) * Clk^Mt / (Kc^Mt + Clk^Mt) 
    dPer = (alpha) * (CC)^Mp / ( Jp + (CC)^Mp + (PT)^Mp ) - (beta) * Clk^Mp / (Kc^Mp + Clk^Mp) 
    
    # Output (ode y lsoda piden una lista como salida de la funcion)
    list(c(dCC, dPT, dClk, dTim, dPer)) 
    
  }) 
}





###### functions 

f <- function(par){
  # data setting
  parametros[7:14] <- par
  sol <- as.data.frame(lsoda(init, time, sistema, parametros))
  T <- sol$Tim[2502:2507]
  P <- sol$Per[2502:2507]
  
  # Assessing & saving
  if ( length(unique(T)) != 1 & length(unique(P)) != 1 & 
       length(T[T<0])==0 & length(P[P<0])==0 & 
       abs(T[4]-T[1])<100 & abs(P[4]-P[1])<100 &
       abs(T[4]-T[1])>0.5 & abs(P[4]-P[1])>0.5 ){
    par.exi <- c(par.exi, list(parametros))
    print("sp")
    return(par.exi)
  }
}


eval <- function(para.exp){
  p <- permutations(length(para.exp), 8, para.exp, repeats.allowed = T)
  salida <- apply(p, 1, f)
  return(salida)
}




###### data setting

# parameters to explore
para.exp <- seq(0.5 , 1.5, by = 1)

# empty list for successful parameters
par.exi <- list()

# checking
length(para.exp)
nrow(permutations(length(para.exp), 8, para.exp, repeats.allowed = T))





###### running
start.time <- Sys.time()
theWinnersAre <- eval(para.exp)
end.time <- Sys.time()
end.time - start.time




###### cheaking

par.gan <- theWinnersAre[[63]][[1]]
solucion <- as.data.frame(lsoda(init, time, sistema, par.gan))
plot(solucion$time[2450:2507], solucion$PT[2450:2507])






################ Este codigo funciona. Pero habría que buscar formas de optimizarlo, 
# encontrar cotas para los parámetros y valores puntuales para gamma y delta en la biblo.


