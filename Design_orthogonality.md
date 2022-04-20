## Collinearity

We just saw that the most efficient design was the Classic Oddball. However, is this the best design to also ensure that our two conditions, std and dev, are as uncorrelated as possible? To answer this question, we need to estimate to what extent our two conditions are collinear (correlate with each other): in fact, if we were to find that std and dev are highly collinear in the Classic Oddball design, then we could not confidently attribute the observed BOLD signal changes to one regressor, as it could be that the other regressor also played a role in that change. We then need to choose the design that minimizes collinearity between our conditions. 

## Estimating collinearity in SPM12: tutorial
SPM provides a simple and easy way to calculate the degree of collinearity between regressors.

### Select the right module

1) Open spm > fMRI > Batch 
2) In the upper menu click on SPM > Stats > fMRI model specification (design only)

### Fill in the module

The parameters we need to specify are the following (those not mentioned we do not edit):

- Directory
- Timing parameters: Units for design (seconds), Interscan Interval (i.e. TR, 2s in our case) 
- Data & Design: Number of scans (300, i.e. 900s/2)
- Conditions: we specify 2 conditions, i.e. std and dev. For each of them, we input the onset vector under "Onsets" (remember: you must have the onset vector loaded in your matlab workspace for SPM to recognize it); 0.05 under "Durations", i.e., it's the duration of our sounds (always 0.05 s). To add another condition, right click on "Conditions" > Replicate item > Condition (1): remember to change the vector of onsets with the one related to the second condition!

I uploaded the batches already filled out (files "Collinearity_job_classic" and "Collinearity_job_roving"). So you can also simply click on spm > fMRI > Batches > File > Load Batch > e.g., Collinearity_job_classic. In these files, for the onsets, I took those of the first simulation (i.e.: onset_dev_classic = onset_dev_classic{1, 1} and so on).
 
Once you've filled out the module (or uploaded mine) click on the green triangle at the top left, spm will generate an SPM.mat file in the directory you specified.

### Review the results

spm menu > Review > SPM.mat (previously generated)

The first window that pops up is the design matrix (here design matrix for the classic oddball):

<p align="center">
<img width="482" alt="image" src="https://user-images.githubusercontent.com/103193288/164301977-ba219efe-ad4a-4263-81b0-d728013c42e0.png">
</p>

To check the degree of collinearity between our conditions, click on "Design" in the small grey square window (it should appear together with the big one where you see the design matrix) > Design Orthogonality: 

<p align="center"> Design Orthogonality - Classic </p>
<p align="center">
<img width="277" alt="image" src="https://user-images.githubusercontent.com/103193288/164306473-36b8c7df-75f9-41fa-8944-1967404dcde5.png">
</p>

In the design orthogonality matrix, you can see illustrated the degree of collinearity for all possible combinations of your conditions: if the square is black (as you can read from the caption under the figure), it means that two conditions are higly correlated, e.g. the first square on the left is black because the dev condition is highly correlated with itself (dev condition, first to the right of the design orthogonality matrix). Gray squares indicate that two given conditions are not collinear, i.e., the lighter/brighter the gray and the less collinear the two conditions are. 
In this study, we are interested in the std-dev contrast, i.e. we want to see the extent to which these two conditions are collinear. Therefore, we look at the intersection square between these two conditions, the square circled in blue, which is gray. Let's now compare this design orthogonality matrix with the one for the roving: 

<p align="center"> Design Orthogonality - Roving </p>
<p align="center">
<img width="301" alt="image" src="https://user-images.githubusercontent.com/103193288/164306563-c7758b61-b2a9-42f1-8bb0-66a842425643.png">
</p>

The square circled in blue in the Roving Design Orthogonality matrix is a brighter gray than that of the Classic. Thus, we conclude that in terms of collinearity, Roving performs better than Classic. And this might be because, in the Roving, the std and dev events are spaced further apart, as the number of repetitions of std events is greater than in the Classic.

Before deciding which design to employ, let's check one last thing: from the same gray small window click on Design > Explore > Session 1 > Dev (or Std).

Here (left, roving oddball; right, classic oddball), in addition to the time series of the “dev” regressor (top left) and the canonical hrf used to convert assumed neuronal activity into hemodynamic activity (bottom right), we can look at the frequency content of the dev regressor: the frequency domain plot (top right) shows that the frequency content of the “dev” regressor is almost completely above the set frequencies that are removed by the High Pass Filter (HPF) - these are shown in gray - in the roving oddball but not in the classic. In the classic, in fact, some frequency is cut out. (Ref: SPM12 manual, p.235)

<p align="center">
<img width="602" alt="image" src="https://user-images.githubusercontent.com/103193288/164308664-f2581a03-b25b-4f52-82d8-ae87e70fefe0.png">
</p>

We can conclude that the Classic design is better in terms of efficiency but worse in terms of collinearity and frequency than the Roving design. In our case, we decided to create a hybrid version of the two: a classic oddball with randomized repetition of standards between 3 and 5. In this way, we found a compromise between efficiency, collinearity and frequency.

## Appendix

### Fill the SPM module to estimate collinearity with med, max, and min distribuitions of onsets

Before, when we filled the SPM batch, we randomly took the first (out of 1000) onsets simulation and checked the orthogonality matrix. To be more precise, we can also enter, under "onsets" for both conditions, the onsets of the median, maximum, and minimum distributions of efficiency values of the 1000 simulations of each design. That is, we identify the indices of the med, min, and max in the efficiency distribution (1000 values). These indices correspond to the number of the simulation (see Fig. 1). We can therefore input the corresponding simulation of onsets in SPM, resulting in three potential comparisons: the “max” simulation of onsets for the roving vs the “max” simulation of onsets for the classic; the “min” simulation of onsets for the roving vs the “min” simulation of onsets for the classic; the “median” simulation of onsets for the roving vs the “median” simulation of onsets for the classic. 

Here, as an example, I plotted the distribution of efficiency values for contrast std-dev (Roving):

<p align="center">
<img width="572" alt="image" src="https://user-images.githubusercontent.com/103193288/164314255-212de29a-9502-451b-8185-2bbbda884140.png">
</p>

To generate med, min and max onsets I uploaded the script "Collinearity_SPM". Once the onsets are generated, you can refill the batch and repeat the procedure described above.
