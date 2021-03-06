* If user written command randtreat is not installed, install it here
    cap which randtreat
    if _rc ssc install randtreat

* Set up reproducbilitiy - VERSIONING, SORTING and SEEDING
    ieboilstart , v(13.1)    // Version
    `r(version)'             // Version
    sysuse bpwide.dta, clear // Load data
    isid patient, sort       // Sort
    set seed 796683          // Seed - drawn using https://bit.ly/stata-random

* Create strata indicator. The indicator is a categorical variable with
* a different value for each unique combination of gender and age group.
    egen sex_agegroup = group(sex agegrp) , label
    label var sex_agegroup "Strata Gender and Age Group"

* Use the user written command randtreat to randomize when the groups cannot
* be evenly distributed into treatment arms. This is the case here, since
* there are 20 observations in each strata and 6 treatment arms to randomize
* them into. This will always result in two remaining ("misfits") observations
* in each group. randtreat offers different ways to deal with misfits. In this
* example, we use the "global" misfit strategy, meaning that the misfits will
* be randomized into treatment groups so that the sizes of the treatment
* groups are as balanced as possible globally (read the help file for details
* on this and other strategies for misfits). This way we have 6 treatment
* groups with exactly 20 observations in each, and it is randomized which
* group that has an extra observation in each treatment arm.
    randtreat,             ///
        generate(treatment)  /// New variable name
        multiple(6)          /// 6 treatment arms
        strata(sex_agegroup) /// Variable to use as strata
        misfits(global)      /// Misfit strategy if uneven groups

 * Label the treatment variable
    lab var treatment "Treatment Arm"
    lab def treatment 0 "Control" 1 "Treatment 1" 2 "Treatment 2" ///
        3 "Treatment 3" 4 "Treatment 4" 5 "Treatment 5" , replace
    lab val treatment treatment

* Show result of randomization
    tab treatment sex_agegroup
