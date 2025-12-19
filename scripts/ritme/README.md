# Feature Representation Optimization using ritme

This folder contains my attempts at running *rimte* for feature representation and model selection optimization when predicting behavioural measures from microbiome data.
[ritme](https://www.biorxiv.org/content/10.64898/2025.12.08.693045v2) was published in ``Target-driven optimization of feature representation and model selection for microbiome sequencing data with ritme'' by Anja Adamov.

**All scripts are currently broken and cannot be executed due to several reasons:**

1. QIIME version conflict with the artifacts created in QIIIME 2025.07, as rimte relies on 2024.10. This will be an easy fix by exporting and importing the data. 
2. I run into ray related errors when running on Euler, even after extensive debugging and trying multiple approaches. The ray head node crashes without exception and therefore does not allow the worker nodes to connect. This is more difficult to debug, as SLURM support in ray 2.46 is not perfect. As Anja confirmed executability of the test scripts presented in the paper, this must be a solvable.

I have been in contact with the author of this framework concerning this and will definitely try to get it running to provide some feedback.
But as time has run out on me, this will not be included in the final submission of the semester project.
