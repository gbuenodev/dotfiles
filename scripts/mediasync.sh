mkdir -p "$src/movies" "$src/shows"

# Nothing to send: exit without touching the network
if [[ -z "$(find "$src" -type f ! -name .DS_Store -print -quit)" ]]; then
  exit 0
fi

echo "==> $(date '+%F %T') rsync $src/ -> $dest/"
rsync -a --partial --remove-source-files --chmod=D0755,F0644 \
  --exclude .DS_Store "$src/" "$dest/"

# rsync removes the files it sent; drop the folders they leave behind
find "$src" -mindepth 2 -name .DS_Store -delete
find "$src" -mindepth 2 -type d -empty -delete
