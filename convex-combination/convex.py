import numpy as np
import matplotlib.pyplot as plt

k = [1,1,1]
N = 1000
x = [-0.5, 0.8, -0.3]
y = [-0.5, 0.6, 0.7]

# convex combination
alpha = np.random.dirichlet(alpha=k, size=N)
x_new = np.matmul(alpha, x)
y_new = np.matmul(alpha, y)

plt.plot(x + [x[0]], y + [y[0]], color='#000000', marker='o', lw=2)
plt.ylim((-1,1))
plt.xlim((-1,1))
plt.scatter(x_new, y_new, color='#76d7c450', edgecolor='none', s=10)
plt.savefig('./convex.svg', format='svg')
plt.close()
