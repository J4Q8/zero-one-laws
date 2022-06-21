
import pandas as pd
import numpy as np 
import os

class Extractor():
    def __init__(self) -> None:
        self.a_exp = "asymptoticModelExperiment"
        self.val = "validated-Peregrine"
        self.batches = list(range(1, 11))

        # get columns of dataframe
        metadata = ["formula", "tautology_GL", "contradiction_GL", 
                   "tautology_S4", "contradiction_S4", 
                   "tautology_K4", "contradiction_K4"]
        languages = ["GL", "S4", "K4"]
        numbers = list(range(40, 81, 8))
        valexact = [f'{a}_{b}' for a in languages for b in numbers]
        options = ["exact", "rounded"]
        validity = [f'{a}_{b}' for a in valexact for b in options]

        self.df = pd.DataFrame(columns=metadata.extend(validity))
    
    def read_txt(self, path, columns):
        df = pd.read_csv(path, sep=',',header=None)
        df.columns = columns


# >>> df = pd.DataFrame(columns=['a','b','c','d'], index=['x','y','z'])  
# >>> df.loc['y'] = pd.Series({'a':1, 'b':5, 'c':2})                      
# >>> df
#      a    b    c    d
# x  NaN  NaN  NaN  NaN
# y  1.0  5.0  2.0  NaN
# z  NaN  NaN  NaN  NaN
# >>>