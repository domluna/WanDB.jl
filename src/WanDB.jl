module WanDB

using PyCall

export WanDBLogger, wandb

const wandb = PyNULL()

include("logger.jl")

function __init__()
    copy!(wandb, pyimport("wandb"))
end

end # module
