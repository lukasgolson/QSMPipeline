script_path <- dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(script_path)

here::i_am("main.R")
library(here)

library(aRchi)
library(lidR)

library(RCSF)

library(rayshader)


# Load point cloud
pcl_filepath <- here("test.las")
las <- readLAS(pcl_filepath)
las_check(las)
las <- decimate_points(las, homogenize(24,0.5))

plot(las)

# Seperate trees from terrain


las <- classify_ground(las, algorithm = pmf(ws = 5, th = 3))



# Extract tree points
tree_points <- filter_poi(las, Classification != 2L)


#plot_3d(map, elmat, zscale = 1, windowsize = c(800, 800))

# Construct QSM

downsampled_tree_points <- decimate_points(tree_points, homogenize(24,1))


plot(downsampled_tree_points, color = "RGB", axis = TRUE, legend = TRUE)

aRchi = aRchi::build_aRchi()
aRchi = aRchi::add_pointcloud(aRchi, point_cloud = downsampled_tree_points)

aRchi = skeletonize_pc(aRchi, D = 0.75, cl_dist = 0.5, max_d = 1)

aRchi = smooth_skeleton(aRchi)

aRchi = simplify_skeleton(aRchi)


plot(aRchi,show_point_cloud = TRUE)
