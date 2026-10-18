# TurboKiller

[English](../../README.md) | [简体中文](zh-CN.md) | [繁體中文](zh-TW.md) | [日本語](ja.md) | [한국어](ko.md) | [Deutsch](de.md) | [Français](fr.md) | [Español](es.md) | [Português (Brasil)](pt-BR.md) | [Português (Portugal)](pt-PT.md) | [Italiano](it.md) | [Русский](ru.md) | [Türkçe](tr.md) | [Bahasa Indonesia](id.md) | [Tiếng Việt](vi.md) | [العربية](ar.md) | [עברית](he.md)

Daha sessiz bir Mac için Turbo Boost’u kapatın; tam performans gerektiğinde geri açın.

## İndir

[İndir](https://github.com/nicotech-studio/turbo-killer/releases/latest) · [TurboKiller](https://turbokiller.nicotech.cc/?lang=tr)

Hayır. macOS 13 veya üzeri çalıştıran uyumlu bir Intel Mac gerekir.

Hayır. Sistem Bütünlüğü Koruması açık kalsın; güvenlik ayarlarını değiştirmek yerine sorunu bildirin.

## Kurulum

1. DMG dosyasını açıp TurboKiller’ı Uygulamalar’a sürükleyin.
2. Uygulamayı açın. Engellenirse: Sistem Ayarları → Gizlilik ve Güvenlik → Yine de Aç.
3. İstenirse arka planda çalışmaya izin verin; uzantı onayı veya yeniden başlatma yönergelerini izleyin.

TurboKiller’dan çıkın ve Uygulamalar’daki kopyayı TurboKiller-1.2.0.dmg içindeki uygulamayla değiştirin. İstenirse izin veya yeniden başlatma yönergelerini izleyin.

Uygulama ve hizmet Developer ID ile imzalıdır. Bu sürüm Apple noter onayına sahip değildir; macOS ilk açılışı engelleyebilir. Yalnızca resmî depodan indirin. Güncellemeden önce eski uygulamadan çıkın.

## Kullanım

Isıyı ve fan sesini azaltmak için “Turbo Boost’u kapat”, performans için “Turbo Boost’u geri aç” seçeneğini kullanın. Kapatmak yoğun görevleri yavaşlatabilir. Değişiklikten sonra durumu kontrol edin; hata olursa art arda tıklamayın.

Durumu menü çubuğundaki rüzgâr simgesinden görün

## Sürüm notları · 1.2.0

- Sabit rüzgâr simgesinin üzerindeki tek renkli küçük işaret Turbo Boost’un açık, kapalı veya bilinmeyen durumunu gösterir.
- Durum ve denetim odaklı küçük pencere; desteklenmeyen Mac’lerde bunun yerine açıklama gösterilir. Ayarlar ve Çıkış her zaman kullanılabilir.
- Uygulama, site, README ve bu notlarda 17 dil sürümü; sağdan sola düzenle Arapça ve İbranice dâhil.
- Başlangıçta, uykudan uyanınca, işlemlerden sonra ve düzenli aralıklarla arka planda durum yenileme.

[Sürüm notları](../../docs/releases/1.2.0/tr.md)

## Geri bildirim

Deneyseldir ve bazı Intel Mac’lerde denenmiştir. Her donanım ve macOS yapılandırmasıyla uyumluluk garanti edilmez. Sorunları GitHub’da Mac modeli, macOS ve uygulama sürümleri ve tam hata metni veya ekran görüntüsüyle bildirin. Başarılı uyumluluk bildirimleri de değerlidir.

[Sorun bildir](https://github.com/nicotech-studio/turbo-killer/issues/new?template=report.tr.yml)

## Geliştiriciler için

SwiftUI menü çubuğu uygulaması, XPC üzerinden ayrıcalıklı bir arka plan hizmetiyle iletişim kurar. Hizmet, birlikte gelen eski çekirdek uzantısını yükler veya bellekten kaldırır. Durum uzantının yüklenme durumunu gösterir, CPU frekansını ölçmez. Derlemek için TurboKiller.xcodeproj dosyasını Xcode’da açın. Tarihî uzantı paketini değiştirmeyin.

[SHA-256](../../LegacyKextIntegrity.swift)

## Destekle

TurboKiller ücretsiz ve açık kaynaklıdır. İşinize yarıyorsa bana bir kahve ısmarlayabilirsiniz.

[Bana bir kahve ısmarla](https://ko-fi.com/hello_nico_chan)

## Lisans

[GPL-2.0](../../LICENSE) · [Üçüncü taraf bildirimleri](../../THIRD_PARTY_NOTICES.md)
