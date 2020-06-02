using Plots
println("Done importing")
pyplot() # Choose a backend
plot(rand(4,5)) # This will plot to the plot pane
gui()

x = 1:10; y = rand(10, 2) # 2 columns means two lines

plot(x,y, seriestype=:scatter, title="My scatter plot")
