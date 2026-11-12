"""Write the appcasts for supported installed versions before Sparkle signs them."""

import json
import re
import sys
import xml.etree.ElementTree as ET
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
FIRST_UPDATABLE_RELEASE = (1, 3, 1)
SPARKLE = "http://www.andymatuschak.org/xml-namespaces/sparkle"
XML_LANGUAGE = "{http://www.w3.org/XML/1998/namespace}lang"
ET.register_namespace("sparkle", SPARKLE)


def version_key(version):
    return tuple(map(int, version.split(".")))


def notes_body(path, version, language_links):
    heading, navigation, body = path.read_text(encoding="utf-8").strip().split("\n\n", 2)
    if heading != f"# TurboKiller {version}" or navigation != language_links or not body.strip():
        raise ValueError(f"Expected a version heading, language links, and release notes in {path}")
    return body


def main(base, target, output):
    releases = ROOT / "docs/releases"
    languages = json.loads((ROOT / "docs/localization/languages.json").read_text(encoding="utf-8"))
    language_links = " | ".join(f"[{lang['name']}]({lang['id']}.md)" for lang in languages)
    versions = sorted(
        (
            path.name for path in releases.iterdir()
            if path.is_dir() and re.fullmatch(r"[0-9]+\.[0-9]+\.[0-9]+", path.name)
            and FIRST_UPDATABLE_RELEASE <= version_key(path.name) <= version_key(target)
        ),
        key=version_key,
        reverse=True,
    )
    if not versions or versions[0] != target:
        raise ValueError(f"Missing release notes for {target}")
    notes = {
        (version, lang["app"]): notes_body(
            releases / version / f"{lang['id']}.md", version, language_links
        )
        for version in versions for lang in languages
    }

    # v1.3.1 uses the root URL. Later releases embed their version in the URL.
    legacy_version = ".".join(map(str, FIRST_UPDATABLE_RELEASE))
    paths = [(legacy_version, output / "appcast.xml")]
    paths.extend((version, output / "updates" / version / "appcast.xml") for version in versions)
    for installed, destination in paths:
        tree = ET.parse(base)
        item = tree.find("./channel/item")
        for description in item.findall("description"):
            item.remove(description)
        newer = [version for version in versions if version_key(version) > version_key(installed)]
        if newer:
            for lang in languages:
                code = lang["app"]
                description = ET.SubElement(
                    item, "description", {XML_LANGUAGE: code, f"{{{SPARKLE}}}format": "markdown"}
                )
                description.text = "\n\n".join(
                    f"## TurboKiller {version}\n\n{notes[version, code]}" for version in newer
                )
        destination.parent.mkdir(parents=True, exist_ok=True)
        tree.write(destination, encoding="utf-8", xml_declaration=True)


if __name__ == "__main__":
    main(Path(sys.argv[1]), sys.argv[2], Path(sys.argv[3]))
