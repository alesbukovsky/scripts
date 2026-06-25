#!/usr/bin/env python3
"""Slice an image into US Legal-sized tiles and stitch into a PDF."""

import argparse
import logging
import math
import os
import shutil
import subprocess
import sys
import tempfile

import img2pdf

LETTER_WIDTH_IN  = 8.5
LETTER_HEIGHT_IN = 11.0

log = logging.getLogger(__name__)


def die(msg: str) -> None:
    log.error(msg)
    sys.exit(1)


def require_magick() -> None:
    if not shutil.which("magick"):
        die("ImageMagick (magick) not found")


def run(cmd: list[str]) -> str:
    res = subprocess.run(cmd, capture_output=True, text=True)  # noqa: S603
    if res.returncode != 0:
        die(f"Command failed:\n{' '.join(cmd)}\n{res.stderr.strip()}")
    return res.stdout


def main() -> None:
    logging.basicConfig(level=logging.INFO, format="%(message)s")

    parser = argparse.ArgumentParser(
        description="Slice an image into US Legal-sized tiles and stitch into a PDF",
        epilog="Requires ImageMagick (magick) on the PATH",
    )
    parser.add_argument("input", help="input image file")
    parser.add_argument("ppi", type=int, help="tile resolution")
    parser.add_argument("output", help="output .pdf file")

    args = parser.parse_args()
    if args.ppi <= 0:
        parser.error("Resolution must be a positive integer")
    if not args.output.lower().endswith(".pdf"):
        parser.error("Output file must have a .pdf extension")

    if not os.path.isfile(args.input):
        die(f"Input file not found: {args.input}")

    require_magick()

    log.info("Measuring input...")
    out = run(["magick", "identify", "-format", "%w %h", args.input])
    img_w, img_h = (int(x) for x in out.strip().split())

    tile_w = round(LETTER_WIDTH_IN  * args.ppi)
    tile_h = round(LETTER_HEIGHT_IN * args.ppi)

    # canvas is an exact multiple of tile size so there are no ragged edges
    canvas_w = math.ceil(img_w / tile_w) * tile_w  # columns * tile width
    canvas_h = math.ceil(img_h / tile_h) * tile_h  # rows * tile height

    with tempfile.TemporaryDirectory(prefix="tiler_") as dir:

        padded = os.path.join(dir, "padded.png")

        log.info("Padding input...")
        run([
            "magick", args.input,
            "-background", "white",
            "-gravity", "NorthWest",  # anchor image to top-left corner 
            "-extent", f"{canvas_w}x{canvas_h}",
            padded
        ])

        log.info("Slicing into tiles...")
        run([
            "magick", padded,
            "-crop", f"{tile_w}x{tile_h}",
            "+repage",
            "-alpha", "off",  # remove transparency
            os.path.join(dir, "tile_%04d.png"),
        ])

        log.info("Collecting tiles...")
        tiles = sorted(
            os.path.join(dir, f)
            for f in os.listdir(dir)
            if f.startswith("tile_") and f.endswith(".png")
        )
        if not tiles:
            die("No tiles produced, check ImageMagick security policy")

        log.info("Writing output...")
        layout = img2pdf.get_fixed_dpi_layout_fun((args.ppi, args.ppi))
        with open(args.output, "wb") as fh:
            fh.write(img2pdf.convert(tiles, layout_fun=layout))

    log.info("Done")


if __name__ == "__main__":
    main()