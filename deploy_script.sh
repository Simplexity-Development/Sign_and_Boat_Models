#!/bin/bash
calculate_hashes() {
    file_path=$1
    sha256_hash=$(sha256sum "$file_path" | awk '{ print $1 }')
    sha512_hash=$(sha512sum "$file_path" | awk '{ print $1 }')
    echo "$sha256_hash" "$sha512_hash"
}
 Function to compare versions
compare_versions() {
    version1=$1
    version2=$2
    if [[ $version1 == "$version2" ]]; then
        return 0  # Versions are equal
    elif [[ $version1 > $version2 ]]; then
        return 1  # version1 is greater
    else
        return 2  # version2 is greater
    fi
}

# Read JSON file
packs_json="packs.json"  # Adjust the JSON file path as needed
universal_json="universal_variables.json"
data=$(cat "$packs_json")
universal_data=$(cat "$universal_json")



# Universal variables
featured=$(echo "$universal_data" | jq -r '.universal_variables.featured')
echo "UNIVERSAL VARIABLES INFO: 'featured' = $featured"
dependencies=$(echo "$universal_data" | jq -r '.universal_variables.dependencies')
echo "UNIVERSAL VARIABLES INFO: 'dependencies' = $dependencies"
loaders=$(echo "$universal_data" | jq -r '.universal_variables.loaders')
echo "UNIVERSAL VARIABLES INFO: 'loaders' = $loaders"
primary=$(echo "$universal_data" | jq -r '.universal_variables.primary')
echo "UNIVERSAL VARIABLES INFO: 'primary' = $primary"

echo "RAW JSON DATA:"
echo "$data"

# Iterate over packs
for pack in $(echo "$data" | jq -r '.packs | keys[]'); do
    echo "STARTING ITERATION OVER PACK - PACK VARIABLES:"
    index_number="$pack"
    echo "PACK VARIABLES INFO: 'index_number' = $index_number"
    pack_data=$(echo "$data" | jq -r ".packs[$pack]")
    echo "PACK VARIABLES INFO: 'pack_data' = $pack_data"
    directory_name=$(echo "$pack_data" | jq -r ".directory_name")
    echo "PACK VARIABLES INFO: 'directory_name' = $directory_name"
    version_number=$(echo "$pack_data" | jq -r ".version_number")
    echo "PACK VARIABLES INFO: 'version_number' = $version_number"
    changelog=$(echo "$pack_data" | jq -r ".changelog")
    echo "PACK VARIABLES INFO: 'changelog' = $changelog"
    game_versions=$(echo "$pack_data" | jq -r ".game_versions | join(\", \")")
    echo "PACK VARIABLES INFO: 'game_versions' = $game_versions"
    version_type=$(echo "$pack_data" | jq -r '.version_type')
    echo "PACK VARIABLES INFO: 'version_type' = $version_type"
    project_id=$(echo "$pack_data" | jq -r ".project_id")
    echo "PACK VARIABLES INFO: 'project_id' = $project_id"

     # Create zip file
    zip_filename="${directory_name}_${version_number}.zip"
    echo "ZIP INFO: 'zip_filename' = $zip_filename"
    pushd "$directory_name" || exit  # Move into the directory
    zip -r "../$zip_filename" ./*  # Include only the contents of the directory
    popd || exit  # Move back to the original directory

    # Calculate size of the zip file
    zip_size=$(du -b "$zip_filename" | awk '{ print $1 }')
    echo "ZIP INFO: 'zip_size' = $zip_size"


    # Calculate hashes for the zip file
    hashes=("$(calculate_hashes "$zip_filename")")
    sha256_hash=${hashes[0]}
    sha512_hash=${hashes[1]}

    #Construct the data for the POST request
    post_data=$(jq -n \
            --arg directory_name "$directory_name" \
            --arg version_number "$version_number" \
            --arg dependencies "$dependencies" \
            --arg game_versions "$game_versions" \
            --arg version_type "$version_type" \
            --arg changelog "$changelog" \
            --arg loaders "$loaders" \
            --arg featured "$featured" \
            --arg filename "$zip_filename" \
            --arg primary "$primary" \
            --arg sha256 = "$sha256_hash" \
            --arg sha512 = "$sha512_hash" \
            --arg size = "$zip_size" \
            '{directory_name: $directory_name, version_number: $version_number, dependencies: $dependencies, game_versions: $game_versions, version_type: $version_type, changelog: $changelog, loaders: $loaders, featured: $featured, files: [{"hashes": {"sha256": $sha256, "sha512": $sha512}, "filename": $filename, "primary": $primary, "size": ($size | tonumber), "file_type": "required-resource-pack"}]}')

    # Send the POST request using curl
    curl -X POST "https://api.modrinth.com/v2/project/$project_id/version_number" \
        -H "Authorization: Bearer $MODRINTH_TOKEN" \
        -H "Content-Type: application/json" \
        -d "$post_data"

    if [ $? -eq 0 ]; then
        echo "Version creation successful for $directory_name $version_number"
    else
        echo "Version creation failed for $directory_name $version_number"
    fi
done
