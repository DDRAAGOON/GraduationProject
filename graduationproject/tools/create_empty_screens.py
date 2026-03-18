import os

import fitz  # PyMuPDF


def ensure_dir(path: str) -> None:
    os.makedirs(path, exist_ok=True)


def touch_if_missing(path: str) -> None:
    if os.path.exists(path):
        return
    with open(path, "w", encoding="utf-8", newline="\n"):
        pass


def create_numbered_files(pdf_path: str, out_dir: str, prefix: str) -> int:
    doc = fitz.open(pdf_path)
    total = len(doc)
    ensure_dir(out_dir)

    for i in range(total):
        n = i + 1
        file_path = os.path.join(out_dir, f"{prefix}_screen_{n:02d}.dart")
        touch_if_missing(file_path)

    return total


def main() -> None:
    project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
    lib_dir = os.path.join(project_root, "lib")

    mappings = [
        (r"c:\Users\DRAGON\Desktop\project\user\user.pdf", os.path.join(lib_dir, "screens", "user"), "user"),
        (r"c:\Users\DRAGON\Desktop\project\company\company.pdf", os.path.join(lib_dir, "screens", "company"), "company"),
    ]

    for pdf_path, out_dir, prefix in mappings:
        total = create_numbered_files(pdf_path=pdf_path, out_dir=out_dir, prefix=prefix)
        print(f"{prefix}: {total} files -> {out_dir}")


if __name__ == "__main__":
    main()

