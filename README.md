# CHARM-image-analysis
The code for image analysis in the CHARM manuscript.

1. Nucleic acid dye penetration
- import.ipynb: import image from LIF file and store the metadata
- analyze_penetration_2.m: create image mask, analyse dye intensity decay, penetration distance
- analyze_homogeneity.m: create image mask, analyse dye intensity variation
- wrapped_2: call analyze_penetration_2, plot graph
- wrapped_homogeneity: call analyze_homogeneity, plot graph

2. Colour conversion
- import.ipynb: import image from LIF file and store the metadata
- matlab_crosstalk_2.mlx: convert fluorescent colour to bright-field H&E colour
- rgb_to_matlab.ipynb: format conversion
- matlab_colour_transfer_4.mlx: perform MKL colour transfer
- matlab_resize_5.mlx: resize the image

3. Liver histology analysis
- 3d_training.ipynb: cellpose 2 3D training
- nucleus_training_and_tune_parameters: cellpose 3 3D nucleus training
- pipeline_python: perform cell and nucleus segmentation and mask post-processing
- python_matlab: format conversion
- matlab_modefilt_11: perform modefilt
- matlab_region_12: analyse number of nuclei in each cell, total nuclear intensity, morphological parameters
- matlab_vessel_13: segment vessel
- matlab_analyse_15: add zonation information
- matlab_regression_16: analyse polyploidy and perform regression analysis
- matlab_2d_18: extract 2D planes and store information
- matlab_regression_2d_20: analyse polyploidy in 2D
- matlab_voronoi_21: analyse 3D liver lobule structure with Voronoi diagram

Helper functions
- All helper functions are stored in this folder
