using HTTP
using JSON
using URIParser
using DataFrames

"""
Construct a structure to store the results of the function `GetSpeciesByFamilyId`.
"""
struct GetSpeciesByFamilyIdStruct
    # Dictionary converted from JSON information
    data::Dict
    # Total number of matches
    count::Int
    # Current data page
    page::Int
    # Number of items displayed per page
    limit::Int
    # Refined data frame
    abstract::DataFrame
end

"""
`GetSpeciesByFamilyId(;family_id::String,api_key::String,page::Int=1)`\n
# Description\n
* Query species by family ID and return a list of species.\n
# Parameters\n
* `family_id`:The family ID, a unique value.\n
* `api_key`:The API service key for registered users.\n
* `page`:The page number, an integer not less than 1. Defaults to 1 if not provided.\n
# Results\n
* `result`: A structure of type `GetSpeciesByFamilyIdStruct`.\n
* `result.data`: Dictionary converted from JSON information.\n
* `result.count`: Total number of matches.\n
* `result.page`: Current data page.\n
* `result.limit`: Number of items displayed per page.\n
* `result.abstract`: Refined data frame.\n
# Example
```
using SP2000China;
your_family_id = "F20171000000291";
your_api_key = "Please register an account and obtain an API key";
your_page = 1;
result = GetSpeciesByFamilyId(family_id=your_family_id,api_key=your_api_key,page=your_page);
result.data
result.count
result.page
reult.limit
result.abstract
```
"""
function GetSpeciesByFamilyId(;family_id::String,api_key::String,page::Int=1)
    # Store the base URL
    url = "http://www.sp2000.org.cn/api/v2/getSpeciesByFamilyId"
    # URL-encode the family_id
    encoded_family_id = URIParser.escape(family_id)
    # Build the complete URL request
    response = HTTP.get("$url?apiKey=$api_key&familyId=$encoded_family_id&page=$page")
    # If the HTTP response status code is 200, the request is successful
    if response.status == 200
        # Convert response.body to a string and parse JSON data using JSON.parse
        data = JSON.parse(String(response.body))
        # Total number of matches
        int_count = data["data"]["count"]
        # Current data page
        int_page = data["data"]["page"]
        # Number of items displayed per page
        int_limit = data["data"]["limit"]
        # Extract species information
        species_info = data["data"]["species"]
        # Integrate species information into a data frame
        df_result = DataFrames.DataFrame(scientific_name = String[],
                                        chinese_name = String[],
                                        kingdom = String[],
                                        phylum = String[],
                                        class = String[],
                                        order = String[],
                                        family = String[],
                                        genus = String[],
                                        species = String[])
        # Iterate over species and extract relevant fields
        for species_i in species_info
            # Get the classification information from taxonTree
            taxon = species_i["taxonTree"]
            # Add the extracted information to the data frame
            push!(df_result, (species_i["scientificName"],
                            species_i["chineseName"],
                            taxon["kingdom"],
                            taxon["phylum"],
                            taxon["class"],
                            taxon["order"],
                            taxon["family"],
                            taxon["genus"],
                            taxon["species"]))
        end
        # Construct the result
        result=GetSpeciesByFamilyIdStruct(data,int_count,int_page,int_limit,df_result)
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
