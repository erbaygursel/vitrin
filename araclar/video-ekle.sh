#!/usr/bin/env bash
# Kullanım: araclar/video-ekle.sh <kaynak.mp4> <ad> [kapak-saniyesi]
# Videoyu vitrine uygun biçime sıkıştırır ve kapak görselini üretir.
set -euo pipefail

if [ $# -lt 2 ]; then
  echo "Kullanım: $0 <kaynak.mp4> <ad> [kapak-saniyesi]" >&2
  exit 1
fi

kaynak=$1
ad=$2
kapak_sn=${3:-}
kok=$(cd "$(dirname "$0")/.." && pwd)
video="$kok/videolar/$ad.mp4"
kapak="$kok/kapaklar/$ad.jpg"

if [[ ! "$ad" =~ ^[a-z0-9-]+$ ]]; then
  echo "Ad yalnızca küçük harf, rakam ve tire içermeli: $ad" >&2
  exit 1
fi

sure=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$kaynak")
# Kapak saniyesi verilmediyse videonun ortasından al
if [ -z "$kapak_sn" ]; then
  kapak_sn=$(awk -v s="$sure" 'BEGIN { printf "%.2f", s / 2 }')
fi

ffmpeg -v error -y -i "$kaynak" \
  -vf "scale='min(1920,iw)':-2" -c:v libx264 -preset slow -crf 26 -pix_fmt yuv420p \
  -c:a aac -b:a 128k -movflags +faststart "$video"

ffmpeg -v error -y -ss "$kapak_sn" -i "$video" -frames:v 1 \
  -vf "scale=960:540:force_original_aspect_ratio=decrease,pad=960:540:(ow-iw)/2:(oh-ih)/2" -q:v 3 "$kapak"

boyut=$(du -m "$video" | cut -f1)
echo "Video : videolar/$ad.mp4 (${boyut} MB)"
echo "Kapak : kapaklar/$ad.jpg (${kapak_sn}. saniye)"
echo "Süre  : $(awk -v s="$sure" 'BEGIN { printf "%d", s + 0.5 }') sn"
if [ "$boyut" -gt 15 ]; then
  echo "Uyarı: video 15 MB'ı aşıyor; CRF'yi yükseltmeyi ya da süreyi kısaltmayı düşün." >&2
fi
