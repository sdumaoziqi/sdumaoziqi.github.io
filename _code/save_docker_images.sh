docker images --format "{{.Repository}}:{{.Tag}}" > images_list.txt

# while read image; do
#   docker save -o "./docker_images/${image//[:\/]/_}.tar" "$image"
# done < images_list.txt