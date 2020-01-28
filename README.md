# Hosted-CE Config Overrides for Univ of Utah CHPC

## What is this?
The [OSG HostedCE](https://opensciencegrid.org/docs/compute-element/htcondor-ce-overview/) is an entrypoint for OSG jobs entering local resources. The CE will accept jobs from the OSG factory and route them appropriately to the local compute resources. In this case, SLURM clusters running at the CHPC.

OSG HostedCEs are deployed locally through [SLATE](https://slateci.io). There is a unique instance of the CE running for each backing cluster at the CHPC (Lonepeak, Kingspeak, and Notchpeak currently). These instances can be managed, stopped, started, and updated using the [SLATE Client](https://slateci.io/docs/tools/index.html) and these overrides.

[BOSCO](https://osg-bosco.github.io/docs/) is a job submission manager responsible for submitting jobs from the HostedCE to the remote cluster. This repository contains configuration overrides for the bosco component. These overrides allow you to set non-standard values for configs such as the slurm binary path, and slurm submission parameters. A component of the CE clones this repository into a directory on the remote cluster used by BOSCO for job submission.

Additionally, the configuration used by SLATE is stored alongside the bosco overrides. This repository acts a central home and record for all configurations needed by each OSG HostedCE supporting the University of Utah's CHPC. Configuration changes should first be recorded here, then applied to the running instance(s).

## Obtaining and Using the SLATE Client

In order to interact with the local CE instances you must obtain the SLATE Client and valid SLATE group membership for the group `uu-chpc-ops`. This will allow you to manage these instance using SLATE.

First hop over to https://portal.slateci.io/cli and sign in using your institutional credentials. This will create your SLATE account. From here you can copy and paste the script into your local environment to add your SLATE user credentials (A SLATE Token and API Endpoint). These are simple text files that the SLATE Client expects to find under `$HOME/.slate/`.

Next download the client following the instructions on that same page. Once this is done you should be able to see some clusters by running `slate cluster list`.

Then hop over to https://portal.slateci.io/public_groups/slate-dev and request to join the group. Once this request is fulfilled you will have full access to manage the OSG HostedCE instances supporting CHPC.

Full reference on the SLATE Client CLI can be found at [SLATE Client Manual](https://github.com/slateci/slate-client-server/blob/master/resources/docs/client_manual.md)

### Find instance IDs

You can view instances running on Utah's SLATE cluster with the command

`slate instance list --cluster uutah-prod`

```
Name                      Group     ID
condor-login              slate-dev instance_sVzib4wBWQs
osg-frontier-squid-global slate-dev instance_OnT-sClDSiU
osg-hosted-ce-kingspeak   slate-dev instance_4shGbDGoB6w
osg-hosted-ce-notchpeak   slate-dev instance_Vyir_kuBf3Q
```

We are specifically interested in the instances of HostedCE so 

`slate instance list --cluster uutah-prod |grep osg-hosted-ce`

Each instance will have a helpful label to determine which backing cluster it is attached to.

```
osg-hosted-ce-kingspeak   slate-dev instance_4shGbDGoB6w
osg-hosted-ce-notchpeak   slate-dev instance_Vyir_kuBf3Q
```

The last column of this entry gives us the SLATE Instance ID, which we need to manage the instance. 

### Pausing and Un-pausing Instances

An instance can be paused by running `slate instane scale --replicas 0 <SLATE INSTANCE ID>`

The instance can be unpaused by running `slate instance scale --replicas 1 <SLATE INSTANCE ID>`

### Restarting and Updates

You can do a simple restart of the instance by running `slate instance restart <SLATE INSTANCE ID>`

Restarting will also obtain container software updates automatically

### Removing Instances

You can delete the instance by running `slate instance delete <SLATE INSTANCE ID>`

### Viewing CE Logs

To view instance specific logs run `slate instance logs <SLATE INSTANCE ID> --max-lines 0`

*the --max-lines=0 flag prevents truncated output*

You will be able to view the logs for two different containers that make up this deployment. One is the CE itself, and will contain all the STDOUT and STDERR for that container. However, the daemons that make up the CE log to various files as well. The second container is a log exporter for these special logs. It will print its random generated credentials out to the SLATE instance logs that we viewed with the command above. Using those credentials we can sign into the log exporter using a web browser. 

[sl-uu-hce1.slateci.io:8080](http://sl-uu-hce1.slateci.io:8080)

[sl-uu-hce2.slateci.io:8080](http://sl-uu-hce1.slateci.io:8080)

[sl-uu-hce3.slateci.io:8080](http://sl-uu-hce1.slateci.io:8080)

## How to Configure

There is a complete repository of bosco files elgible to be override including scripts and configs. You can copy new overrides from there.

https://github.com/slateci/bosco-override-template

Most configurations are available in `<RESOURCE>/bosco-override/glite/etc/blah.config`

SBATCH Parameters can be editted in `<RESOURCE>/bosco-override/glite/etc/blahp/slurm_local_submit_attributes.sh`

New overrides coppied from the template must be placed in the approppriate sub directory under `<RESOURCE>/bosco-override/` for the cluster that needs to be patched. Here Resource corresponds directly to a CHPC compute cluster.

Once the repository is updated simply restart the instance in question.

`slate instance restart <SLATE INSTANCE ID>`

Please leave a helpful reason in the commit message for your change.

In order to make changes to the SLATE configuration itself (found in <RESOURCE NAME>/<RESOURCE NAME>_slate_values.yaml)
  
You must delete the existing instance

`slate instance delete <SLATE INSTANCE ID>`

Commit your changes to this repository with a helpful commit message

Clone the changes to your local environment (where you have the SLATE Client installed)

`git clone https://github.com/slateci/utah-bosco.git`

Install a new SLATE instance with the updated config

`slate app install osg-hosted-ce --cluster uutah-prod --group slate-dev --dev --conf utah-bosco/<RESOURCE NAME>/<RESOURCE_NAME>_slate_valuess.yaml`

This is all that is needed to make any configuration changes to the SLATE HostedCE instances at CHPC.

## Reference and Additional Docs

*Main application documentation*

https://portal.slateci.io/applications/incubator/osg-hosted-ce

*SLATE Client manual*

https://github.com/slateci/slate-client-server/blob/master/resources/docs/client_manual.md

*Bosco override full template*

https://github.com/slateci/bosco-override-template

*Blog following original deployment of these specific instances*

https://slateci.io/blog/2020-01-22-deploy-hosted-ce.html

*OSG Guide to Troubleshooting CEs*

https://opensciencegrid.org/docs/compute-element/troubleshoot-htcondor-ce/

*OSG Overview of CE*

https://opensciencegrid.org/docs/compute-element/htcondor-ce-overview/

*HTCondor Manual on the Job Router*

https://research.cs.wisc.edu/htcondor/manual/v8.6/5_4HTCondor_Job.html
