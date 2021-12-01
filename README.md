# Fruit-fly_tik-tok 
[readme still under construction]

## Introduction
Mathematical and statistical model of fruit fly core circadian clock molecules. The main purpuse of this modeling is to fit ODEs that represent circadian oscilation of mRNA levels of clock components over single-cell RNAseq (scRNA-seq) data of clock neurons. Looking for diferences in parameters of the model across different neuron clusters and conditions represented in the scRNA-seq data.


## The system

### Logic diagram of the basic model
[<img align="center" alt="Logic diagram of the model" src="https://github.com/GustavEzekiel/Fruit-fly_tik-tok/blob/main/Documentation/Logic%20diagram%20of%20the%20model.png?raw=true" />]


### Equations of the model 

#### Deterministic part (ODEs)
 [<img align="center" alt="ODEs" width="650px" src="https://github.com/GustavEzekiel/Fruit-fly_tik-tok/blob/main/Documentation/ODEs.png?raw=true" />]

 ##### where:

    • α = Maximum transcription rate (nucleotides / hour)
    • β = Maximum enzymatic degradation rate (nucleotides / hour)
    • Jcy, c, T, p = Scalars for maximum transcription rate of each mRNA.
    • Kcy, c, T, p = Scalars for the effect of mRNA concentration on degradative enzymatic action.
    • mcy, c, T, p = Hill constant for each mRNA.
    • ntCyc =  Cycle (CyC) DNA gen length in nucleotides (nt). 
    • ntClk = Clock (Clk) DNA gen length in nt.
    • ntTim = Timeless (Tim) DNA gen lenght in nt. 
    • ntPer = Period (per) DNA gen length in nt. 


#### Stocastic part

 [<img align="center" alt="ODEs" src="https://github.com/GustavEzekiel/Fruit-fly_tik-tok/blob/main/Documentation/Stocastic-part.png?raw=true" />]

 ##### where:

