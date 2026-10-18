video_re='\.(mkv|mp4|m4v|avi|mov|webm|ts)$'
sub_re='\.(srt|ass|ssa|vtt|sub)$'

# Jellyfin suffix for a subtitle name: "English" -> ".en", "FORCED.eng" -> ".en.forced"
sub_tag() {
  local name=${1,,} lang="" flags="" t tokens
  read -ra tokens <<<"$(tr -c '[:alnum:]-' ' ' <<<"$name")"
  for t in "${tokens[@]}"; do
    case $t in
    en | eng | english) lang=en ;;
    pt-br | ptbr | pob | pb | brazil | brazilian) lang=pt-BR ;;
    pt | por | portuguese) [[ $lang == pt-BR ]] || lang=pt ;;
    es | spa | spanish) lang=es ;;
    forced) flags+=.forced ;;
    sdh | hi | cc) flags+=.sdh ;;
    esac
  done
  if [[ -z $lang && -z $flags ]]; then
    # Unknown language: keep the original name as the tag
    name=$(tr -cs '[:alnum:]' '-' <<<"$name")
    name=${name#-}
    name=${name%-}
    [[ -n $name ]] && echo ".$name"
    return 0
  fi
  echo "${lang:+.$lang}$flags"
}

# Move the subtitles of a single-video folder next to the video, named so
# Jellyfin finds them; folders with several videos (season packs) are left as is
organize_subs() {
  local dir=$1 videos subs video base sub other name stem rest tag target n
  mapfile -t videos < <(find "$dir" -maxdepth 1 -type f | grep -Ei "$video_re")
  ((${#videos[@]} == 1)) || return 0
  video=${videos[0]}
  base=$(basename "${video%.*}")

  mapfile -t subs < <(find "$dir" -mindepth 1 -maxdepth 2 -type f | grep -Ei "$sub_re")
  for sub in "${subs[@]}"; do
    name=$(basename "$sub")
    stem=${name%.*}
    rest=${stem#"$base"}
    # Already next to the video with its name: leave it
    [[ $(dirname "$sub") == "$dir" && $rest != "$stem" ]] && continue

    tag=$(sub_tag "$stem")
    target="$dir/$base$tag.${name##*.}"
    n=1
    while [[ -e $target ]]; do
      if cmp -s "$sub" "$target"; then
        rm "$sub"
        continue 2
      fi
      target="$dir/$base$tag.$n.${name##*.}"
      n=$((n + 1))
    done
    echo "    $name -> $(basename "$target")"
    mv "$sub" "$target"
  done

  # An untagged <video>.srt that duplicates a tagged one (YTS ships the forced one twice)
  for sub in "$dir/$base".*; do
    [[ $sub =~ $sub_re && $(basename "$sub") == "$base.${sub##*.}" ]] || continue
    for other in "$dir/$base".*."${sub##*.}"; do
      if [[ -e $other ]] && cmp -s "$sub" "$other"; then
        rm "$sub"
        break
      fi
    done
  done
}

mkdir -p "$src/movies" "$src/shows"

# Nothing to send: exit without touching the network
if [[ -z "$(find "$src" -type f ! -name .DS_Store -print -quit)" ]]; then
  exit 0
fi

# Wait while qBittorrent is still moving files in (a move updates ctime),
# so a video is never sent before its subtitles
for ((i = 0; i < 30; i++)); do
  [[ -z "$(find "$src" -type f -ctime -20s -print -quit)" ]] && break
  sleep 10
done

echo "==> $(date '+%F %T') subtitles"
while IFS= read -r dir; do
  organize_subs "$dir"
done < <(find "$src/movies" "$src/shows" -mindepth 1 -type d)

find "$src" -mindepth 2 -name .DS_Store -delete
find "$src" -mindepth 2 -type d -empty -delete

echo "==> $(date '+%F %T') rsync $src/ -> $dest/"
rsync -a --partial --remove-source-files --chmod=D0755,F0644 \
  --exclude .DS_Store "$src/" "$dest/"

# rsync removes the files it sent; drop the folders they leave behind
find "$src" -mindepth 2 -name .DS_Store -delete
find "$src" -mindepth 2 -type d -empty -delete
