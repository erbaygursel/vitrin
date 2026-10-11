# Vitrin — çalışma kuralları

Erbay Gürsel'in matematik ve algoritma animasyonlarını sergileyen tek sayfalık site.
Yayın: GitHub Pages, `main` dalından → https://erbaygursel.github.io/vitrin/

## Yapı
- `index.html` — sitenin tamamı. Derleme adımı, paket, framework yok; CSS sayfanın içinde.
- `videolar/<ad>.mp4` — işlenmiş videolar.
- `kapaklar/<ad>.jpg` — her videonun kapak görseli. Dosya adı videoyla aynı.
- `README.md` — GitHub'da görünen tablo; siteyle aynı videoları listeler.
- `araclar/video-ekle.sh` — yeni videoyu sıkıştırır ve kapağını üretir.

Animasyonların kaynak kodu (HyperFrames, three.js, Canvas projeleri) bu depoda **değil**;
buraya yalnızca bitmiş video gelir.

## Dil ve üslup
- Her şey Türkçe: sayfa metni, commit mesajları, dosya adları (küçük harf, tire, Türkçe karakter yok: `ikili-arama`).
- Kısa ve somut yaz. Kart açıklaması 1–2 cümle; abartı sıfatı yok.
- Her kartta bir `p.nasil` satırı var: "Nasıl:" (teknik yöntem) ya da "Neden:" (anlatım tercihi) ile başlar.
  Videoyu izleyenin göremeyeceği bir şeyi söylemeli.

## Tasarım (değiştirme, yeniden kullan)
- Renkler `:root` değişkenlerinde: `--kraft` arka plan, `--kart`, `--antrasit` metin, `--soluk`, `--sari` vurgu, `--cizgi`.
  Yeni renk ekleme; gerekiyorsa önce sor.
- Yazı tipleri: başlıklar Fraunces, gövde Inter, etiket ve kod JetBrains Mono.
- Izgara 2 sütun, 720 px altında tek sütun. Uzun ya da öne çıkan videolar `kart genis` (tam genişlik).
- Sayfanın 360 px genişlikte yatay kaydırma olmadan çalışması gerekir.

## Yeni video ekleme
1. `araclar/video-ekle.sh <kaynak.mp4> <ad> [kapak-saniyesi]` çalıştır.
   Betik videoyu 1080p H.264'e (CRF 26, faststart) sıkıştırıp `videolar/<ad>.mp4` olarak kaydeder,
   kapağı 960×540 `kapaklar/<ad>.jpg` olarak üretir ve kullanılacak süreyi yazar.
2. `index.html` içinde `<section class="izgara">` altına şu kartı ekle (yeni videolar en üste):

```html
<article class="kart">
  <video controls preload="none" playsinline poster="kapaklar/AD.jpg" src="videolar/AD.mp4"></video>
  <div class="bilgi">
    <h3>Başlık</h3>
    <p>Videonun anlattığı şey, 1–2 cümle.</p>
    <p class="nasil">Nasıl: …</p>
    <div class="araclar"><span>Araç</span><span>NN sn</span></div>
  </div>
</article>
```

3. `README.md` tablosuna aynı sırayla bir satır ekle (kapak 240 px, başlık, süre, araçlar).
4. Kontrol: `python3 -m http.server` ile sayfayı açıp videonun oynadığını ve kapağın göründüğünü doğrula.

## Sınırlar
- Video başına hedef 15 MB'ın altı. GitHub 100 MB'tan büyük dosyayı reddeder; 50 MB üstü uyarı verir.
- `preload="none"` kalmalı; sayfa açılışta video indirmemeli.
- `og:image` paylaşım görseli `kapaklar/` içinden bir kapak olmalı (şu an `bayes.jpg`).
- Videolar ve kapaklar ikili dosya; gereksiz yere yeniden kodlayıp commit'leme, depo şişer.
