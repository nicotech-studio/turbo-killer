# TurboKiller

[English](../../README.md) | [简体中文](zh-CN.md) | [繁體中文](zh-TW.md) | [日本語](ja.md) | [한국어](ko.md) | [Deutsch](de.md) | [Français](fr.md) | [Español](es.md) | [Português (Brasil)](pt-BR.md) | [Português (Portugal)](pt-PT.md) | [Italiano](it.md) | [Русский](ru.md) | [Türkçe](tr.md) | [Bahasa Indonesia](id.md) | [Tiếng Việt](vi.md) | [العربية](ar.md) | [עברית](he.md)

Nonaktifkan Turbo Boost untuk Mac yang lebih senyap dan pulihkan saat Anda memerlukan performa penuh.

## Unduh

[Unduh](https://github.com/nicotech-studio/turbo-killer/releases/latest) · [TurboKiller](https://turbokiller.nicotech.cc/?lang=id)

Tidak. TurboKiller memerlukan Mac Intel yang kompatibel dengan macOS 13 atau lebih baru.

Tidak. Biarkan Perlindungan Integritas Sistem aktif dan laporkan masalah tanpa mengubah pengaturan keamanan.

## Instal

1. Buka DMG dan seret TurboKiller ke Aplikasi.
2. Buka app. Jika diblokir: Pengaturan Sistem → Privasi & Keamanan → Tetap Buka.
3. Izinkan operasi latar belakang jika diminta, lalu ikuti petunjuk persetujuan ekstensi atau mulai ulang.

Keluar dari TurboKiller dan ganti app di Aplikasi dengan versi dari TurboKiller-1.2.0.dmg. Ikuti permintaan persetujuan atau mulai ulang jika muncul.

App dan layanannya ditandatangani dengan Developer ID. Versi ini belum dinotariskan Apple; macOS mungkin memblokir peluncuran pertama. Unduh hanya dari repositori resmi. Keluar dari app lama sebelum menggantinya.

## Cara menggunakan

Pilih “Nonaktifkan Turbo Boost” untuk mengurangi panas dan kebisingan kipas, lalu “Pulihkan Turbo Boost” saat membutuhkan performa. Menonaktifkannya dapat memperlambat tugas berat. Periksa status setelah beralih; jangan klik berulang kali jika terjadi kesalahan.

Lihat status pada ikon angin di bar menu

## Catatan rilis · 1.3.0

- Bar menu dan panel ringkas menampilkan frekuensi CPU rata-rata dari interval sampel terakhir.
- Lihat riwayat 5 menit, 15 menit, atau satu jam. Latar merah/biru muda menandai Turbo Boost aktif/nonaktif, dengan garis frekuensi dasar jika dapat diidentifikasi dengan andal.
- Pilih interval 1, 2, 5, atau 10 detik (bawaan 2). Pengaturan juga mengendalikan angka bar menu dan perekaman latar belakang.
- Riwayat hingga satu jam disimpan di memori selama sesi ini. Tidur, jeda, dan data yang hilang menyisakan celah.

[Catatan rilis](../../docs/releases/1.3.0/id.md)

## Umpan balik

Masih eksperimental dan telah diuji pada beberapa Mac Intel. Kompatibilitas dengan semua konfigurasi perangkat keras dan macOS tidak dijamin. Laporkan masalah di GitHub dengan model Mac, versi macOS dan app, serta kesalahan lengkap atau tangkapan layar. Laporan keberhasilan kompatibilitas juga diterima.

[Laporkan masalah](https://github.com/nicotech-studio/turbo-killer/issues/new?template=report.id.yml)

## Untuk pengembang

App bar menu SwiftUI berkomunikasi melalui XPC dengan layanan latar belakang berhak istimewa yang memuat atau melepas ekstensi kernel lama yang disertakan. Status mencerminkan pemuatan ekstensi, bukan pengukuran frekuensi CPU. Buka TurboKiller.xcodeproj di Xcode untuk membangun. Pertahankan bundel ekstensi historis tanpa perubahan.

[SHA-256](../../LegacyKextIntegrity.swift)

## Dukung

TurboKiller gratis dan bersumber terbuka. Jika bermanfaat, Anda dapat mentraktir saya kopi.

[Traktir saya kopi](https://ko-fi.com/hello_nico_chan)

## Lisensi

[GPL-2.0](../../LICENSE) · [Pemberitahuan pihak ketiga](../../THIRD_PARTY_NOTICES.md)
