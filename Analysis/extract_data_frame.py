
from codecs import ignore_errors
from operator import mod
import pandas as pd
import numpy as np 
import os
from sympy import true
from sklearn.linear_model import LinearRegression

from torch import index_copy

class Extractor():
    def __init__(self) -> None:
        self.asymptotic_path = "asymptoticModelExperiment"
        self.validated_path = "validated-Peregrine"
        self.formulas_path = "generated"
        self.selected_formulas_file = "SelectedFormulasRaw.txt"
        self.selected_formulas_meta_file = "SelectedFormulasMetaData.txt"
        self.batches = list(range(1, 10+1))
        self.depths = list(range(6, 13+1))

        # get columns of dataframe
        self.formula_col = ["formula"]
        self.metadata_col = ["tautology_GL", "contradiction_GL", 
                   "tautology_S4", "contradiction_S4", 
                   "tautology_K4", "contradiction_K4"]
        self.metadata2_col = ["depth"]
        self.languages_col = ["GL", "S4", "K4"]
        asymptotic = "asymptotic_model_val"
        self.asymptotic_col = [asymptotic+f"_{l}" for l in self.languages_col]
        self.nodes_col = list(range(40, 81, 8))
        self.val_option_col = ["frame", "model"]
        self.trends = [f'trend_{a}_{b}' for a in self.languages_col for b in self.val_option_col]
        # self.options_col = ["exact", "rounded"]

        valexact = [f'{a}_{b}' for a in self.languages_col for b in self.nodes_col]
        # validity = [f'{a}_{b}' for a in valexact for b in self.options_col]
        # validities = [f'{a}_{b}' for a in self.val_option_col for b in validity]

        self.df = pd.DataFrame(columns=self.formula_col)
    
    def read_txt(self, path, columns):
        try:
            df = pd.read_csv(path, sep=',',header=None)
        except:
            df = pd.DataFrame(np.empty((100, 7)))
        df.columns = columns
        return df

    def append(self, df):
        self.df = pd.concat([self.df,df], ignore_index=True)

    def add_col(self, df):
        self.df[df.columns] = df
    
    def get_df(self):
        return self.df

    def extract_formulas(self):
        # get generated formulas
        for formulaSet in self.batches:
            for depth in self.depths:
                file = os.path.join(self.formulas_path, f"formulas {formulaSet}", f"depth {depth}.txt")
                df = self.read_txt(file, self.formula_col)
                self.append(df)

        # get selected formulas
        file = self.selected_formulas_file
        df = self.read_txt(file, self.formula_col)
        self.append(df)
    
    def extract_metaData(self):
        df = pd.DataFrame(columns=self.metadata_col)
        df2 = pd.DataFrame(columns=self.metadata2_col)
        # get metaData of generated formulas
        for formulaSet in self.batches:
            for depth in self.depths:
                file = os.path.join(self.formulas_path, f"metaData {formulaSet}", f"depth {depth}.txt")
                data = self.read_txt(file, self.metadata_col).astype("string")
                df = df.append(data, ignore_index=True)
                depthpd = pd.DataFrame([depth]*data.shape[0], columns=self.metadata2_col)
                df2 = df2.append(depthpd, ignore_index=True)

        # get metaData of selected formulas
        file = self.selected_formulas_meta_file
        data = self.read_txt(file, self.metadata_col + self.metadata2_col)
        df = df.append(data[self.metadata_col], ignore_index=True)
        df2 = df2.append(data[self.metadata2_col], ignore_index=True)

        self.add_col(df)
        self.add_col(df2)

    def extract_asymptotic(self):
        for i, language in enumerate(self.languages_col):
            col = [self.asymptotic_col[i]]
            df_l = pd.DataFrame(columns=col)
            for formulaSet in self.batches:
                for depth in self.depths:
                    file = os.path.join(self.asymptotic_path, str(language), f"formulas {formulaSet}", f"depth {depth}.txt")
                    data = self.read_txt(file, col)
                    df_l = df_l.append(data, ignore_index=True)
            file = os.path.join(self.asymptotic_path, str(language), "formulas 0", "selected.txt")
            data = self.read_txt(file, col)
            df_l = df_l.append(data, ignore_index=True)
            self.add_col(df_l)

    def get_col_per_l_n(self, l, n):
        valexact = [f'{a}_{b}' for a in [l] for b in [n]]
        return [f'{a}_{b}' for a in self.val_option_col for b in valexact]
    
    def pad_with_nan(self, df, is_selected=False):
        if not is_selected:
            nPad = 100 - df.shape[0]
        else:
            nPad = 47 - df.shape[0]

        pad = [np.nan]*nPad
        df = df.append(pd.Series(pad, dtype='float64'), ignore_index=True)
        return df
    
    def round_frame(self, x):
        if x >= 2500:
            return 1
        else:
            return 0

    def round_model(self, x):
        if x >= 250:
            return 1
        else:
            return 0
    
    def process_col(self, df, l, n, is_selected=False):
        # made only for peregrine validated
        col_to_drop = ["total_models", "time_models", "total_frames", "total_valuations", "time_frames"]
        df.drop(col_to_drop, axis=1, inplace=True)
        out = pd.DataFrame(columns=self.get_col_per_l_n(l,n))
        out[f"frame_{l}_{n}"] = self.pad_with_nan(pd.to_numeric(df["frames"]), is_selected)
        # out[f"frame_{l}_{n}_rounded"] = out[f"frame_{l}_{n}_exact"].apply(self.round_frame)
        out[f"model_{l}_{n}"] = self.pad_with_nan(pd.to_numeric(df["models"]), is_selected)
        # out[f"model_{l}_{n}_rounded"] = out[f"model_{l}_{n}_exact"].apply(self.round_model)
        return out


    def extract_validation(self):
        data_col = ["models", "total_models", "time_models", "frames", "total_frames", "total_valuations", "time_frames"]
        for i, language in enumerate(self.languages_col):
            for n in self.nodes_col:
                col = self.get_col_per_l_n(language, n)
                df_ln = pd.DataFrame(columns=col)
                for formulaSet in self.batches:
                    for depth in self.depths:
                        file = os.path.join(self.validated_path, str(language), str(n), f"formulas {formulaSet}", f"depth {depth}.txt")
                        data = self.read_txt(file, data_col)
                        data = self.process_col(data, language, n)
                        df_ln = df_ln.append(data, ignore_index=True)

                file = os.path.join(self.validated_path, str(language), str(n), "formulas 0", "selected.txt")
                data = self.read_txt(file, data_col)
                data = self.process_col(data, language, n, True)
                df_ln = df_ln.append(data, ignore_index=True)
                self.add_col(df_ln)

    def get_trends(self):
        for l in self.languages_col:
            for v in self.val_option_col:
                rows = []
                cols = [f"{v}_{l}_{b}" for b in self.nodes_col]
                for idx, row in self.df[cols].iterrows():
                    y = row.to_numpy().reshape(-1,1)
                    x = np.array(self.nodes_col).reshape(-1,1)
                    model = LinearRegression()
                    model.fit(x ,y)
                    trend = model.coef_
                    # if it is always valid make it 1
                    if trend == 0:
                        if v == "frame":
                            if y[0][0] == 500:
                                trend = 1
                        if v == "model":
                            if y[0][0] == 5000:
                                trend = 1

                    # at this point only negative trends and 0s indicate that not valid
                    if trend > 0:
                        trend = 1
                    else:
                        trend = 0
                    print(row.to_numpy(), trend)
                    rows.append(trend)

                col = f"trend_{l}_{v}"
                df = pd.DataFrame(rows, columns=[col])
                self.add_col(df)
    
    def change_to_bool(self, x):
        if x in ["True", "true", " true", "TRUE", True]:
            return 1
        if x in ["False", "false", " false", "FALSE", False]:
            return 0
        return x

    def convert_to_bool(self):
        self.df = self.df.applymap(self.change_to_bool)

    def save(self, path = os.path.join("Analysis", "dataset.xlsx")):
        self.df.to_excel(path, index=False)
        
    def extract(self):
        self.extract_formulas()
        self.extract_metaData()
        self.extract_asymptotic()
        self.extract_validation() # check the slope, to see if 0 or 1, compare to model checker
        self.convert_to_bool() #convert all true false to 0 1
        self.get_trends()
        print(e.get_df())
        self.save()

        # to get least squares I can use apply rowwise 
        # https://www.delftstack.com/howto/python-pandas/pandas-create-column-based-on-other-columns/

e = Extractor()
e.extract()