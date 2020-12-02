from datetime import datetime
import pandas as pd
import numpy as np
from scipy.optimize import minimize
from scipy.stats import norm

print('Running simulation...')

data = pd.read_csv('data.csv')
x = data['x']

# MLE (minimization problem turned into a maximization problem)
def objective_function(params, x):
    log_likelihood = 0.0
    for value in x:
        log_likelihood += np.log(norm.pdf(value, params[0], params[1]))
    return(-log_likelihood)

bnds = ((None, None), (0.5, None))
result = minimize(fun=objective_function, x0=[0.5,0.5], bounds=bnds, args=(x))
result = dict(result)

with open('./mle_result.txt', "w") as f:
    f.write('Timestamp: {0}\n'.format(datetime.now()))
    for key, value in result.items():
        f.write('{0}: {1}\n'.format(key, value))

print('Data: mean [{0}], sd [{1}]'.format(np.mean(x), np.std(x)))
print('MLE: mean [{0}], sd [{1}]'.format(result['x'][0], result['x'][1]))
print('... complete')
