# Fruit-fly_tik-tok.
# By Guzkiel.

#------------------------------------------------------------------------------#




#### cargado de paquetes, seteo wd y variables de entorno.

setwd("D:/Documents/Uncoma/_Pasantía Dto FM/00-Circadian clock project/RNA-seq analysis/data-roshbash/filtered-by-quality")
load("D:/Documents/Uncoma/Math & stadistics/Modelos en ecología/Tps/tpfinal/datagrab.RData")

library("dplyr")






##### data loading ----

## RNA-seq data
files<-list.files()
head(files)

lista <- list()
for (i in 1:length(files)){                              # reading tables.
  lista[[i]]<-read.csv(files[i], header = T, sep = ',')  # read csv funciona mejor que read table.
}

# checking
length(lista)              # number of samples
sapply(lista, ncol) - 1    # number of cells per sample
sum(sapply(lista, ncol))   # cell total
sapply(lista,nrow)         # number of genes per sample

## genes of interest
goi<-c("cyc", "Clk", "tim", "per")







#### normalization TP10K ----

lista_norm = list()
norm.factors <- lapply(lista, function(x){apply(x[-1], 2, sum)}) # sumatoria de cada columna de cada muestra.
for (i in 1:length(lista)){
  lista_norm[[i]] <- sweep(lista[[i]][-1], 2, norm.factors[[i]], FUN = "/") * 10000
  lista_norm[[i]] <- log1p(lista_norm[[i]])                      # normalizacion ln(x+1)
}
for (i in 1:length(lista_norm)){
  lista_norm[[i]] <- cbind(lista[[i]][1], lista_norm[[i]])
}      

# checking
summary(lista_norm)
lapply(lista_norm, head)
sapply(lista_norm, ncol) -1
sum(sapply(lista, ncol))   # cell total
sapply(lista,nrow)         # number of genes per sample




#### filtering by cells of interest ----

list_filt <- list()
for (i in 1:length(lista_norm)){
  list_filt[[i]]<-lista_norm[[i]][ , lista_norm[[i]][which(lista_norm[[i]]$X=="Pdf"), ] > 2] # df[allrows, df[rowIndex, allcolumns]!=0].
  # En este caso me con todas las células que expresan sNPF.  (me quedo solo con s-LNvs)
}


# getting ride of null items on the list.
check <- function(df){
  return(is.null(ncol(df)))
}
list_filt <- list_filt[-which(sapply(list_filt, check))]

# checking
length(list_filt)                     # number of samples
unlist(sapply(list_filt, nrow))       # number of genes per sample
unlist(sapply(list_filt, ncol)) -1    # number of cells per sample
sum(unlist(sapply(list_filt, ncol)) -1)    # number of cells 


for (i in 1:length(list_filt)){
  list_filt[[i]]<-list_filt[[i]][ , list_filt[[i]][which(list_filt[[i]]$X=="sNPF"), ] > 2] # df[allrows, df[rowIndex, allcolumns]!=0].
  # En este caso me con todas las células que expresan sNPF.  (me quedo solo con s-LNvs)
}

# getting ride of null items on the list.
check <- function(df){
  return(is.null(ncol(df)))
}
list_filt <- list_filt[-which(sapply(list_filt, check))]


# checking
length(list_filt)                     # number of samples
unlist(sapply(list_filt, nrow))       # number of genes per sample
unlist(sapply(list_filt, ncol)) -1    # number of cells per sample
sum(unlist(sapply(list_filt, ncol))-1)    # number of cells 








#### filtering by goi ----

goi_list <-list()
for (i in 1:length(list_filt)){
  goi_idx <- numeric(length(goi))
  for (j in 1:length(goi)){
    goi_idx[j]<-which(list_filt[[i]]$X==goi[j])
  }
  goi_list[[i]] <- list_filt[[i]][goi_idx, ]
}


# checking goi_list
length(goi_list)             # number of samples
sapply(goi_list, ncol) -1    # number of cells per sample
sum(sapply(goi_list, ncol)-1)  # cell total
sapply(goi_list, nrow)       # number of genes per sample








#### reacomodando la lista ----

trans<-function(df){
  dft<-t(df[-1])
  colnames(dft)<-c("cyc", "Clk", "tim", "per")
  return(dft)
}
goi_list <- lapply(goi_list, trans)


#checking
sapply(goi_list, head)

df.final <- as.data.frame(goi_list[[1]])
for(i in 2:length(goi_list)){
  df.final <- union_all(df.final, as.data.frame(goi_list[[i]]))
}

#checking
head(df.final)
str(df.final)

trat <- as.factor(substr(rownames(df.final), 18, 19))
time <- as.numeric(substr(rownames(df.final), 23, 24))
df.final <- cbind(trat, time, df.final)

#checking
head(df.final)
str(df.final)



# data storing

write.table(df.final, file = "D:/Documents/Uncoma/Math & stadistics/Modelos en ecología/Tps/tpfinal/norm.clockgenes.csv",
            sep = ",", 
            row.names = FALSE, 
            col.names = TRUE, 
            quote = FALSE)




#------------------------------------------------------------------------------#
save.image(file = "D:/Documents/Uncoma/Math & stadistics/Modelos en ecología/Tps/tpfinal/datagrab.RData")

