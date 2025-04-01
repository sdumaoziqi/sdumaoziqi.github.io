for file in /path/to/directory/*.tar; do
  docker load -i "$file"
done