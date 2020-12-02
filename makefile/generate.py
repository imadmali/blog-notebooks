import pandas as pd
import numpy as np

N = 10
data = pd.DataFrame({'x': np.random.normal(3, 1, N)})

data.to_csv('./data.csv', index=False)
