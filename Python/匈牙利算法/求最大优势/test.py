import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

d = np.zeros(100)
# algos = [tspsom, Mtspsom, Stspsom, Ctspsom, Dtspsom, ICtspsom, IDtspsom]
for i in range(100):
    d[i] = i + 1

print(np.min((-1, 2)))
fig = plt.figure()
plt.rcParams['font.sans-serif'] = ['SimHei']
plt.rcParams['axes.unicode_minus'] = False

plt.plot(d, linewidth=1)
plt.xlabel("steps")
plt.ylabel(r'$\gamma_\sigma$ = 0.9')
plt.savefig("iter.png", dpi=600, bbox_inches='tight')
plt.show()

plt.show()
