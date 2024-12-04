using Documenter,SP2000China

makedocs(
    modules = [SP2000China],
    sitename = "SP2000China.jl",
    pages = [
        "User's guide" => "index.md",
        "Function" => "function.md",
        "Acknowledgement" => "acknowledgement.md"
    ],
    # remotes = nothing,
    # root = "C:/Users/pandalinux/Desktop/SP2000China/docs"
)

deploydocs(
    repo = "https://github.com/JiangXingChi/SP2000China.jl"
)
