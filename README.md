<h1>Efficiency estimation: comparison of two fMRI mixed designs</h1>

This information was compiled with the help of Prof. Christophe Phillips and Prof. Melanie Boly

## Efficiency: what it is and why its a priori estimation is important 

When designing an fMRI study, a good practice is to estimate the efficiency of the design a priori. This way, one can compare different designs and choose the most efficient one. The efficiency is defined as "a measure of how reliable [an estimator] is and depends on error variance (the variance not modeled by explanatory variables in the design matrix) and the design variance (a function of the explanatory variables and the contrast tested). Changes in the experimental design can induce changes in the variance of estimated responses" (Mechelli, Andrea et al., NeuroImage vol. 18,3 (2003), doi:10.1016/s1053-8119(02)00040-x). 

Please note that the efficiency calculation is related to the number of scans (i.e., to a given TR and duration of the experiment), and specific to a given contrast. Thus, you cannot compare in terms of efficiency designs with different numbers of scans or designs with different contrasts.

## Scope of this project and what is in this repository 
The purpose of this project is to provide a beginner's guide on how to perform efficiency analysis given two (or more) designs. 
Here we provide an example of estimation (and comparison) of the efficiency of two mixed fMRI designs. The goal is to choose the design in which the timing of the stimuli is most efficient in detecting the investigated effects. You will find 

- a code to calculate efficiency ("Efficiency_Analysis") 

- a folder with onsets generator functions (folder name: "Onsets_Generator"), needed to generate onsets for each of our two designs (used in the "Efficiency_Analysis" script)

- onsets already generated for both conditions (in case you don't want to run the functions yourself): i.e., "Onsets_Classic.mat" and "Onsets_Roving.mat"

- a function to generate the canonical hrf, used in the "Efficiency_Analysis" script, i.e. "spm_hrf.m"

- another readme file titled "Design_orthogonality" and other files starting with "Collinearity..": in these documents, I give a brief tutorial on how to estimate the degree of collinearity between regressors using SPM12. In fact, when deciding between two designs, apart from efficiency considerations, it is important to also take into account the degree of collinearity between the conditions. Collinearity indicates the degree to which two separate conditions correlate or, in other words, "collinearity occurs when there is pairwise correlation between either single regressors or linear combinations of multiple regressor" (Mumford, Jeanette et al. (2015)). For more info on collinearity and design orthogonality, see "Design_orthogonality.md" .

In what follows, we will describe in detail our fMRI experimental design, so as to give a context to our codes and make them easier to understand.

## Experimental design
In this example, we chose a mixed block/event-related design. Such a design allows for the simultaneous modelling of the transient, trial-related activity, and the sustained, task-related BOLD activity. That is, by alternating control blocks (silence blocks) with task blocks (where we deliver sounds) we can model the HRF for different types of events within each trial and the HRF for all events combined:
<p align="center">
<img width="611" alt="image" src="https://user-images.githubusercontent.com/103193288/162635771-e2bf083b-0d0c-4840-9423-abb035c713a2.png">
</p>
Each "task" block (i.e., where sounds are delivered) lasts 45 s, and the length of each silence block is jittered in 1 s steps over a 7-10 s range. The total length of auditory stimulation is 15 minutes (900 s). In the task blocks, the sounds are delivered according to two different rules, resulting in two different patterns of auditory stimulation, i.e., design1 and design2. Here we want to estimate the efficiency of these two designs and see which one is best.

### Design1 = Classic oddball
In Design1, in each 45s-task block, we provide a series of trials consisting of 5 events each, which follow the classic oddball rule: that is, we establish a regularity by repeating the same sound (i.e., with the same frequency) 4 times. Then, the established regularity is disrupted by introducing a deviant sound - also called an "oddball" - which will deviate from the previous sounds, being of a different frequency (in the fig., the blue cross). Each event (both standard and deviant sounds) lasts 0.05s. Within the trial, events are spaced by an ISI of 0.1s. Trials are instead spaced out by an ITI in steps of 0.05s in an interval of 0.7 – 1s: 

<p align="center">
  
<img width="348" alt="image" src="https://user-images.githubusercontent.com/103193288/162636015-808ef662-b08c-4dbd-949f-243631ac5d47.png">
<img width="229" alt="image" src="https://user-images.githubusercontent.com/103193288/162636323-943767f4-df4b-4be5-94b1-48b06f43ef9c.png">
</p>

To improve the detection of the effect we are most interested in (i.e., difference between standard and deviant sounds), we decided to space out the deviant sounds by introducing blocks composed only of standard sounds (all of the same frequency). This means that we intersperse task blocks composed of the above trials (see Figure above) and blocks composed only of standard sounds. In the latter blocks, all previous parameters are maintained (ISI, ITI, duration of each sound, etc.) with the only difference being that the fifth sound is not of a different frequency than the previous four. In the figure below, you can see 9 lines, each representing a task block. The white spaces between each block (i.e., line) are the silence blocks of jittered length 7-10s. Red-only lines are task blocks composed only of standard trials (trials composed only of standard events); red lines overlaid with blue crosses are blocks composed of deviant trials (trials composed of 4 standard sounds followed by one deviant sound).

<p align="center">

<img width="469" alt="image" src="https://user-images.githubusercontent.com/103193288/162636408-d144f14c-5c35-4905-a37a-1796c6388002.png">
</p>

Standard (red line) and deviant (red line with blue crosses) blocks can be alternated in two ways: they can be interleaved (ABABAB..) or the order can be pseudorandomized (ABBA..). Here, for both designs, we adopted the order "abba", i.e., a pseudorandomized order in which not more than 2 identical types of blocks can follow each other::

<p align="center">
<img width="403" alt="image" src="https://user-images.githubusercontent.com/103193288/162636478-78a27677-2d34-4367-acda-6daf16d76e5e.png">
</p>

Is this the most efficient design to detect the difference between std and dev events?

### Design2 = Roving oddball

In Design2, in each 45s-task block, we provide a series of trials consisting of a variable number of events, from 1 to 11. These trials follow the roving oddball rule: that is, in each trial, all sounds are of the same frequency, but the first event of a trial is deviant since it is of a different frequency compared to the frequency used in the precedent trial. In other words, the deviant becomes eventually a standard as a result of being presented multiple times. To get a schematic representation of the roving oddball paradigm, see the figures below: 

<p align="center">
<img width="333" alt="image" src="https://user-images.githubusercontent.com/103193288/162636628-e5d1468f-ef1f-437f-90e5-555b4c0c52b8.png">
<img width="167" alt="image" src="https://user-images.githubusercontent.com/103193288/162636750-6293b693-eb74-4815-9a49-605fbd496da4.png">
</p> 

As in the previous model, each event lasts 0.05s. Within the trial, events are spaced by an ISI of 0.1s. Trials are spaced out by an ITI in steps of 0.05s in an interval of 0.7 – 1s. Also in this model, we alternate standard-only task blocks with deviant task blocks, according to the previously described ordering, i.e., pseudorandomized (ABBA).

Our question is simple: which of the two designs is more efficient for estimating the difference between deviant and standard events?

## Efficiency results
We first simulated 1000 distribution of onsets for each design, given that in each design iti and the length of silence blocks is jittered. Next, we computed the efficiency (output = one value) for each of the 1000 onsets simulations for design1 and design2. We computed efficiency for three contrasts:

- std =[1 0]; % main effect std 
- dev =[0 1]; % main effect dev
- diff = [-1 1]; %std - dev

This resulted in a distribution of 1000 efficiency values (i.e., a distribuition of 1000 values for each contrast): e.g., 1000 efficiency values for contrast "diff"= std - dev, for the roving oddball; 1000 efficiency values for contrast "diff" = std - dev for the classic oddball.. and so on). For more info on methods take a look at the "Efficiency_Analysis" script, where each step of the analysis is explained in the comments.

