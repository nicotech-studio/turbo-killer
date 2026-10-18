import json,re,sys
from pathlib import Path
r=Path(__file__).resolve().parents[1];registry=json.loads((r/'docs/localization/languages.json').read_text());d=json.loads((r/'TurboKiller/Localizable.xcstrings').read_text());errors=[]
for lang in registry:
 l=lang['app']
 for key,e in d['strings'].items():
  if l=='en' or e.get('shouldTranslate')==False:continue
  u=e.get('localizations',{}).get(l,{}).get('stringUnit',{})
  if u.get('state')!='translated' or not u.get('value'):errors.append((l,key,'missing'))
  if sorted(re.findall(r'%(?:\d+\$)?[@dsf]',key))!=sorted(re.findall(r'%(?:\d+\$)?[@dsf]',u.get('value',''))):errors.append((l,key,'placeholder mismatch'))
 for path in [('README.md' if lang['id']=='en' else f"README.{lang['id']}.md"),f"docs/releases/1.2.0/{lang['id']}.md",f".github/ISSUE_TEMPLATE/report.{lang['id']}.yml"]:
  if not (r/path).is_file():errors.append((path,'missing'))
for p in [*r.glob('README*.md'),*r.glob('docs/releases/1.2.0/*.md')]:
 for link in re.findall(r'\]\(([^)]+)\)',p.read_text()):
  if not re.match(r'https?://|#',link) and not (p.parent/link.split('#')[0]).exists():errors.append((str(p),link,'broken local link'))
print(f"Checked {len(registry)} locales, {len(d['strings'])} catalog entries, README and release-note links.")
if errors:
 print(errors);sys.exit(1)
print('All checks passed.')
