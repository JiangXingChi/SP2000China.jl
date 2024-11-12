using HTTP
using JSON
using URIParser
using DataFrames

"""
Construct a structure to store the results of the function `GetSpeciesByScientificName`.
"""
struct GetSpeciesByScientificNameStruct
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
`GetSpeciesByScientificName(;scientific_name::String,api_key::String,page::Int=1)`\n
# Description\n
* Query by scientific name and return species IDs.\n
# Parameters\n
* `scientific_name`:The scientific name, or a part of it, supporting both Latin and Chinese names.\n
* `api_key`: The API service key for registered users.\n
* `page`: The page number, an integer not less than 1. If not provided, it defaults to 1.\n
# Results\n
* `result`: A structure of type `GetSpeciesByScientificNameStruct`.\n
* `result.data`: Dictionary converted from JSON information.\n
* `result.count`: Total number of matches.\n
* `result.page`: Current data page.\n
* `reult.limit`: Number of items displayed per page.\n
* `result.abstract`: Refined data frame.\n
# Example\n
```
your_scientific_name = "Actinidia arg";
your_api_key = "Please register an account and obtain an API key";
your_page = 1;
result = GetSpeciesByScientificName(scientific_name=your_scientific_name,api_key=your_api_key,page=your_page);
result.data
result.count
result.page
reult.limit
result.abstract
```
"""
function GetSpeciesByScientificName(;scientific_name::String,api_key::String,page::Int=1)
    # Store the base URL for the API
    url = "http://www.sp2000.org.cn/api/v2/getSpeciesByScientificName"
    # URL-encode the scientific_name
    encoded_scientific_name = URIParser.escape(scientific_name)
    # Build the complete URL request
    response = HTTP.get("$url?apiKey=$api_key&scientificName=$encoded_scientific_name&page=$page")
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
        dict_species=data["data"]["species"]
        # Define an empty DataFrame with required columns
        df_result = DataFrames.DataFrame(scientific_name = String[],
                                        chinese_name = String[],
                                        kingdom = String[],
                                        phylum = String[],
                                        class = String[],
                                        order = String[],
                                        family = String[],
                                        genus = String[],
                                        species = String[],
                                        name_code = String[])
        # Iterate over the dictionary and add data
        for species_i in dict_species
            # Get the scientific name
            scientific_name = species_i["accepted_name_info"]["scientificName"]
            # Get the Chinese name
            chinese_name = species_i["accepted_name_info"]["chineseName"]
            # Get the classification information
            taxon = species_i["accepted_name_info"]["taxonTree"]
            kingdom = taxon["kingdom"]
            phylum = taxon["phylum"]
            class = taxon["class"]
            order = taxon["order"]
            family = taxon["family"]
            genus = taxon["genus"]
            species = taxon["species"]
            # Get the scientific name ID
            name_code = species_i["name_code"]
            # Add the data to df_result
            push!(df_result, (scientific_name,
                            chinese_name,
                            kingdom,
                            phylum,
                            class,
                            order,
                            family,
                            genus,
                            species,
                            name_code))
        end
        # Construct the result
        result = GetSpeciesByScientificNameStruct(data,int_count,int_page,int_limit,df_result)
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