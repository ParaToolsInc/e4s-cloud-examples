import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np

# Generate 3D data
x = np.random.rand(100)
y = np.random.rand(100)
z = x**2 + y**2

# Create a 3D scatter plot with Matplotlib
fig = plt.figure(figsize=(8, 6))
ax = fig.add_subplot(111, projection='3d')

# Use Seaborn's style for customization (optional)
sns.set_style("whitegrid")

# Plot the data
ax.scatter(x, y, z, c=z, cmap='viridis', marker='o')

# Customize the plot
ax.set_xlabel('X-axis')
ax.set_ylabel('Y-axis')
ax.set_zlabel('Z-axis')
plt.title('3D Scatter Plot with Seaborn and Matplotlib')

# Show the plot
plt.show()
