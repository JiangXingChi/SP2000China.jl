using DataFrames,ProgressMeter

"""
`Chinese2Latin(;chinese_data::DataFrame,col_name::String,api_key::String,page::Int=1)`\n
# Description\n
* Based on the species Chinese name column provided by the data frame, batch query the scientific names.\n
# Parameters\n
* `chinese_data`: The data frame containing the species' Chinese names.\n
* `col_name`: The name of the column in the data frame where the Chinese names are located.\n
* `api_key`: The API service key for registered users.\n
* `page`: The page number, an integer not less than 1. If not provided, it defaults to 1.\n
# Results\n
* `result`: The data frame that summarizes the basic information after batch querying the Chinese names, with unknown displayed for content that could not be queried.\n
# Example\n
```
using SP2000China;
using DataFrames;
chinese_names = ["黄顶菊", "虚构植物", "爵床", "菖蒲", "慈姑", "野慈姑"];
sampling_point = ["西藏", "四川", "江苏", "湖北", "广东", "浙江"];
your_chinese_data = DataFrame(中文名=chinese_names, 采样点=sampling_point);
println(your_chinese_data)
your_col_name = "中文名";
your_api_key = "Please register an account and obtain an API key";
your_page = 1;
result = Chinese2Latin(chinese_data=your_chinese_data,col_name=your_col_name,api_key=your_api_key,page=your_page);
println(result)
```
"""
function Chinese2Latin(;chinese_data::DataFrame,col_name::String,api_key::String,page::Int=1)
    # Retrieve Chinese names
    chinese_names = chinese_data[:,col_name]
    # Create an empty array to store the results of each filter
    result_list = []
    # Query scientific names through Chinese names
    @showprogress for i in 1:length(chinese_names)
        # Extract the Chinese name from the loop
        chinese_name = string(chinese_names[i])
        # Search results
        search_result = GetSpeciesByScientificName(scientific_name=chinese_name,api_key=api_key,page=page)
        # The network can be queried normally
        if search_result != nothing
            # Filter the rows that meet the conditions
            filtered_row = filter(r -> r.chinese_name == chinese_name, search_result.abstract)
            # Determine if the scientific name was successfully found
            if filtered_row.chinese_name != String[]
                # Add to the results
                push!(result_list,filtered_row)
            else
                # Generate an 'unknown' entry for the results
                unknown_df = DataFrames.DataFrame(scientific_name = "unknown", 
                                                latin_name = "unknown", 
                                                chinese_name = chinese_name, 
                                                kingdom = "unknown", 
                                                phylum = "unknown", 
                                                class = "unknown", 
                                                order = "unknown", 
                                                family = "unknown", 
                                                genus = "unknown", 
                                                species = "unknown", 
                                                name_code = "unknown")
                # Add to the results
                push!(result_list,unknown_df)
            end
        # The network can not be queried normally
        elseif search_result == nothing
            # Generate an 'unknown' entry for the results
            unknown_df = DataFrames.DataFrame(scientific_name = "unknown", 
                                            latin_name = "unknown", 
                                            chinese_name = chinese_name, 
                                            kingdom = "unknown", 
                                            phylum = "unknown", 
                                            class = "unknown", 
                                            order = "unknown", 
                                            family = "unknown", 
                                            genus = "unknown", 
                                            species = "unknown", 
                                            name_code = "unknown")
            # Add to the results
            push!(result_list,unknown_df)
        end
    end
    # Combine all results into a single data frame
    result = vcat(result_list...)
    # Return the result
    return(result)
end

"""
`FindUnknown(all_df::DataFrame)`\n
# Description\n
* Filter out species that were not found in the search from the table.\n
# Parameters\n
* `all_df`: The result after processing by the `Chinese2Latin` function.\n
# Results\n
* `result`: Species that could not be matched in the database are filtered out. Considerations may need to be made for common names and other factors.\n
# Example\n
```
using SP2000China;
using DataFrames;
chinese_names = ["黄顶菊", "虚构植物", "爵床", "菖蒲", "慈姑", "野慈姑"];
sampling_point = ["西藏", "四川", "江苏", "湖北", "广东", "浙江"];
your_chinese_data = DataFrame(中文名=chinese_names, 采样点=sampling_point);
println(your_chinese_data)
your_col_name = "中文名";
your_api_key = "Please register an account and obtain an API key";
your_page = 1;
all_df = Chinese2Latin(chinese_data=your_chinese_data,col_name=your_col_name,api_key=your_api_key,page=your_page);
println(all_df)
result = FindUnknown(all_df);
println(result)
```
"""
function FindUnknown(all_df::DataFrame)
    # Return species that were not found in the database
    result = filter(r -> r.species == "unknown", all_df)
end
