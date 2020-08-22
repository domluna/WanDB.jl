struct WanDBLogger
    run::PyCall.PyObject
    offline::Bool
    anonymous::Bool
end

"""
    WanDBLogger(;
        name::Union{String,Nothing} = nothing,
        project::Union{String,Nothing} = nothing,
        config::Union{Dict,Nothing} = nothing,
        notes::Union{String,Nothing} = nothing,
        tags::Vector{String} = String[],
        dir::Union{String,Nothing} = nothing,
        entity::Union{String,Nothing} = nothing,
        job_type::Union{String,Nothing} = nothing,
        group::Union{String,Nothing} = nothing,
        id::Union{String,Nothing} = nothing,
        reinit::Union{Bool,Nothing} = nothing,
        resume::Union{Bool,Nothing} = nothing,
        anonymous::Bool = false,
        offline::Bool = false,
    )

See https://docs.wandb.com/library/init for reference documentation.

`anonymous` allows anonymous logging.

`offline` disables data being be saved to a W&B server, instead
metadata will be saved locally. This can be synced to the server
later through the CLI.
"""
function WanDBLogger(;
    name::Union{String,Nothing} = nothing,
    project::Union{String,Nothing} = nothing,
    config::Union{Dict,Nothing} = nothing,
    notes::Union{String,Nothing} = nothing,
    tags::Vector{String} = String[],
    dir::Union{String,Nothing} = nothing,
    entity::Union{String,Nothing} = nothing,
    job_type::Union{String,Nothing} = nothing,
    group::Union{String,Nothing} = nothing,
    id::Union{String,Nothing} = nothing,
    reinit::Union{Bool,Nothing} = nothing,
    resume::Union{Bool,Nothing} = nothing,
    anonymous::Bool = false,
    offline::Bool = false,
)
    run = wandb.init(
        name = name,
        project = project,
        config = config,
        notes = notes,
        tags = tags,
        dir = dir,
        job_type = job_type,
        entity = entity,
        group = group,
        id = id,
        reinit = reinit,
        resume = resume,
        anonymous = anonymous ? "allow" : "never",
    )
    offline && (ENV["WANDB_MODE"] = "dryrun")
    WanDBLogger(run, offline, anonymous)
end

project_url(l::WanDBLogger) = l.run.get_project_url()
run_url(l::WanDBLogger) = l.run.get_url()

function Base.show(io::IO, mime::MIME"text/plain", l::WanDBLogger)
    project = l.run.project
    name = l.run.name
    id = l.run.id
    notes = l.run.notes
    save_dir = l.run.dir
    resumed = l.run.resumed
    entity = l.run.entity
    tags = l.run.tags
    job_type = l.run.job_type !== nothing ? l.run.job_type : ""
    group = l.run.group !== nothing ? l.run.group : ""
    notes = l.run.notes !== nothing ? l.run.notes : ""


    str = """
    W&B Experiment running at $(run_url(l))

    Project        $project
    Name           $name
    ID             $id
    Job Type       $job_type
    Save Directory $save_dir
    Resumed        $resumed
    Entity         $entity
    Group          $group
    Tags           $(length(tags) > 0 ? tags : "[]")
    Offline        $(l.offline)
    Anonymous      $(l.anonymous)
    Notes          $notes
    """
    print(io, str)
    return nothing
end

Base.write(l::WanDBLogger, d::Dict{String,<:Any}) = l.run.log(d)
Base.write(l::WanDBLogger, d::Dict{Symbol,<:Any}) = l.run.log(d)
Base.write(l::WanDBLogger; kwargs...) = write(l, Dict(kwargs...))
