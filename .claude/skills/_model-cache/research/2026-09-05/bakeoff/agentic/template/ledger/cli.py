import sys
from .core import parse_entry, total, filter_since


def main(argv=None):
    argv = list(sys.argv[1:] if argv is None else argv)
    raise NotImplementedError("--since and FILE handling not implemented yet")


if __name__ == "__main__":
    main()
