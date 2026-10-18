<div dir="rtl" lang="he">

# TurboKiller

[English](README.md) | [简体中文](README.zh-CN.md) | [繁體中文](README.zh-TW.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | [Deutsch](README.de.md) | [Français](README.fr.md) | [Español](README.es.md) | [Português (Brasil)](README.pt-BR.md) | [Português (Portugal)](README.pt-PT.md) | [Italiano](README.it.md) | [Русский](README.ru.md) | [Türkçe](README.tr.md) | [Bahasa Indonesia](README.id.md) | [Tiếng Việt](README.vi.md) | [العربية](README.ar.md) | [עברית](README.he.md)

כבו את Turbo Boost ל-Mac שקט יותר, ושחזרו אותו כשנדרשים ביצועים מלאים.

## הורדה

[הורדה](https://github.com/nicotech-studio/turbo-killer/releases/latest) · [TurboKiller](https://turbokiller.nicotech.cc/?lang=he)

לא. נדרש Mac תואם עם Intel ו-macOS 13 ואילך.

לא. השאירו את הגנת שלמות המערכת פעילה ודווחו על בעיות במקום לשנות את הגדרות האבטחה.

## התקנה

1. פתחו את ה-DMG וגררו את TurboKiller לתיקיית היישומים.
2. פתחו את היישום. אם הוא נחסם: הגדרות המערכת ← פרטיות ואבטחה ← פתיחה בכל זאת.
3. אפשרו פעולה ברקע אם תתבקשו ופעלו לפי הוראות אישור ההרחבה או ההפעלה מחדש.

צאו מ-TurboKiller והחליפו את היישום בתיקיית היישומים בגרסה מתוך TurboKiller-1.2.0.dmg. פעלו לפי בקשות האישור או ההפעלה מחדש, אם יופיעו.

היישום והשירות חתומים באמצעות Developer ID. גרסה זו לא עברה אישור נוטריוני של Apple ו-macOS עלולה לחסום את ההפעלה הראשונה. הורידו רק מהמאגר הרשמי. צאו מהיישום הישן לפני החלפתו.

## אופן השימוש

בחרו «כיבוי Turbo Boost» להפחתת החום ורעש המאווררים, ו«שחזור Turbo Boost» כשנדרשים ביצועים. הכיבוי עלול להאט משימות כבדות. בדקו את המצב לאחר ההחלפה; במקרה של שגיאה אל תלחצו שוב ושוב.

המצב מוצג על סמל הרוח בשורת התפריטים

## הערות גרסה · 1.2.0

- סמל רוח קבוע עם תג חד-צבעי המציג אם Turbo Boost פועל, כבוי או שמצבו אינו ידוע.
- חלון קומפקטי למצב ולשליטה; במחשבי Mac שאינם נתמכים מוצגת הודעה במקומו. ההגדרות והיציאה זמינות תמיד.
- 17 גרסאות שפה ליישום, לאתר, ל-README ולהערות אלה, כולל ערבית ועברית עם פריסה מימין לשמאל.
- רענון המצב בהפעלה, בהתעוררות, לאחר פעולות ובאופן תקופתי ברקע.

[הערות גרסה](docs/releases/1.2.0/he.md)

## משוב

עדיין ניסיוני ונבדק בחלק ממחשבי ה-Mac עם Intel. התאימות לכל תצורות החומרה וגרסאות macOS אינה מובטחת. דווחו על בעיות ב-GitHub בצירוף דגם ה-Mac, גרסאות macOS והיישום וטקסט השגיאה המלא או צילום מסך. נשמח גם לדיווחים על תאימות מוצלחת.

[דיווח על בעיה](https://github.com/nicotech-studio/turbo-killer/issues/new?template=report.he.yml)

## למפתחים

יישום שורת התפריטים ב-SwiftUI מתקשר באמצעות XPC עם שירות רקע בעל הרשאות שטוען או פורק את הרחבת הליבה הישנה המצורפת. המצב משקף את טעינת ההרחבה ואינו מודד את תדר המעבד. פתחו את TurboKiller.xcodeproj ב-Xcode לצורך בנייה. השאירו את חבילת ההרחבה ההיסטורית ללא שינוי.

[SHA-256](LegacyKextIntegrity.swift)

## תמיכה

TurboKiller חינמי ובקוד פתוח. אם הוא עוזר לכם, אפשר להזמין אותי לקפה.

[אפשר להזמין אותי לקפה](https://ko-fi.com/hello_nico_chan)

## רישיון

[GPL-2.0](LICENSE) · [הודעות צד שלישי](THIRD_PARTY_NOTICES.md)

</div>
