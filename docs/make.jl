using Documenter
using SP2000China

makedocs(
    modules = [SP2000China],
    sitename = "SP2000China.jl",
    pages = [
        "User's guide" => "index.md",
        "Function" => "function.md",
        "Acknowledgement" => "acknowledgement.md"
    ]
)
