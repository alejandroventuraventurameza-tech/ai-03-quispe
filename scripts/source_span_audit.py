#!/usr/bin/env python3
"""Build a descriptive (NOT semantic-certificate) source-to-Lean anchor receipt.

Reads exact downloaded arXiv source TAR in memory and the original weekly
PaperInterface.lean; hashes source TeX bytes and the full textual Spec declaration
line, and records exact LaTeX labels where they are actually found.

No arbitrary archive extraction, eval, model calls or dependency installation.
This must never be mislabeled as a v11 source-to-elaborated-Spec audit.
"""
from __future__ import annotations

import hashlib
import json
import re
import sys
import tarfile
from pathlib import Path


ROWS = (
    ("frontier_expansionSpec", "sections/03_theory.tex", "prop:frontier", "paper_source"),
    ("activation_bandSpec", "sections/03_theory.tex", "prop:band", "paper_source"),
    ("cumulative_effect_nonnegSpec", "sections/03_theory.tex", "prop:dynamic", "paper_source"),
    ("cumulative_gap_first_differenceSpec", "sections/10_appendix.tex", None, "paper_equation_no_unique_label"),
    ("cumulative_effect_strict_mono_closedFrontierSpec", "sections/03_theory.tex", "prop:dynamic", "corrected_domain"),
    ("cumulative_effect_strict_concave_closedFrontierSpec", "sections/03_theory.tex", "prop:dynamic", "corrected_domain"),
    ("cumulative_effect_endpoint_flatSpec", "sections/10_appendix.tex", None, "reviewer_counterexample_not_source_theorem"),
    ("specialist_heterogeneitySpec", "sections/10_appendix.tex", "prop:specialist", "paper_source"),
    ("repository_expansionSpec", "sections/10_appendix.tex", "prop:repos", "paper_source"),
)


def sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def main(archive: Path, lean_spec_path: Path, output: Path) -> None:
    spec_text = lean_spec_path.read_text(encoding="utf-8")
    spec_lines = spec_text.splitlines()
    tex_members: dict[str, bytes] = {}
    with tarfile.open(archive, mode="r:*") as tf:
        for member in tf.getmembers():
            if member.isfile() and member.name in {row[1] for row in ROWS}:
                stream = tf.extractfile(member)
                if stream is not None:
                    tex_members[member.name] = stream.read()

    rows: list[dict] = []
    for name, path, label, source_kind in ROWS:
        declaration_hits = [
            idx for idx, line in enumerate(spec_lines)
            if re.match(r"^\s*def\s+" + re.escape(name) + r"\s*:\s*Prop\s*:=", line)
        ]
        if len(declaration_hits) != 1:
            raise RuntimeError(f"Expected exactly one textual Spec {name}; found {len(declaration_hits)}")

        declaration_idx = declaration_hits[0]
        declaration_line = spec_lines[declaration_idx]
        tex_bytes = tex_members.get(path)
        if tex_bytes is None:
            raise RuntimeError(f"Original TeX member {path} absent from pinned source archive")

        source_lines = tex_bytes.decode("utf-8", errors="replace").splitlines()
        literal_label = r"\label{" + label + "}" if label else None
        located_at = (
            [idx + 1 for idx, line in enumerate(source_lines) if literal_label in line]
            if literal_label is not None else []
        )
        rows.append({
            "spec_name": name,
            "spec_path": str(lean_spec_path),
            "spec_declaration_line": declaration_idx + 1,
            "spec_text_line_sha256": sha256(declaration_line.encode("utf-8")),
            "source_tex_path": path,
            "source_tex_sha256": sha256(tex_bytes),
            "expected_label": literal_label,
            "source_label_matches_at_lines": located_at,
            "source_kind": source_kind,
            "source_text_semantic_comparison_passed": False,
            "expanded_lean_spec_semantic_comparison_passed": False,
        })

    out = {
        "receipt_kind": "versioned_source_anchor_candidate_NOT_semantic_v11_receipt",
        "source_archive": "https://arxiv.org/src/2605.25438v2",
        "source_archive_sha256": sha256(archive.read_bytes()),
        "original_lean_spec_file_sha256": sha256(lean_spec_path.read_bytes()),
        "rows": rows,
        "source_first_atom_inventory_complete": False,
        "formal_semantic_validation_passed": False,
        "limitations": (
            "Label and textual-declaration hashes are anchors only. "
            "No source-atom-to-elaborated-Spec comparison or signed v11 receipt."
        ),
    }
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(out, indent=2, ensure_ascii=True) + "\n", encoding="utf-8")
    print("rows_recorded=", len(rows))
    for row in rows:
        print(
            f"anchor={row['spec_name']} source={row['source_tex_path']} "
            f"label_lines={row['source_label_matches_at_lines']} "
            f"source_kind={row['source_kind']}"
        )


if __name__ == "__main__":
    if len(sys.argv) != 4:
        raise SystemExit("usage: source_span_audit.py SOURCE_TAR SPEC_FILE OUTPUT_JSON")
    main(Path(sys.argv[1]), Path(sys.argv[2]), Path(sys.argv[3]))
