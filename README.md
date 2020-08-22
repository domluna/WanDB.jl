# WanDB.jl

Provides a lightweight wrapper around the official Python API for [Weights & Biases](https://www.wandb.com/).

### Quickstart

```julia
julia> using WanDB

julia> logger = WanDBLogger(project="my-project", name="experiment1")
wandb: Tracking run with wandb version 0.9.5
wandb: Run data is saved locally in wandb/run-20200822_140536-zs4ty7cp
wandb: Syncing run experiment1
wandb: ⭐️ View project at https://app.wandb.ai/domluna/my-project
wandb: 🚀 View run at https://app.wandb.ai/domluna/my-project/runs/zs4ty7cp
wandb: Run `wandb off` to turn off syncing.

W&B Experiment running at https://app.wandb.ai/domluna/my-project/runs/zs4ty7cp

Project        my-project
Name           experiment1
ID             zs4ty7cp
Job Type
Save Directory /home/domluna/.julia/dev/WanDB/wandb/run-20200822_140536-zs4ty7cp
Resumed        false
Entity         nothing
Group
Tags           []
Offline        false
Anonymous      false
Notes

julia> write(logger, value1=1)

julia> for i in 2:10
           write(logger, value1=i)
       end

julia>

julia> img = wandb.Image(rand(1:255, 255, 255, 3))
PyObject <wandb.data_types.Image object at 0x7fb6e667aa10>

julia> write(logger, myimg=img)
```

You can see the output for the logs for the sample above project [here](https://app.wandb.ai/domluna/my-project?workspace=user-domluna).

### Additional Reference

`wandb` implements its own types for various data structures such as images, audio, data tables, etc.
Details on how to log these types can be found [here](https://docs.wandb.com/library/log). Usaully you
can pass the equivalent Julia type into the function and it'll work as you would expect.
