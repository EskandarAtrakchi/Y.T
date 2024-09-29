import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

# Create a figure and axis
fig, ax = plt.subplots()
ax.set_aspect('equal')
ax.set_facecolor('black')

# Hide the axes
ax.set_xticks([])
ax.set_yticks([])

# Number of waves and radial lines
n_waves = 25
n_lines = 500
theta = np.linspace(0, 2 * np.pi, n_lines)

# Initial radius values
radii = np.linspace(0.1, 1, n_waves)

# Create the initial wavy line
lines = []
for r in radii:
    x = r * np.cos(theta)
    y = r * np.sin(theta)
    line, = ax.plot(x, y, color='white', lw=1)
    lines.append(line)

# Function to update the wave movement
def update(frame):
    for i, r in enumerate(radii):
        # Wave oscillation: add a sine function for the ripple effect
        wave_r = r + 0.02 * np.sin(4 * theta - frame / 10.0)
        x = wave_r * np.cos(theta)
        y = wave_r * np.sin(theta)
        lines[i].set_data(x, y)
    return lines

# Create the animation
ani = FuncAnimation(fig, update, frames=200, interval=50, blit=True)

# Show the plot
plt.show()

# pip install matplotlib numpy
