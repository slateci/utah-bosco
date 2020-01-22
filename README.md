# Hosted-CE Config Overrides for Univ of Utah CHPC

## What is this?
The OSG HostedCE is an entrypoint for OSG jobs entering local resources. The CE will accept jobs from the OSG factory and route them appropriately to local resources. In this case, SLURM clusters running at the CHPC.

OSG HostedCEs are deployed locally through [SLATE](https://slateci.io). There is a unique instance of the CE running for each backing cluster at the CHPC (Lonepeak, Kingspeak, and Notchpeak currently). These instances can be managed, stopped, started, and updated using the [SLATE Client](https://slateci.io/docs/tools/index.html) and these overrides.

[BOSCO](https://osg-bosco.github.io/docs/) is a job submission manager responsible for submitting jobs from the HostedCE to the remote cluster. This repository contains configuration overrides for the bosco component. These overrides allow you to set non-standard values for configs such as the slurm binary path, and slurm submission parameters. A component of the CE clones these overrides into a directory on the remote cluster used by BOSCO for job submission.

Additionally, the configuration used by SLATE is stored alongside the bosco overrides. This repository acts a central home and record for all configurations needed by each OSG HostedCE supporting the University of Utah's CHPC. Configuration changes should first be recorded here, then applied to the running instance(s).

## Obtaining and Using the SLATE Client

TODO

## How to Configure

TODO
