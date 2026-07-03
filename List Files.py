from pathlib import Path

IGNORE_DIRS = {".git",".idea","__pycache__","bin","obj"}
IGNORE_FILES = {".gitkeep"}


def print_tree(path: Path, prefix: str = ""):
    try:
        items = sorted(
            [
                item for item in path.iterdir()
                if item.name not in IGNORE_DIRS
                and item.name not in IGNORE_FILES
            ],
            key=lambda p: (p.is_file(), p.name.lower())
        )
    except PermissionError:
        print(f"{prefix}[ACCESS DENIED]")
        return

    for index, item in enumerate(items):
        connector = "└── " if index == len(items) - 1 else "├── "
        print(prefix + connector + item.name)

        if item.is_dir():
            extension = "    " if index == len(items) - 1 else "│   "
            print_tree(item, prefix + extension)


if __name__ == "__main__":
    root = Path.cwd()

    print(root.name)
    print_tree(root)