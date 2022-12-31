# Simulations of zero-one laws in modal logics GL, S4 and K4

This repository contains the code used for my Bachelor Thesis at the University of Groningen and is supervised by prof. dr. Rineke Verbrugge. The code within allows a user to:
* generate formulas of desired tree depth and maximum modal depth (/src); 
* check if a formula is a tautology or a contradiction (/src);
* simplify modal and propositional formulas to their simplest form (/src);
* check modal and propositional inferences (/src);
* generate models/frames (/src);
* check if a formula is valid in models/frames (/src);
* collect the results and form a coherent dataset (/Analysis);
* analyse the dataset (/Analysis);

Moreover, this repository contains data collected in the experiment (/validated-Peregrine). The generated formulas can be found under /generated, each formula has associated metadata in form: <tautology in **GL**, contradiction in **GL**, tautology in **S4**, contradiction in **S4**, tautology in **K4**, contradiction in **K4**>. Results for the asymptotic experiment are in folder /asymptoticModelExperiment. The list of selected formulas can be found in the main directory.

The link to the final thesis will be added, when it will be uploaded to the repository.

Based on this project a new package was created: **LogicToolkit**, which makes the project's utilities available to wider public. Once the package becomes available on _Julia_ general repository the link will be provided here.

*This is a temporary introduction to LogicToolkit package, proper documentation will follow shortly.

### Abstract
*A zero-one law is a property of modal logics that any formula is either almost always valid or almost always invalid. This property can concern both model validity and frame validity. It has been shown that all modal logics obey zero-one laws regarding model validity. However, in the case of frame validity, only a modal logic **GL** has been successfully proven to have a zero-one law, while several others, such as modal logics **S4** and **K4**, are only hypothesised to obey it. This study aims to empirically confirm the proof for **GL** frames and check whether zero-one laws hold for frames of **S4** and **K4**. To accomplish this, each of 8047 distinct formulas was validated in 5000 randomly generated models and 500 randomly generated frames, in each modal logic. Kleitman and Rothschild's result about almost all finite partial orders was used as a base for generating models and frames. The experiment's results suggest that the above-mentioned modal logics obey zero-one laws for both models and frames.*

