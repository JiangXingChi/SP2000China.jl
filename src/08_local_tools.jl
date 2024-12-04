using DataFrames,ProgressMeter

"""
`Latin2GenusSpecies(latin_text::String)`\n
# Description\n
* Converts a Latin scientific name to an abbreviated form containing only the genus and species names.\n
# Parameters\n
* `latin_text`: Latin scientific name.\n
# Results\n
* `genus_species`: Abbreviated form containing only the genus and species names.\n
# Example\n
```
using SP2000China;
latin_text = "Cotinus coggygria var. pubescens Engl.";
genus_species = Latin2GenusSpecies(latin_text);
println(genus_species)
```
"""
function Latin2GenusSpecies(latin_text::String)
    # Split the words
    latins = split(latin_text, ' ')
    # If there is a subsp. (subspecies) name
    if occursin("subsp.", latin_text)
        # Extract elements 1,2,3,4
        genus_species = join([latins[1], latins[2], latins[3], latins[4]], " ")
    # If there is a var. (variety) name
    elseif occursin("var.", latin_text)
        # Extract elements 1,2,3,4
        genus_species = join([latins[1], latins[2], latins[3], latins[4]], " ")
    else
        # Extract elements 1,2
        genus_species = join([latins[1], latins[2]], " ")
    end
    # Return the text
    return genus_species
end

"""
Construct a structure to store the results of the function `DfSearch`.
"""
struct DfSearchStruct
    # Store the matched DataFrame
    matched::DataFrame
    # Store the unmatched DataFrame
    unmatched::DataFrame
end

"""
`DfSearch(;search_data::DataFrame,search_col::String,source_data::DataFrame,source_col::String)`\n
# Description\n
* Searches for species based on a local database.\n
# Parameters\n
* `search_data`: The DataFrame that needs to be searched.\n
* `search_col`: The column name in the search DataFrame to look for.\n
* `source_data`: The DataFrame of local data.\n
* `source_col`: The column name in the local data DataFrame to look for.\n
# Results\n
* `result`: The merged search results.\n
# Example\n
```
using SP2000China;
using SP2000ChinaData;
using DataFrames;
chinese_names = ["黄顶菊", "虚构植物", "爵床", "菖蒲", "慈姑", "野慈姑"];
sampling_points = ["西藏", "四川", "江苏", "湖北", "广东", "浙江"];
your_search_data = DataFrame(中文名=chinese_names, 采样点=sampling_points);
your_source_data = Plantae();
your_search_col = "中文名";
your_source_col = "物种中文名";
result = DfSearch(search_data=your_search_data,search_col=your_search_col,source_data=your_source_data,source_col=your_source_col);
println(result.matched)
println(result.unmatched)
```
"""
function DfSearch(;search_data::DataFrame,search_col::String,source_data::DataFrame,source_col::String)
    # Perform inner join operation
    matched_df = DataFrames.innerjoin(search_data,source_data,on=search_col=>source_col,matchmissing=:equal)
    # Find values in search_data not present in source_data
    unmatched_values = setdiff(search_data[:,search_col],source_data[:,source_col])
    # Create a DataFrame for unmatched values with column name 'unmatched'
    unmatched_df_1col =  DataFrames.DataFrame(unmatched=unmatched_values)
    unmatched_df = DataFrames.innerjoin(search_data,unmatched_df_1col,on=search_col=>"unmatched",matchmissing=:equal)
    # Store the matched and unmatched DataFrames in a struct
    result = DfSearchStruct(matched_df,unmatched_df)
    # Return the result
    return(result)
end

"""
`StrSearch(;search_str::String,source_data::DataFrame,source_col::String)`\n
# Description\n
* Searches for species based on a local database.\n
# Parameters\n
* `search_str`: The string that needs to be searched.\n
* `source_data`: The DataFrame of local data.\n
* `source_col`: The column name in the local data DataFrame to look for.\n
# Results\n
* `result`: The merged search results.\n
# Example\n
```
using SP2000China;
using SP2000ChinaData;
your_search_str = "慈姑";
your_source_data = Plantae();
your_source_col = "物种中文名";
result = StrSearch(search_str=your_search_str,source_data=your_source_data,source_col=your_source_col);
println(result)
```
"""
function StrSearch(;search_str::String,source_data::DataFrame,source_col::String)
    # Create an empty data frame
    result = DataFrames.DataFrame()
    # Iterate over each row
    @showprogress for row in eachrow(source_data)
        # If the current row's source_col column is not empty
        if ismissing(row[source_col]) == false
            # If search_str is in the current row's source_col column
            if occursin(search_str, row[source_col]) 
                # Add the current row to the result data frame
                result = vcat(result, DataFrames.DataFrame(row))
            end
        end
    end
    # Return the result
    return result
end
