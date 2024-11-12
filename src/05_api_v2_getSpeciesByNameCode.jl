using HTTP
using JSON
using URIParser
using DataFrames

"""
Construct a structure to store the results of the function `GetSpeciesByNameCode`.
"""
struct GetSpeciesByNameCodeStruct
    # Store JSON information saved in a dictionary
    data::Dict
    # Store the refined data frame
    abstract::DataFrame
end

"""
`GetSpeciesByNameCode(;name_code::String,api_key::String)`\n
# Description\n
* Retrieve detailed information based on the species ID.\n
# Parameters\n
* `name_code`: The species ID.\n
* `api_key`: The API service key for registered users.\n
# Results\n
* `result`: A structure of type `GetSpeciesByNameCodeStruct`.\n
* `result.data`: Dictionary converted from JSON information.\n
* `result.abstract`: Refined data frame.\n
# Example\n
```
your_name_code = "1ac19d0d82d84dd2900d51a742fa9296";
your_api_key = "Please register an account and obtain an API key";
result = GetSpeciesByNameCode(name_code=your_name_code,api_key=your_api_key);
result.data
result.abstract
```
"""
function GetSpeciesByNameCode(;name_code::String,api_key::String)
    # Store the base URL
    url = "http://www.sp2000.org.cn/api/v2/getSpeciesByNameCode"
    # URL-encode the name_code
    encoded_name_code = URIParser.escape(name_code)
    # Build the complete URL request
    response = HTTP.get("$url?apiKey=$api_key&nameCode=$name_code")
    # If the HTTP response status code is 200, the request is successful
    if response.status == 200
        # Convert response.body to a string and parse JSON data using JSON.parse
        data = JSON.parse(String(response.body))
        # Extract the scientific name
        scientific_name = data["data"]["scientificName"]
        # Extract the Chinese name
        chinese_name = data["data"]["chineseName"]
        # Extract the taxon tree
        taxon_tree = data["data"]["taxonTree"]
        # Create a data frame to store the results
        df_result = DataFrame(scientific_name = [scientific_name],
                    chinese_name = [chinese_name],
                    kingdom = [taxon_tree["kingdom"]],
                    phylum = [taxon_tree["phylum"]],
                    class = [taxon_tree["class"]],
                    order = [taxon_tree["order"]],
                    family = [taxon_tree["family"]],
                    genus = [taxon_tree["genus"]],
                    species = [taxon_tree["species"]])
        # Construct the result
        result = GetSpeciesByNameCodeStruct(data,df_result)
        # Return the result
        return(result)
    # If the HTTP response status code is 400, the request failed
    elseif response.status == 400
        println("Bad request\n","HTTP: ", response.status, "\nDetails:\n",response)
    # If the HTTP response status code is 401, API error
    elseif response.status == 401
        println("API token error\n","HTTP: ", response.status, "\nDetails:\n",response)
    # An unknown error occurred
    else 
        println("Unknown error\n","HTTP: ", response.status, "\nDetails:\n",response)
    end
end