import os

import fitz  # PyMuPDF


def render(pdf_path: str, out_dir: str, max_pages: int, prefix: str) -> list[str]:
    os.makedirs(out_dir, exist_ok=True)
    doc = fitz.open(pdf_path)
    written: list[str] = []

    for i in range(min(len(doc), max_pages)):
        page = doc[i]
        mat = fitz.Matrix(2, 2)
        pix = page.get_pixmap(matrix=mat, alpha=False)
        out_path = os.path.join(out_dir, f"{prefix}p{i + 1:02d}.png")
        pix.save(out_path)
        written.append(out_path)

    return written


def main() -> None:
    project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
    out_dir = os.path.join(project_root, ".tmp_pdf")

    pdfs = [
        (r"c:\Users\DRAGON\Desktop\project\user\user.pdf", "user_"),
        (r"c:\Users\DRAGON\Desktop\project\company\company.pdf", "company_"),
    ]

    for pdf_path, prefix in pdfs:
        paths = render(pdf_path=pdf_path, out_dir=out_dir, max_pages=10_000, prefix=prefix)
        for p in paths:
            print(p)


if __name__ == "__main__":
    main()

