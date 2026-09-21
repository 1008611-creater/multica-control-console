#!/usr/bin/env python3
"""Validate an original-image Xiaohongshu draft without accounts or credentials."""

from __future__ import annotations

import hashlib
import re
import sys
from pathlib import Path


def fail(message: str) -> None:
    print(f"FAIL: {message}")
    raise SystemExit(1)


def digest(path: Path) -> str:
    value = hashlib.sha256()
    with path.open("rb") as stream:
        for part in iter(lambda: stream.read(1024 * 1024), b""):
            value.update(part)
    return value.hexdigest()


def main() -> None:
    if len(sys.argv) != 2:
        fail("usage: validate_draft.py <draft-directory>")
    root = Path(sys.argv[1]).resolve()
    post = root / "xhs-post.md"
    source = root / "source"
    if not post.is_file():
        fail("missing xhs-post.md")
    if not source.is_dir():
        fail("missing source directory")
    content = post.read_text(encoding="utf-8")
    title = re.search(r"## 标题\s+`?([^`\n]+)`?", content)
    if not title:
        fail("missing title under ## 标题")
    if len(title.group(1).strip()) > 20:
        fail("title exceeds 20 characters")
    names = re.findall(r"`source/([^`]+)`", content)
    if not 1 <= len(names) <= 18:
        fail("declared image count must be 1-18")
    if len(set(names)) != len(names):
        fail("duplicate image path in declared order")
    hashes: set[str] = set()
    for name in names:
        image = source / name
        if not image.is_file():
            fail(f"missing declared image: {name}")
        value = digest(image)
        if value in hashes:
            fail(f"duplicate image content: {name}")
        hashes.add(value)
    print(f"PASS: images={len(names)}; unique_sha256={len(hashes)}")


if __name__ == "__main__":
    main()