We concluded that (as you will see for yourself), in terms of efficiency, the best design is design1:

<p align="center">
<img width="494" alt="image" src="https://user-images.githubusercontent.com/103193288/162638114-4cfa2931-cf54-47a1-b4b4-986b81a611ea.png">
</p> 

In the figure above, we can indeed see that the distribution of efficiency values for the contrast "diff" (i.e., std-dev) is higher for the classic than for the roving oddball. We also see that the classic has more upper adjacent outliers. Let's take a look at their distributions:

<p align="center">
<img width="464" alt="image" src="https://user-images.githubusercontent.com/103193288/162638129-e14e546d-4782-46e3-a7d1-acc552eeced0.png">
</p> 

As can be seen from the last figure, the mean of the distribution of efficiency values for the classical oddball is higher than that for the roving.



## References:

For a general introduction to efficiency: 
Mechelli, Andrea et al. (2003). Estimating efficiency a priori: A comparison of blocked and randomized designs. Mechelli, A. and Price, C.J. and Henson, R.N. and Friston, K.J. (2003) Estimating efficiency a priori: a comparison of blocked and randomized designs. NeuroImage, 18 (3). pp.798 - 805 . ISSN 10538119. 18. 10.1016/S1053-8119(02)00040-X. 

For the "classic" oddball (only local effect):
Bekinschtein, Tristan et al. (2009). Neural signature of the conscious processing of auditory regularities. Proceedings of the National Academy of Sciences of the United States of America. 106. 1672-7. 10.1073/pnas.0809667106. 

For the roving oddball: 
Garrido, Marta et al. (2008). The functional anatomy of the MMN: A DCM study of the roving paradigm. NeuroImage. 42. 936-44. 10.1016/j.neuroimage.2008.05.018. 

For an accessible and practical introduction to efficiency analysis, watch Prof. Jeanette Mumford's video series:
https://www.youtube.com/playlist?list=PLB2iAtgpI4YEnBdb_jDGmMcdGoIBwhCCY

On collinearity and orthogonalization: Mumford, Jeanette et al. (2015). Orthogonalization of Regressors in fMRI Models. PLOS ONE. 10. e0126255. 10.1371/journal.pone.0126255. 

