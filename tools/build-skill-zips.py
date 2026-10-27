"""Build claude.ai skill zips: <skills_dir>/<name>/SKILL.md -> <skills_dir>/<name>.zip

Usage:  python tools/build-skill-zips.py [skills_dir]      (default: skills)

Paths inside the zip use forward slashes ("name/SKILL.md"). Compress-Archive in
Windows PowerShell 5.1 writes backslashes, which claude.ai may reject.
Refuses to build a skill that still contains <PLACEHOLDERS> such as <INBOX_FOLDER_ID>.
"""
import pathlib
import re
import sys
import zipfile

PLACEHOLDER = re.compile(r"<[A-Z][A-Z0-9_ '’]+>")


def main() -> int:
    skills_dir = pathlib.Path(sys.argv[1] if len(sys.argv) > 1 else "skills")
    if not skills_dir.is_dir():
        print(f"Folder not found: {skills_dir}")
        return 1
    built, skipped = 0, 0
    for skill in sorted(p for p in skills_dir.iterdir() if (p / "SKILL.md").is_file()):
        text = (skill / "SKILL.md").read_text(encoding="utf-8")
        left = sorted(set(PLACEHOLDER.findall(text)))
        if left:
            print(f"SKIP {skill.name}: fill these first -> {', '.join(left)}")
            skipped += 1
            continue
        target = skills_dir / f"{skill.name}.zip"
        with zipfile.ZipFile(target, "w", zipfile.ZIP_DEFLATED) as z:
            for f in sorted(skill.rglob("*")):
                if f.is_file():
                    z.write(f, f.relative_to(skills_dir).as_posix())
        print(f"OK   {target}")
        built += 1
    print(f"Built {built}, skipped {skipped}.")
    return 0 if built or not skipped else 2


if __name__ == "__main__":
    sys.exit(main())
